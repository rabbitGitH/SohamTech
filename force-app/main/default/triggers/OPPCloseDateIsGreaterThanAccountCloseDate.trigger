Trigger OPPCloseDateIsGreaterThanAccountCloseDate on Opportunity ( After Insert, After Update){
    
    Set<id> SetAcc = new Set<id>();
    List<account>acl=new list<account>();
    map<id,Account> UpdatedAcc = new map<id,Account>();
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
    for(Opportunity Opp : Trigger.new){
        if(Opp.AccountId!=NULL){
            SetAcc.add(Opp.AccountId);
        }
    }
    Map<id,Account> maptoupdate = new map<id,Account>([Select id,CloseDate__c from Account where id in : SetAcc]);
        for(Opportunity Opp : Trigger.new)
        {
           if(maptoupdate.containskey(opp.AccountId) && 
              maptoupdate.get(opp.AccountId).CloseDate__c<opp.closedate ||
              maptoupdate.get(opp.AccountId).CloseDate__c==NULL){
                  
                  Account Acc = new Account();
                  Acc.Id=Opp.AccountId;
                  Acc.CloseDate__c=Opp.CloseDate;
                  acl.add(acc);
                 // updatedAcc.put(Acc.Id,Acc);
                  
              }
        }
        update acl;
   // update updatedAcc.values();
    }
   } }