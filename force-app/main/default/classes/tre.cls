public class tre {
    
      
    public static void getPrimaryContactRelatedAccountClosedWonOppty(set<id> accountId,list<contact>conList)
    {
      list<opportunity> oppList = [select id,name,stagename,amount from opportunity where accountId in:accountId and stagename = 'closed won'];
      
        list<opportunity> newOpp = new list<opportunity>();
           list<contact> updateContact = new list<contact>();
        map<id,string> conDetail = new map<id,string>(); 
        
        String str = '';
        
         for(opportunity op : oppList)
        {
           for(contact con : conList)
           {
               if(op.AccountId == con.AccountId)
                   
                  con.Description += String.valueOf(op) + '\n';
               updateContact.add(con);
           }
           
        }
        update updateContact;
        
    }


}