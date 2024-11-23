trigger INVTotalCountOfRelatedInvoices on invoices__c (after insert,after delete,after undelete){
  
  set<id>cusid = new set<id>();
  list<customer__c> cuslist = new list<customer__c>();
  
          if(trigger.isInsert  ||  trigger.isUndelete){
          for(invoices__c inv : trigger.new){
          cusid.add(inv.customer__c);}
          
          for(customer__c cus : [select id,(select id from invoices__r)from customer__c where id in : cusid]){
              customer__c c = new customer__c ();
              c.TotalCountOfRelatedInvoices__c=cus.invoices__r.size();
              c.id=cus.id;
              cuslist.add(c);}}
    
                  if(trigger.isDelete){
                  for(invoices__c inv : trigger.old){
                  cusid.add(inv.customer__c);}
          
                  for(customer__c cus : [select id,(select id from invoices__r)from customer__c where id in : cusid]){
                      customer__c c = new customer__c ();
                      c.TotalCountOfRelatedInvoices__c=cus.invoices__r.size();
                      c.id=cus.id;
                      cuslist.add(c);}}
            
          update cuslist;
          }