@isTest

private class INVLastUpdatedInvoiceTest {

@isTest

static void test() {

   customer__c cus = new customer__c ();
   insert cus;
   
   invoices__c inv = new invoices__c ();
   inv.LastUpdatedInvoice__c=true;
   inv.customer__c = cus.id;
   insert inv;
   
   invoices__c inv1 = new invoices__c ();
   inv1.LastUpdatedInvoice__c=true;
   inv1.customer__c = cus.id;
   insert inv1; 
   }
   }