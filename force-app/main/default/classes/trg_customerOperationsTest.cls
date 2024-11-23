@isTest 

private class trg_customerOperationsTest {

@isTest

static void test() {

    customerL__c cusL = new customerL__c ();
    insert cusL;
    
    customerL__c cusL1 = new customerL__c ();
    insert cusL1;
    
    invoicesL__c invL = new invoicesL__c ();
    invL.ProductInformation__c = 'abc';
    invL.customerL__c = cusL1.id;
    insert invL;
    
    customer__c cus = new customer__c ();
    cus.customerL__c=cusL.id;
    insert cus;
    
    cus.customerL__c=cusL1.id;
    update cus;
    
    }
    }