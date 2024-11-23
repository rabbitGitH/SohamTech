trigger InvoiceTrigger on Invoices__c (after insert) {
    Set<Id> customerIds = new Set<Id>();
    
    for (Invoices__c newInvoice : Trigger.new) {
        if (newInvoice.Customer__c != null) {
            customerIds.add(newInvoice.Customer__c);
        }
    }
    
    List<Invoices__c> invoicesToUpdate = new List<Invoices__c>();
    
    for (Id customerId : customerIds) {
        List<Invoices__c> customerInvoices = [SELECT Id, Date__c, master_invoice__c FROM Invoices__c WHERE Customer__c = :customerId ORDER BY Date__c ASC];
        
        if (!customerInvoices.isEmpty()) {
            // Mark the first invoice as the master
            customerInvoices[0].master_invoice__c = true;
            invoicesToUpdate.add(customerInvoices[0]);
            
            // Unmark the others
            for (Integer i = 1; i < customerInvoices.size(); i++) {
                customerInvoices[i].master_invoice__c = false;
                invoicesToUpdate.add(customerInvoices[i]);
            }
        }
    }
    
    // Perform the updates
    if (!invoicesToUpdate.isEmpty()) {
        update invoicesToUpdate;
    }
}