global class UpdateCustomerBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // specify the query to select the customer records to be updated
        String query = 'SELECT Id, information__C FROM Customer__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Customer__c> customers) {
        // iterate through the list of customer records and update their addresses
        for (Customer__c customer : customers) {
            customer.information__C = '# UPDATED BY BATCH APEX #';
        }
        // update the customer records
        update customers;
    }

    global void finish(Database.BatchableContext bc) {
        // send an email to the administrator to confirm that the batch job is complete
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'ptlhrsl@gmail.com' });
        email.setSubject('Update Customer Batch Job Complete');
        email.setPlainTextBody('The batch job to update customer records has completed.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}