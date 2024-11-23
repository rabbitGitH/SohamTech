trigger trg_customerOperations on Customer__c (after insert,after update) {
    
    
    if((trigger.isInsert || trigger.isUpdate) && trigger.isAfter)
    {
        List<Invoices__c>  Invlist = new List<Invoices__c>();
        map<id,customer__c> customermap = new map<id,customer__c>();
        
        for(Customer__c customer : trigger.new){
            
            Customer__c oldcustomer = new customer__c();
            if(trigger.isUpdate){
                oldcustomer = trigger.oldmap.get(Customer.id);
            }
            if(trigger.isInsert || (trigger.isUpdate && customer.customerL__C!=oldcustomer.customerL__C)){
               customermap.put(customer.customerL__c,customer); 
            }
        }
        if(customermap.size()>0){
            for(InvoicesL__c inv: 
                [select id,ProductInformation__c,customerL__c from InvoicesL__c where customerL__c in:customermap.keySet()])
            {
                Invoices__c iinv = new invoices__c();
                iinv.ProductInformation__c = inv.ProductInformation__c;
                iinv.Customer__c = customermap.get(inv.customerL__c).id;
                Invlist.add(iinv);
            }
            insert Invlist;
        }
    }
}