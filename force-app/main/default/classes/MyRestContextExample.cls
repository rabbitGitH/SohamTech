@RestResource(urlMapping='/MyRestContextExample/*')
global class MyRestContextExample {

    @HttpGet
    global static Account doGet() {
       
        RestRequest req = RestContext.request;
       
        String accountId =  req.params.get('Id');
        
        system.debug(accountID);
        
        Account result = [SELECT Id, Name, Phone, Website FROM Account where id=:accountId ];
        
        return result;
    }
  
}