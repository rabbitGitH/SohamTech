trigger contactAddressUdate on account (after update){
     
     list<account>acclist=new list<account>();
     map<id,Account>maps=new map<id,Account>();
     for(account ac:trigger.new){
         if(ac.BillingCountry!=trigger.oldmap.get(ac.id).BillingCountry  &&
            ac.BillingPostalCode!=trigger.oldmap.get(ac.id).BillingPostalCode &&
            ac.BillingState!=trigger.oldmap.get(ac.id).BillingState &&
            ac.BillingCity!=trigger.oldmap.get(ac.id).BillingCity)   {
            
            maps.put(ac.id,ac);}}
            
           for(contact ac : [select id,accountid,MailingCountry,MailingPostalCode,MailingState,MailingCity
                             from contact where accountid in : maps.keyset()]){
              
               ac.MailingCountry=maps.get(ac.accountid).BillingCountry;
               ac.MailingPostalCode=maps.get(ac.accountid).BillingPostalCode;
               ac.MailingState=maps.get(ac.accountid).BillingState;
               ac.MailingCity=maps.get(ac.accountid).BillingCity;
               
                           

               update ac;
               }}