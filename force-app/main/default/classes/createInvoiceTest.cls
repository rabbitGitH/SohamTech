@isTest

private class createInvoiceTest{

@isTest

static void updateCustomer() {

   customer__c cus = new customer__c();
   cus.status__c = 'Deactivated';
   insert cus;
   
   cus.status__c ='Active';
   update cus;
   
   }
   }