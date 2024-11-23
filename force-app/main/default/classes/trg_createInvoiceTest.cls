@isTest

private class trg_createInvoiceTest {

@isTest

static void test() {

    customer__c cus = new customer__C ();
    cus.status__c = 'Deactivated';
    insert cus;
    
    cus.status__c = 'Active';
    update cus;
    
    }
    }