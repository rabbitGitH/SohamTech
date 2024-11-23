trigger LEADFindDuplicateContacts on Lead (before insert,before update){

   for(Lead l : trigger.new){
        
       if(l.email!=null){
      
           List<Contact> conlist = [select id from contact where email=:l.email];
       
                if(conlist.size()>0)
                {
              
                     l.DuplicateContact__c = conlist[0].id;
              
                 }
                else {
                        l.DuplicateContact__c =null;
                     }
                 
                 List<Lead> leadlist = [select id from lead where email=:l.email];
                 
                     if(leadlist.size()>0)
                      {
                     
                         l.DuplicateLead__c=leadlist[0].id;
                      }
                      else{
                              l.DuplicateLead__c=null;
                          }
     }
}}