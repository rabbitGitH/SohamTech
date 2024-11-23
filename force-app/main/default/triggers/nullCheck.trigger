trigger nullCheck on Customer__c (before update) {

   
    for(Customer__c  cus : trigger.new){
        cus.a_value__c = cus.b_value__c;
        if(cus.c_value__c > cus.d_value__c){ 
        cus.d_value__c = 111;
        }
        }

  

}