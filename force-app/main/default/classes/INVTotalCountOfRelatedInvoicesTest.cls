@isTest

private class INVTotalCountOfRelatedInvoicesTest {

@isTest

static void test(){

  customer__c cus = new customer__c ();
  cus.TotalCountOfRelatedInvoices__c=NULL;
  insert cus;
  
  invoices__c inv = new invoices__c ();
  inv.customer__c = cus.id;
  insert inv;
  
  invoices__c inv1 = new invoices__c ();
  inv1.customer__c = cus.id;
  insert inv1;
  
  delete inv1;
  }
  }