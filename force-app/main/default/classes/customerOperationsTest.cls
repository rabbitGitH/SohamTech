@isTest

private class customerOperationsTest {

@isTest

static void updateCustomer() {

    customerL__c cus = new customerL__c ();
    insert cus;
    
    customerL__c cus1 = new customerL__c ();
    insert cus1;
    
    invoicesL__c inv = new invoicesL__c ();
    inv.customerL__c = cus1.id;
    inv.ProductInformation__c='abc';
    insert inv;
    
    customer__c cs = new customer__c ();
    cs.customerL__c=cus.id;
    insert cs;
    
    cs.customerL__c = cus1.id;
    update cs;
    }
    }