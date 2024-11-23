trigger today123 on Customer__c (before insert) {
    
   // for(customer__c cus : [select id,(select id from Notes)from customer__c]){
        
        
        
        
  //  }
  
  system.debug(':: Execution');

}