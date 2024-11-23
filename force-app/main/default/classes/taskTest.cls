/*
    * Developed By : Harshal Patil on 20th Oct 2021
    * Desc         : Test Class For task trigger
*/

@isTest 
public class taskTest {

    @isTest static void taskTestMethod(){
         
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      
        User u = new User(Alias             = 'standt', 
                          Email     	    = 'standarduser@testorg.com', 
                          ProfileId         =  p.Id,
                          EmailEncodingKey  = 'UTF-8', 
                          LastName          = 'Testing', 
                          LanguageLocaleKey = 'en_US', 
                          LocaleSidKey      = 'en_US', 
                          TimeZoneSidKey    = 'America/Los_Angeles', 
                          UserName          = 'sta321ndarduser@testorg.com');
       insert u;

        
                            task tsk = new task();
                                 tsk.OwnerId =  u.id;
                                 tsk.status  = 'In Progress';
                                 insert tsk;
                            }}