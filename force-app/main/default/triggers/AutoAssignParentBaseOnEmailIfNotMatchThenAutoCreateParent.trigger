trigger AutoAssignParentBaseOnEmailIfNotMatchThenAutoCreateParent on invoicesl__c (before insert){
     
     set<string>cusemail=new set<string>();
     set<string>invemail=new set<string>();
     list<customerl__c>cuslist=new list<customerl__c>();
     map<string,invoicesl__c>maps=new map<string,invoicesl__c>();
     for(invoicesl__c inv:trigger.new){
         if(inv.customerl__c==null){
            maps.put(inv.email__c,null);
            invemail.add(inv.email__c);}}
            
  for(customerl__c cus:[select id,email__c from customerl__c where email__c in : maps.keyset()]){
  cusemail.add(cus.email__c);
      
     
     for(invoicesl__c inv:trigger.new){
     if(inv.email__c==cus.email__c){
     inv.customerl__c=cus.id;}}}
     
     if(invemail!=cusemail){
     
     for(invoicesl__c inv:trigger.new){
         string namee=inv.name; 
         maps.put(inv.name,inv);
         
         customerl__c cus = new customerl__c();
         cus.firstname__c=namee;
         cuslist.add(cus);}
         insert cuslist;
         
         for(customerl__c cus:cuslist){
         if(maps.containskey(cus.firstname__c)){
         invoicesl__c inv=maps.get(cus.firstname__c);
         inv.customerl__c=cus.id;
         }}}}