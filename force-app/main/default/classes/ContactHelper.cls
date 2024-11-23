public class ContactHelper 
{    
   public static void linkContact(List<contact>conlist)
   {      
       list<string> conEmails = new list<string>();
       list<contact> linkConToAccount = new list<contact>();
       list<contact> primaryContacts = new list<contact>();

       for(contact con : conlist)
       {
            if(con.email != null && con.email!='')
            {
               conEmails.add(con.email);
               linkConToAccount.add(con);
            }
       }
       Map<string,id> emailsAndIds = new Map<string,id>();
       
       for(account oneAccount : [select id,email__c from account where email__c!=NULL AND
                                                                       email__c!='' AND 
                                                                       email__c IN: conEmails  ORDER BY Id asc])      
       {
           emailsAndIds.put(oneAccount.email__c,oneAccount.id);
       }       
       if(emailsAndIds.size()>0)
       {
          for(contact con : linkConToAccount)
          {           
             con.AccountId = emailsAndIds.get(con.email);
          }
       }
       
         ContactHelper.unchecked(conlist);
   }
    
    public static void unchecked(List<contact>conlist)
    {
       set<id> contactId = new set<id>();
       set<id> AccountIDs = new set<id>();
        
           for(contact con : conlist)
           {
              if(con.Primary_Contact__c == true)
                 { 
                   contactId.add(con.id);
                   accountIds.add(con.AccountId);
                 }  
           }         
                     
                list<contact> FalsePrimaryContact = new list<contact>();  
        
                for(contact con : [select id,Primary_Contact__c from contact where id !=: contactID AND accountId =: AccountIDs AND Primary_Contact__c = true])
                {
                    con.Primary_Contact__c = false;
                    FalsePrimaryContact.add(con);
                }
                
                if(FalsePrimaryContact.size()>0)
                {        
                  update FalsePrimaryContact;
                }                
    }
 
}