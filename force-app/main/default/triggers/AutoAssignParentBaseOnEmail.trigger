trigger AutoAssignParentBaseOnEmail on invoicesL__c (before insert,before update){
  
    map<string,id>stringid=new map<string,id>();
    set<string>str=new set<string>();
    for(invoicesL__c inv : trigger.new){
    stringid.put(inv.email__c,NULL);}
    
    for(customerL__c cus : [select id,email__c from customerL__c where email__c in : stringid.keyset()]){
    stringid.put(cus.email__c,cus.id);
    str.add(cus.email__c);}
    
    if(stringid.keyset()!=null  ){
    
    for(invoicesL__c inv : trigger.new){
      if(str.contains(inv.email__c)){
    
       if(inv.customerL__c==NULL  &&  inv.email__c!=Null){
        
        inv.customerL__c = stringid.get(inv.email__c);
        
        }}}
        }
        }