public class NewAndExistingController {

  public account account {get;  private set;}

  public  NewAndExistingController(){
  
  Id id=ApexPages.currentpage().getParameters().get('id');
  account=(id==null)? new Account():[select name,accountnumber,type from account where id=:id];
  }
  public PageReference save()
  {
    try{
        upsert(account);
       }
       catch(System.DMLException e )   
       {
        
        apexPages.addMessages(e);
        return null;    
}
pagereference redirctSuccess= new ApexPages.StandardController(Account).view();
    return redirctSuccess;
        }}