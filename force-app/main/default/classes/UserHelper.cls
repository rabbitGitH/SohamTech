public class UserHelper {
    
    public static void helperMethod(List<User> Users){

    set<id> userIds = new set<id>();
    
    for(User usr : Users) {
     
        userIds.add(usr.id);
	 }
        
        futureMethod(userIds);
    }
    @future
    public static void futureMethod(set<id>userIds){
        
         List<opportunity> opptys = new List<opportunity>();
        
            if(userIds != null){	
               opptys = [select id,stagename,ownerId,owner.managerId from opportunity where ownerId in : userIds AND stagename != 'Closed Won' AND stagename != 'Closed Lost'];
                system.debug('futureMethod'+opptys);
            }
        
             if(opptys != null){	
                for(opportunity opp : opptys){
                opp.ownerId = opp.owner.managerId;
                }
             }
        update opptys;
    }
}