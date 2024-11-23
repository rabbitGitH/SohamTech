trigger triggerInsert on Invoices__c (after insert, after delete, after undelete) {
    
    
    set<id> cusIds = new set<id>();
    
    if(trigger.isAfter && trigger.isInsert){
    
    for(invoices__c inv:trigger.new){
        cusIds.add(inv.customer__c);
    }
    
    list<customer__c> cusList = new list<customer__c>();
    
    if(!cusIds.isEmpty()){
        
        for(customer__c cus : [select id,child_sum__c,(select id,amount__c from invoices__r) from customer__c where id in:cusIds]){
            cus.Child_SUM__c = 0;
            if(!cus.invoices__r.isEmpty()){
                
                for(invoices__c inv : cus.invoices__r){
                    
                    if(inv.amount__c != null){
                        cus.Child_SUM__c += inv.Amount__c;
                    }
                }
            }
            if(!cusList.contains(cus)){
                cusList.add(cus);
            }
        }
        
        if(!cusList.isEmpty()){
            try{
            update cusList;
            }
            catch(exception e){
                system.debug('error'+e);
            }
        }
        
    }
    }
    
    if(trigger.isAfter && trigger.isDelete){
        
           for(invoices__c inv:trigger.old){
        cusIds.add(inv.customer__c);
    }
    
    list<customer__c> cusList = new list<customer__c>();
    
    if(!cusIds.isEmpty()){
        
        for(customer__c cus : [select id,child_sum__c,(select id,amount__c from invoices__r) from customer__c where id in:cusIds]){
            cus.Child_SUM__c = 0;
            if(!cus.invoices__r.isEmpty()){
                
                for(invoices__c inv : cus.invoices__r){
                    
                    if(inv.amount__c != null){
                        cus.Child_SUM__c += inv.Amount__c;
                    }
                }
            }
            if(!cusList.contains(cus)){
                cusList.add(cus);
            }
        }
        
        if(!cusList.isEmpty()){
            try{
            update cusList;
            }
            catch(exception e){
                system.debug('error'+e);
            }
        }
        
    }
        
    }
    
    if(trigger.isAfter && trigger.isUndelete){
        
           for(invoices__c inv:trigger.new){
        cusIds.add(inv.customer__c);
    }
    
    list<customer__c> cusList = new list<customer__c>();
    
    if(!cusIds.isEmpty()){
        
        for(customer__c cus : [select id,child_sum__c,(select id,amount__c from invoices__r) from customer__c where id in:cusIds]){
            cus.Child_SUM__c = 0;
            if(!cus.invoices__r.isEmpty()){
                
                for(invoices__c inv : cus.invoices__r){
                    
                    if(inv.amount__c != null){
                        cus.Child_SUM__c += inv.Amount__c;
                    }
                }
            }
            if(!cusList.contains(cus)){
                cusList.add(cus);
            }
        }
        
        if(!cusList.isEmpty()){
            try{
            update cusList;
            }
            catch(exception e){
                system.debug('error'+e);
            }
        }
        
    }
        
    }
    
}