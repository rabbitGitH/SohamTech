public class JSON_Example4 {
    
    public string name          {set;get;}
    public string phone         {set;get;}
    public decimal annualRevenue {set;get;}
    public string result {set;get;}
    
    
    public void create(){
        
       System.JSONGenerator js = JSON.createGenerator(true);
        js.writeStartObject();
        
        Account acc = new Account();
        try
        {
            acc.Name  = name;
            acc.phone = phone;
            acc.AnnualRevenue = annualRevenue;
            insert acc;
            
            js.writeStringField('Status','Success');
            js.writeIdField('Id',acc.Id);
            
            system.debug('JS'+js.getAsString());
        }catch(Exception e){
            
            js.writeStringField('Status','Failed');
            js.writeStringField('Error',e.getMessage());
            js.writeEndObject();
            result = js.getAsString();
            system.debug('result'+result);
        }
    }
      

}