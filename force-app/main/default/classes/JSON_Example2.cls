public class JSON_Example2 {
    
    public Integer         age    {set;get;}
    public account         acc    {set;get;}
    public StudentInfo     std    {set;get;}
    public StudentInfo     newStd {set;get;}
    public Map<string,object> resMap {set;get;}
    
    //JSON.deserialize() : This will return object
    //we need to type cast object in the form of corresponding object
    public JSON_Example2(){
    string jsString = '{"Name":"Wipro","Industry":"Banking","Phone":"44343"}';
    
    age = (Integer)JSON.deserialize('10',Integer.class);	
    acc = (Account)JSON.deserialize(jsString, account.class);
        string studentString = '{"Name":"Satish","Phone":"43443","Place":"Dhule"}';
        
        std = (StudentInfo)JSON.deserialize(studentString,StudentInfo.class);
        
       //  newStd = (StudentInfo)JSON.deserializeStrict(studentString,StudentInfo.class);
       
         string deserializeStrict = '{"Name":"Satish","Phone":"43443","city":"Dhule"}';
        newStd = (StudentInfo)JSON.deserializeStrict(deserializeStrict,StudentInfo.class);
        
        resMap = (Map<string, object>)JSON.deserializeUntyped(studentString);
        
     }

}