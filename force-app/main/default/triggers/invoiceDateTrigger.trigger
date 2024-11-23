trigger invoiceDateTrigger on Invoices__c (after update,after insert,after delete,after undelete) {

    set<id> cusId = new set<id>();
    date smallStartDate;
    date bigStartDate;
    
    if(trigger.isUpdate || trigger.isInsert || trigger.isUndelete){
    
    for(Invoices__c inv:trigger.new){
        cusId.add(inv.Customer__c);
    }
    
    list<Invoices__c> invRelatedToTheCustomer = [select id,date__c from Invoices__c where Customer__c =:cusId];
    
    for(Invoices__c inv:invRelatedToTheCustomer){
      
        if(bigStartDate<inv.Date__c || bigStartDate == null){
            bigStartDate = inv.Date__c;
        }
        if(smallStartDate>inv.Date__c || smallStartDate == null){
            smallStartDate = inv.Date__c;
        }
    }
    
    Customer__c cus = [select id,Invoice_erliest_Date__c,Invoice_latest_Date__c from Customer__c where id =: cusId];
    
    cus.Invoice_erliest_Date__c = smallStartDate;
    cus.Invoice_latest_Date__c  = bigStartDate;
    
    update cus;
    }
    
}