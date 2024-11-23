@RestResource(urlMapping='/accountUpsert/*')
global class UpsertRecordsFromPatilCorpp {
 
    @HttpPatch
    global static String updateOrCreateAccount( String 	AccountNumber, String accountData) {
        // deserialize the accountData JSON string into a Map
        Map<String, Object> accountMap = (Map<String, Object>) JSON.deserializeUntyped(accountData);
        
        // create a new Account instance and populate with the updated values
        Account acc = new Account();
      Account ac = [select id, AccountNumber from account where AccountNumber =:AccountNumber limit 1];   
        acc.Description = String.valueOf(accountMap.get('description'));
        acc.Industry = String.valueOf(accountMap.get('industry'));
        acc.id = ac.id;
        // upsert the account record based on the provided 	AccountNumber
        try {
            upsert acc;
            return 'Account with id ' + 	AccountNumber + ' has been updated/created';
        } catch (DmlException e) {
            return 'Error while updating/upserting the account record: ' + e.getMessage();
        }
    }
}