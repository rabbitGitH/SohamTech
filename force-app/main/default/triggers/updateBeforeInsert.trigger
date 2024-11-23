trigger updateBeforeInsert on Customer__c (before update) {
    
    
    for(Customer__c cus : trigger.new)
    {
        cus.FirstName__c = 'test';
        cus.LastName__c  = 'Recor';
        
        update cus;
    }

}