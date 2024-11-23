// Class Without Sharing
public without sharing class MyClassWithoutSharing {
   List<customer__c> CustomerList = [SELECT id, firstName__c FROM Customer__c limit 10 ];
   
   // Query To fetch 10 records, this will return all the records
   public Integer executeQuery2 () {
      System.debug('List will have ALL records and the actula records are'
         + CustomerList.size()+' as user has access to'+CustomerList);
      Integer ListSize = CustomerList.size();
      return ListSize;
   }
}
// Output will be 10 records.