trigger testTrigger on Customer__c (after insert, after update) {
  
      for(Customer__c cus : trigger.new){
          
           if(cus.sync__c){
           
                system.debug('### Success ###');
           }    
          
}
           }