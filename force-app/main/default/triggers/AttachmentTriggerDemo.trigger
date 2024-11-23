trigger AttachmentTriggerDemo on Attachment (before insert,before delete,before update) {
 /*  // List accountList = new List();
    //Set accIds = new Set();
    for(Attachment att : trigger.New){
         //Check if added attachment is related to Account or not
         if(att.ParentId.getSobjectType() == Account.SobjectType){
            att.addError('Sorry, attaching file not allowed on this object');
         }
    }
    */
    
                   Id profileId=userinfo.getProfileId();
                       String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                       
                         if(!'System Administrator'.Equals(profileName)){
                       
                        if(trigger.isInsert || trigger.isUpdate){
                       
                       for(Attachment attachment : Trigger.new){
                                                                 
                                        
                                  attachment .addError('Access denied!');
                        } }
                           if(trigger.isdelete){
                           
                           for(Attachment attachment : Trigger.old){
                                                                 
                                        
                                  attachment .addError('Access denied!');
                           
                     }}
            }}