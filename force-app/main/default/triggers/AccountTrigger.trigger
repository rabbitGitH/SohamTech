trigger AccountTrigger on Account(after insert,after update){
    
  //if account phone is chaged then shuld be reflected on all childs
  
     set<id> accIds = new set<id>();
     list<contact> conList = new List<contact>();
    
    if(trigger.isAfter && trigger.isUpdate){
        
        for(account acc:trigger.new){
            
            account oldAcc = trigger.oldmap.get(acc.id);
            
            if(acc.Phone != oldAcc.phone){
                accIds.add(acc.id);
            }
        }
        
        if(accIds != null) {
            for(account acc:[select id,phone,(select id,phone from contacts)from account]){
                
                for(contact con:acc.contacts){
                    con.phone = acc.Phone;
                    conList.add(con);                
                }
            }
            
            if(conList.size()>0){
                try{
                      update conList;
                }
                catch(Exception ex){
                    system.debug('errors'+ex);
                }
            }
        }
    }
}