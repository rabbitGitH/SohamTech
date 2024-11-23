public class JSON_Example {
    
    public string integerVal {set;get;}
    public string decimalValue {set;get;}
    public string accountValue {set;get;}
    public string studentValue {set;get;}
    public string integerPretty {set;get;}
    public string decimalPretty {set;get;}
    public string studentPretty {set;get;}
    public string studentNull {set;get;}
    public string studentNotNull {set;get;}
    
    public JSON_Example(){
        integerVal = JSON.serialize(100);
        decimalValue = JSON.serialize(100.50);
        
        Account acc = new account(Name='Harshal',Industry='Banking');
        accountValue = JSON.serialize(acc);
        
        StudentInfo std = new StudentInfo('Harshal','Pune','55995');
        
        studentValue = JSON.serialize(std);
        
       StudentInfo std1 = new StudentInfo('Amol','Pune','');
        
        studentNull    = JSON.serialize(std1);
        studentNotNull = JSON.serialize(std1,true);
        
    }

}