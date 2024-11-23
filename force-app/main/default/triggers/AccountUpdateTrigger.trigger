trigger AccountUpdateTrigger on Account (after update) {
    // Create a list of updated Account fields
    
    set<id> setId = new set<id>();
    
    Map<String, Object> updatedFields = new Map<String, Object> ();
    for (Account newAccount : Trigger.new) {
    setId.add(newAccount.id);
    }
    
         for (Account newAccount : Trigger.new) {
        Account oldAccount = Trigger.oldMap.get(newAccount.Id);
        for (String fieldName : newAccount.getSObjectType().getDescribe().fields.getMap().keySet()) {
            Object newValue = newAccount.get(fieldName);
            system.debug('object' +newValue);
            Object oldValue = oldAccount.get(fieldName);
            if (newValue != null && !newValue.equals(oldValue)) {
                updatedFields.put(fieldName, newValue);
                system.debug('trigger');
                
            }                   
        }
    }
      
    
    system.debug('trigger records'+updatedFields);
        
    if (!updatedFields.isEmpty()) {
        
           for(integer i=1; i<=setId.size(); i++){  
               
                 AccountUpdateRestResource.processUpdatedFields(updatedFields);
            //   AccountCreationQueueable acc= new AccountCreationQueueable(updatedFields);
               
               
             //  ID jobID = System.enqueueJob(new AccountCreationQueueable(updatedFields));
            //   system.debug('jobID'+jobID);
        }
    } 
}