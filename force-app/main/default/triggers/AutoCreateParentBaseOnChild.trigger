trigger AutoCreateParentBaseOnChild on invoicesL__c (before insert){
   
   list<customerL__c>cuslist = new list<customerL__c>();
   list<invoicesL__C> invlist = new list<invoicesL__c>();
   map<string,invoicesL__c>stringid=new map<string,invoicesL__c>();
   
    for(invoicesL__c inv : trigger.new){
        if(inv.customerL__c==null ){
           invlist.add(inv);}}
           
           for(invoicesL__c inv : invlist){
               string invName = inv.name;
               stringid.put(invName,inv);
               
               customerL__c cus = new customerL__c();
               cus.firstName__c = invName;
               cuslist.add(cus);}
               
               insert cuslist;
               
               for(customerL__c cus : cuslist){
                   if(stringid.containskey(cus.firstname__c)){
                      invoicesL__c inv = stringid.get(cus.firstname__c);
                      
                      inv.customerL__c = cus.id;}}
                      
                      }