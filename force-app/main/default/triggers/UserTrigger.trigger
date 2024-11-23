trigger UserTrigger on User (after update) {
    
    if(trigger.isAfter && trigger.isUpdate){
        
      list<user> users = new list<user>();
    
        for(user usr:trigger.new){
            users.add(usr);
        }
    
        UserHelper.helperMethod(users);
    }
}
 
 
    
  
    
    /*
    // This trigger fires after a user is updated
system.debug('one');
    // Check if the user has been deactivated
    List<Contact> opportunitiesToUpdate = new List<Contact>();
    for(User updatedUser : Trigger.new) {
        User oldUser = Trigger.oldMap.get(updatedUser.Id);

        if (updatedUser.IsActive == false && oldUser.IsActive == true) {
            // User has been deactivated, find and reassign open opportunities
            opportunitiesToUpdate.addAll([
                SELECT Id, OwnerId
                FROM Contact
                WHERE OwnerId = :updatedUser.Id
                 
            ]);
        }
    }
        system.debug('opportunitiesToUpdate'+opportunitiesToUpdate);

    // Reassign opportunities to the manager
    if (!opportunitiesToUpdate.isEmpty()) {
        for (Contact opp : opportunitiesToUpdate) {
            opp.OwnerId = opp.OwnerId = [SELECT ManagerId FROM User WHERE Id = :opp.OwnerId LIMIT 1].ManagerId;
        }
       update opportunitiesToUpdate;
        system.debug('opportunitiesToUpdate'+opportunitiesToUpdate);
    }
}
*/