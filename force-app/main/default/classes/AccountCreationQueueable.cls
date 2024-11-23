global class AccountCreationQueueable implements Queueable, Database.AllowsCallouts {
    
    
      Map<String, Object> jsonUpdates = new Map<String, Object>();
    
   public AccountCreationQueueable(Map<String, Object> updatedFields) {
     
        this.jsonUpdates = updatedFields;
    }
    
    string jsonn = JSON.serialize(jsonUpdates);
    
    
    public void execute(QueueableContext context) {
         
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PatilCorpp/services/apexrest/account');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonn);
        HttpResponse res = new Http().send(req);
        System.debug('res: ' + res);
        // Handle the response as needed
}

}