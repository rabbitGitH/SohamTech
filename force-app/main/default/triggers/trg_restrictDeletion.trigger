trigger trg_restrictDeletion on Customer__c (before delete) {
    
    if(trigger.isBefore && trigger.isDelete){

    for(customer__c cus : [select id from customer__c where id in(select customer__c from invoices__c) and id in:trigger.old])
                                  {
                                     trigger.oldmap.get(cus.id).addError('can not deleted invoice is attached with this record');                        
                                  }
}
}