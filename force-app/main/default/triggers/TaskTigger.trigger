/*
    * Developed By : Harshal Patil on 20th Oct 2021
    * Desc         : For Auto Updating The Field Copy_Of_Description__c With Only 255 Char From Description Value
*/

trigger TaskTigger on Task (before insert, before update) {
  
      Integer maxSize = 255;
     
      for(Task  tsk : trigger.new)
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