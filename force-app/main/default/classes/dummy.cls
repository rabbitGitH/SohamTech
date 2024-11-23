public class dummy implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
      set<id> accountids = new set<id>();
      list<contact> conList = new list<contact>();
      map<id,contact> conMap = new map<id,contact>();  
      conList = [ SELECT id,account.name,name,oppsTotalAmount__c,email,Description,accountid,primary_contact__C FROM  contact 
                                                                                        WHERE primary_contact__C = true AND 
                                                                                             accountid != NULL ];   
        
        if(conList.size()>0)
        {       
              for(contact c : conList)
              { 
                    conmap.put(c.AccountId,c);
                    accountids.add(c.accountid);
                    c.Description = '';
                    c.oppsTotalAmount__c = 0;
              }
            
        }
        
        
	Map<Id,AggregateResult> results = new Map<id,AggregateResult>
	([SELECT AccountId Id, SUM(Amount) TotalAmount FROM Opportunity WHERE AccountId != NULL GROUP BY AccountId]);
        
        system.debug('results'+results);

        
     list<opportunity> oppList = new list<opportunity>();     
     oppList = [ SELECT id,NameAmountStage__c,accountId,name,stagename,amount FROM  opportunity
                                                           WHERE accountId IN:accountids  AND 
                                                                 stagename = 'closed won' AND
                                                                 closedWonDate__c = yesterday ];
        string temp;
        for(opportunity op : oppList)
        { 
          conmap.get(op.accountid).description += op.NameAmountStage__c;
            temp = conmap.get(op.accountid).description;
                    system.debug('#######'+temp);     
        }
         update conmap.values();
        system.debug('conmap'+conmap);
           
      
    integer numCount = 0;

    for (opportunity opp : opplist) {
        if (accountids.contains(opp.accountid)){
            numCount++;
            system.debug('@@'+numCount);
    }
    }
            
      
       
  
    }            
 }