trigger managername on Opportunity(after update) {
    if(Trigger.isAfter){
       if(Trigger.isUpdate){
             for(Opportunity o: Trigger.new) {
                  ManagerNameHelper.opportunityHelper(Trigger.New,
                                                       Trigger.OldMap);
                }
        }
    }
}