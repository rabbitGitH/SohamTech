public class AccountUpdateRestResource {
    
    public static void processUpdatedFields(Map<String, Object> updatedFields) {
        // Convert the updatedFields map to JSON string
        String jsonUpdates = JSON.serialize(updatedFields);
        system.debug('jsonUpdates'+jsonUpdates);
        // Call the future method to send the JSON data asynchronously
        updateAccountAsync(jsonUpdates);
    }

    // Future method to send the JSON data asynchronously
    @future(callout=true)
    public static void updateAccountAsync(String jsonUpdates) {
        HttpRequest req = new HttpRequest();
      //  req.setEndpoint('callout:PatilCorpp/services/apexrest/account');
  
        req.setEndpoint('https://davlatraolimited-dev-ed.my.salesforce.com/services/apexrest/account');
        req.setHeader('Authorization', 'Bearer 00D0o00000170rX!ARIAQNL5VojnXDmk1a1snbnaqsljy81qe.szChxqNcn1Q9ML52Blpeo__J.rJvV80o6a3Juzn3iOjerJ.j1TV3E30fyoS2RZ');
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonUpdates);

        HttpResponse res = new Http().send(req);
        system.debug('res'+res);
        // Handle the response as needed
    }
}