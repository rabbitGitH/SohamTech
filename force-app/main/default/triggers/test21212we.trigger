trigger test21212we on Note (before delete,before update) {
    
     Id pId;
     Id profileId = userinfo.getProfileId();
     
    
         for(Note n : trigger.old){
             if(n.ParentId!=Null){
         pId = n.ParentId;
             }}
     List<customer__c> cus = [select Id from customer__c where Id=:pId];
     String profileName = [Select Id,name from Profile where Id =: profileId].Name;
     if(cus.size()!=NULL && profileName != 'System Administrator'){
         
       
  for (Note con: trigger.old) {

     con.adderror('You cannot delete the record');

    }
   }
  }