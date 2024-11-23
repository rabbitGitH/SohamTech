@RestResource(urlMapping='/Rest/*')
global with sharing class Restapi {

    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }
  
 
    
     @httpGet
    global static Account doGetMethod(){
    Account acc= new Account();
    Map<String,String> paramsMap = RestContext.request.params;
    String accid=paramsMap.get('id');
    acc = [select id,name,AnnualRevenue from Account where Id =:accid];
    return acc;
    }
 
    @HttpPost
    global static void createOrUpdateInventory(String jsonBody) {
        List<Inventory__c> inventoryList = new List<Inventory__c>();
        List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(jsonBody);
        for (Object json : jsonList) {
            Map<String, Object> jsonMap = (Map<String, Object>) json;
            Inventory__c inventory = new Inventory__c();
           // inventory.Name = (String) jsonMap.get('recordName');
            inventory.Product_Name__c = (string) jsonMap.get('productName');
            inventory.Quantity_In_Stock__c = (integer) jsonMap.get('stock');
            inventoryList.add(inventory);
        }
        upsert inventoryList;
    }
 

}