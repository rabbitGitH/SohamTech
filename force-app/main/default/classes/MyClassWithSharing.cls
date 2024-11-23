// Class With Sharing
public with sharing class MyClassWithSharing {
   // Query To fetch 10 records
   List<customer__c> CustomerList = [SELECT id, firstName__c FROM Customer__c LIMIT 10];
   
   public Integer executeQuery1 () {
      System.debug('List will have only 5 records and the actual records are' 
         + CustomerList.size()+' as user has access to'+CustomerList);
      Integer ListSize = CustomerList.size();
      return ListSize;
   }
}

// Save the above class and then execute as below
// Execute class using the object of class