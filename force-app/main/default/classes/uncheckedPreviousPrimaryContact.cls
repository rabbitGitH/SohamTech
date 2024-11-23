public class uncheckedPreviousPrimaryContact 
{   
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