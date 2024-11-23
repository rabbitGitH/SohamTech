trigger INVRestrictToInsertIfCustomerDeactivated on invoices__c (before insert,before update){
    
    set<id>setid=new set<id>();
     for(invoices__c inv:trigger.new){
         setid.add(inv.customer__c);}
         
         for(customer__c cus:[select id,status__c from customer__c where id in:setid]){
             if(cus.status__c=='Deactivated'){
                 
                 for(invoices__c inv:trigger.new){
                 inv.addError('Selected Customer Is Deactivated Please Select Active Customer Only');
                 
                 }
                 }
                 }
                 }