trigger CountCases on case (after insert,after delete,after undelete){
 
    set<id>setid=new set<id>();
    if(trigger.isInsert  ||  trigger.isUndelete){
        for(case c : trigger.new){
            if(c.accountid!=null){
                setid.add(c.AccountId);}}}
    
    if(trigger.isDelete){
        for(case c : trigger.old){
            if(c.AccountId!=null){
                setid.add(c.AccountId);}}}

    List<Account>acclist=[select id,annualrevenue,(select id from cases)from account where id =: setid];
    
    for(account ac:acclist){
        ac.annualrevenue=ac.cases.size();
    }
    update acclist;
}