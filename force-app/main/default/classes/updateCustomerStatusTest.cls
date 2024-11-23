@isTest

private class updateCustomerStatusTest {

@isTest 

static void tets(){
  
  
  customer__c cus = new customer__c ();
  cus.LastInvoiceStatus__c='paid';
  insert cus;
  
  invoices__c inv = new invoices__c();
  inv.status__c = 'pending';
  inv.customer__c = cus.id;
  insert inv;
  
  }
  }