@isTest

private class trg_restrictDeletionTest{

@isTest 

static void deleteCustomer(){

   customer__C cus = new customer__c ();
   insert cus;
   
   invoices__c inv = new invoices__c ();
   inv.customer__C = cus.id;
   insert inv;
   
   delete cus;
   
   }
   }