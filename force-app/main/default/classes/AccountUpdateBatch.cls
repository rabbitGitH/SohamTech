global class AccountUpdateBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    
    global set<Id> accountIds; 

        
        global AccountUpdateBatch(set<Id> accountIds) {
        this.accountIds = accountIds;
    }
        
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, name, phone, industry  
            FROM Account
            WHERE id =: accountIds
        ]);
    }
    
    public void execute(Database.BatchableContext context, List<sObject> scope) {
        for (Account acc : (List<Account>)scope) {
            
            // Convert the updatedFields map to JSON string
            String jsonUpdates = JSON.serialize(acc);
            System.debug('jsonUpdates: ' + acc);
            // Call the future method to send the JSON data asynchronously
            updateAccountAsync(jsonUpdates);
        }
    }
    
    public static void updateAccountAsync(String jsonUpdates) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PatilCorpp/services/apexrest/account');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonUpdates);
        HttpResponse res = new Http().send(req);
        System.debug('res: ' + res);
        // Handle the response as needed
    }
    
    public void finish(Database.BatchableContext context) {
        // Handle any post-processing tasks here
    }
    
}