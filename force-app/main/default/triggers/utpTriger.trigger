trigger utpTriger on Account (after update) {

   set<id> setid = new set<id>();
   List<contact>updateList = new List<contact>();
   
   for(account acc : trigger.new){
      setid.add(acc.id);
      }
    
   List<contact> conList = [select id,firstName,lastName,Salutation from contact where accountid =: setid];
   
   for(contact con : conList){
       
       con.description = con.Salutation+'.'+' '+con.lastname+' '+con.firstname;
       
       updateList.add(con);
       }
       update updateList;
}