trigger trg_ContentVersion on ContentVersion (before insert) {

  for(ContentVersion attachment : Trigger.new){
        
     if(string.valueOf(attachment.FirstPublishLocationId).startswith(Customer__c.sobjecttype.getDescribe().getKeyPrefix())){
        
         Id profileId=userinfo.getProfileId();
         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
 
           if(!'System Administrator'.Equals(profileName)){
                    
                 attachment .addError('Access denied!');
                    
              }
          }
      }
 }