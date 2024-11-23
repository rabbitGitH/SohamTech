@RestResource(urlMapping='/example')
global class restExample {

    // Method to get the Account name from parameter
    
    @HttpGet
    global static void getAccountName() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String accountName = req.params.get('account_name');
      	
        // Call the method to create Account
        if(accountName != null){
        	restExample.createAcc(accountName);
        } else {
            restExample.createAcc();
        }
        
    }
    
	// Create Account when param is set 
    public static void createAcc(String accName) {
        try{
            
            Account acc = new Account(Name = accName, Description = 'Account is created by REST API');
            insert acc;
            
        } catch (Exception ex) {
           system.debug(ex.getMessage());
        }
    }
    
    // Create Account when param is not set 
    public static void createAcc() {
        try{
            
            Account acc = new Account(Name = 'Name is not set', Description = 'Account is created by REST API');
            insert acc;
            
        } catch (Exception ex) {
            system.debug(ex.getMessage());
        }
    }
}