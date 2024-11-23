trigger MatchBillingAddress on account (before insert,before update){
    
    for(account a : trigger.new){
        if(a.MatchAddress__c  &&  a.BillingCity!=NULL)
            
            a.ShippingCity=a.BillingCity;
        }
    }