@RestResource(urlMapping='/account/*')
global class AccountCreateRestResource {
    @HttpPost
    global static void createAccount() {
        // Get the request body
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        System.debug('Request body: ' + requestBody);

        // Parse the request body JSON into a map
        Map<String, Object> accountFields = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        System.debug('Account fields: ' + accountFields);

        // Create the account
        Account acc = new Account();
        acc.name = (String) accountFields.get('name');
        acc.phone = (String) accountFields.get('phone');
        acc.industry = (String) accountFields.get('industry');
        
        try {
      insert acc;
        system.debug('insertdRecord'+acc);
} catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
        
      

        // Return the response
        RestResponse res = RestContext.response;
        res.statusCode = 201;
        res.responseBody = Blob.valueOf('{"success": true}');
    }
}