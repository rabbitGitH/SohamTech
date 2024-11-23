trigger ttest on invoices__c (after insert, after update){
 
        string invStatus;
        set<id>customerid = new set<id>();
        list<customer__c>customerUpdateList = new list<customer__c>();
        for(invoices__c inv:trigger.new){
            invStatus = inv.status__c;
            customerid.add(inv.customer__c);
        }
          
        for(customer__c customer:[select id,name,LastInvoiceStatus__c from customer__c where id in : customerid]){
            if(customer!=null){
            customer.LastInvoiceStatus__c=invStatus;
            customerUpdateList.add(customer);
            }
    
     try
          {
              update customerUpdateList;
          }
          catch (DmlException e)
          {
               System.debug('The following exception has occurred: ' + e.getMessage());
          }
        
        }
       }