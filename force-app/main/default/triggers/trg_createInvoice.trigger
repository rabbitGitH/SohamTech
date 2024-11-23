trigger trg_createInvoice on customer__c (after update){

    list<invoices__c>invlist = new list<invoices__c>();
    for(customer__c cus:trigger.new){
                
    customer__c newCus = trigger.newmap.get(cus.id);
    customer__c oldCus = trigger.oldmap.get(cus.id);
    
    if(newCus.status__c == 'Active'  &&  oldCus.status__c == 'Deactivated'){
    
       invoices__c inv = new invoices__c ();
       inv.customer__c = cus.id;
       inv.ProductInformation__c = 'Active customer' +cus.name;
       invlist.add(inv);
       }
       insert invlist;
       }
       }