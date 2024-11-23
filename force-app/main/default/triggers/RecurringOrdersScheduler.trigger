/*trigger RecurringOrdersScheduler on Account (after update) {
    // Check if the recurring order fields have been updated
    Set<String> fields = new Set<String>{'Recurring_Order_Quantity__c', 'Recurring_Order_Frequency__c', 'Recurring_Order_Start_Date__c'};
    List<Account> updatedAccounts = new List<Account>();
    for(Account acc : Trigger.new) {
        Account oldAcc = Trigger.oldMap.get(acc.Id);
        if(acc.get('Recurring_Order_Quantity__c') != oldAcc.get('Recurring_Order_Quantity__c') ||
           acc.get('Recurring_Order_Frequency__c') != oldAcc.get('Recurring_Order_Frequency__c') ||
           acc.get('Recurring_Order_Start_Date__c') != oldAcc.get('Recurring_Order_Start_Date__c')) {
            updatedAccounts.add(acc);
        }
    }
    
    // If the recurring order fields have been updated, reschedule the orders
    if(!updatedAccounts.isEmpty()) {
        RecurringOrdersScheduler.rescheduleOrders();
    }
}*/
trigger RecurringOrdersScheduler on Account (after insert, after update) {
    for (Account acc : Trigger.new) {
         AccountOrderScheduler sched = new AccountOrderScheduler(acc.Id);
            sched.execute(null);
    }
}