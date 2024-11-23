trigger AccountBatchTrigger on Account (after update) {

    
    set<Id> accountIds = new set<Id>();
    
    for(account acc : trigger.new){
        accountIds.add(acc.id);
    }
    
    string jobID;
    
    jobId =  Database.executeBatch(new AccountUpdateBatch(accountIds), 1001);

    
    system.debug('jobId'+jobId);
}