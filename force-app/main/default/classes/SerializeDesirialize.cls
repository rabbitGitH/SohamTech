public with sharing class SerializeDesirialize {
    
    public static void ListExample(){
        
        List<Integer> numberList = new List<Integer>{1,2,3,4,5};
            string jsonList = JSON.serializePretty(numberList);
        system.debug('\n\nJson version is:\n'+jsonList + '\n');
        List<Integer> deserializeList = (List<Integer>)JSON.deserialize(jsonList,List<Integer>.class);
        system.debug('\n\nValues are equal?\n' +(numberList == deserializeList ) + '\n');
        system.debug('\n\ndeserializeList:\n'+deserializeList + '\n');
    }
    
    public static void MapExample(){
        Map<string,string>  numberMap = new Map<string,string>{'1'=>'one', '2'=>'two', '3'=>'three', '4'=>'four', '5'=>'five'};
            
            string jsonMap = JSON.serializePretty(numberMap);
            system.debug('jsonMap serialize'+jsonMap);
        
            Map<string,string> desirializeMap = (Map<string,string>)JSON.deserialize(jsonMap, Map<string,string>.class);
            system.debug('desirializeMap '+desirializeMap);
        
            }
    
    public static void classExample(){
        
        InnerClass instance1 = new InnerClass();
        
        string innerClassJson = JSON.serializePretty(instance1);
        
        system.debug('innerClassJson'+innerClassJson);
        
        InnerClass instance2 = (InnerClass)JSON.deserialize(innerClassJson, InnerClass.class);
        
          system.debug('instance2'+instance2);
        
    }
    
    public with sharing class InnerClass {
        
        public string stringValue = 'some string value';
        private  string privateValue = 'some hide value';
        
        public boolean equals(object obj){
            InnerClass otherObject = (InnerClass)obj;
            return  otherObject.privateValue == privateValue &&	otherObject.stringValue == stringValue;
                
        }
    }

}