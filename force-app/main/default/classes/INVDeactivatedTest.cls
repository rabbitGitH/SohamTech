@isTest

private class INVDeactivatedTest {

@isTest 

static void test() {
  
   customer__c cus = new customer__c ();
   cus.status__c = 'Deactivated';
   insert cus;
   
   invoices__c inv = new invoices__c ();
   inv.customer__c = cus.id;
   try{
   insert inv;
   }
    catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
}}