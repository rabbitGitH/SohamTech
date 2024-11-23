public class Scheduleclass implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
      set<id> accountids = new set<id>();
      list<contact> conList = new list<contact>();
      map<id,contact> conMap = new map<id,contact>(); 
        
      conList = [ SELECT id,account.name,name,oppsTotalAmount__c,email,Description,accountid,primary_contact__C FROM  contact 
                                                                                        WHERE primary_contact__C = true AND 
                                                                                             accountid != NULL ];   
        system.debug('conList'+conList.size());
        if(conList.size()>0)
        {       
              for(contact c : conList)
              { 
                    conMap.put(c.AccountId,c);
                    accountids.add(c.accountid);
                    c.Description = '';
                    c.oppsTotalAmount__c = 0;
              }
            
        }
      list<contact> updateContact = new list<contact>();  
     list<opportunity> oppList = new list<opportunity>();     
     oppList = [ SELECT id,NameAmountStage__c,accountId,name,stagename,amount FROM  opportunity
                                                           WHERE accountId IN:accountids  AND 
                                                                 stagename = 'closed won' AND
                                                                 closedWonDate__c = yesterday ];
           

        Decimal a3 = 0;
        if(oppList.size()>0)
        {      
       
            for(opportunity op : oppList)
            {
                
                conMap.get(op.AccountId).Description += op.NameAmountStage__c+',';
                if(op.Amount!=NULL){
                    conMap.get(op.AccountId).oppsTotalAmount__c += a3+op.amount;}
            }   
            
        }
        
          if(conMap.size()>0){
          update conMap.values();
          system.debug('updated '+conMap.size());}   
        
          Scheduleclass.sendEmail(conMap);
    }
        
        
        public static void sendEmail(map<id,contact>conMap)
        {
                
                system.debug('#conMap'+conMap);
                
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                List<string> toAddress = new List<string>();
                
                for(contact con : conMap.values())
                {               
                 //   EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName = 'Closed_Won_Opportunities'];
                    toAddress.add(con.email);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  //  mail.setTemplateId(et.Id);
                    mail.setToAddresses(toAddress);
                    mail.setSubject('CLOSED WON OPPS FOR A DAY FOR YOUR ACCOUNT :'+ con.account.Name);           
                    mail.setHTMLBody('Dear '+ con.Name +','+'\r\n'+
                                     'Look at below side for todays closed won opportunities.'+'\r\n'+
                                     'Date :'+ system.today()+'\r\n'+
                                      con.Description+'\r\n'+                            
                                     'Total Amount Of Oppty :'+ con.oppsTotalAmount__c +'\r\n'+
                                     'Thanks');
                    mail.setTargetObjectId(con.Id);
                   // mail.setWhatId(primaryAccount);
                    mail.setSaveAsActivity(false);
                    mail.setUseSignature(false);
                  
                    allmsg.add(mail);
                }        
                try {
                    Messaging.sendEmail(allmsg,false);
                    System.debug('All Msg'+allmsg.size());
                    return;
                } catch (Exception e) {
                    System.debug(e.getMessage());
                }
        }
               
 }