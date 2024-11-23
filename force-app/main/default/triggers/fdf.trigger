trigger fdf on Account (after insert, after update) {
   List<Contact> Cons = [select id, salutation, description,
   firstname, lastname, email from Contact where AccountId IN :Trigger.newMap.keySet()];
 
   for(Contact c: Cons){
 
      c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
 
   }
    
   update Cons;
}