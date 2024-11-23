public class JSON_Example3 {
    
    public string jsonString {set;get;}
    public JSON_Example3(){
        
        system.JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('EmpName');
        gen.writeString('Satish');
        gen.writeFieldName('Age');
        gen.writeNumber(20);
        gen.writeStringField('Branch','Chopda');
        gen.writeNumberField('No',20);
        gen.writeDateField('DOB',System.today());
        string myValue = 'asdafaf';
        Blob body = Blob.valueOf(myValue);
        gen.writeBlobField('Pass',body);
        gen.writeEndObject();
        jsonString = gen.getAsString();
        
        
    }

}