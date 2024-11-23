public class TestClass {


   public static void copyMethod(id UTIDid){
   
   List<task> tskk = [select id,description,copy_of_description__c from task where id=:UTIDid ];
   
   Integer maxSize = 255;
     
      for(Task  tsk : tskk )
      {       
         string LongString = tsk.Description;
         string RealString = tsk.Description;
         
            if(String.isEmpty(RealString))
            {
                tsk.Copy_Of_Description__c = '' ;
            }
            
            if(String.isNotEmpty(LongString))
            {
                 if(LongString.length()>255)
                 {
                   LongString = LongString.substring(0, maxSize);
                  
                   tsk.Copy_Of_Description__c = LongString ;   
                 }
             }
                      if(String.isNotEmpty(RealString) && RealString.length()<255 )
                        {           
                           tsk.Copy_Of_Description__c =  RealString;
                        }
      }
           
}
}