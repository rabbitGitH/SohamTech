public class AccountCustom {
  
  
    public PageReference SavetheRecord(){
    update account;
    return null;
    }  
    private final Account account;
    //constructor   
    public AccountCustom(){
    account=[select id,name,site from account where Id=:ApexPages.Currentpage().getParameters().get('id')];     
    }
    //get method
    public account getaccount(){
    return account;
    }
    }