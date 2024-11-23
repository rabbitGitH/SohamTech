/*trigger test21212 on Attachment (before delete,before update) {
    
    for(attachment att : trigger.old){
        
        if()
        
        att.adderror('Sorry u cant');
        
        
    }

}
*/
trigger deleteAttach on Attachment(before delete) {

 Id profileId = userinfo.getProfileId();
 String profileName = [Select Id,name from Profile where Id =: profileId].Name;
 //if you are using Status field as picklist then write con.Status__c == 'Active'.
 //if you are using Status field as checkbox then write con.Status.
 for (Attachment con: trigger.old) {
  if (profileName != 'System Administrator') {
   if (Trigger.isBefore) {

    if (Trigger.isDelete) {

     con.adderror('You cannot delete the record');

    }
   }
  }
 }

}