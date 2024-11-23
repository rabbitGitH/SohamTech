trigger CUSCustomerDeletion on CustomerL__c (before delete){
   
  for (CustomerL__c a : [SELECT Id FROM CustomerL__c 
                     WHERE Id IN (SELECT CustomerL__c FROM invoicesL__c) AND
                     Id IN :Trigger.old]) {
        Trigger.oldMap.get(a.Id).addError(
            'Cannot delete customer with related invoices');
    }
    
}