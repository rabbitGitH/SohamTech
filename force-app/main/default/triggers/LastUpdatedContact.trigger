trigger LastUpdatedContact on Contact (before insert,before update) {
 
    map<id,id>idid=new map<id,id>();
    for(contact c:trigger.new){
        if(c.accountid!=null && trigger.isInsert || trigger.isUpdate && 
           c.LastUpdatedContact__c&& !trigger.oldmap.get(c.id).LastUpdatedContact__c){
               idid.put(c.accountid,c.id);}}
    
    for(contact c : [select id,LastUpdatedContact__c from contact where id not in : idid.values()
                     and accountid in:idid.keyset() and LastUpdatedContact__c=true]){
                         c.LastUpdatedContact__c=false;
                         update c;
                     }
    
           
    
}