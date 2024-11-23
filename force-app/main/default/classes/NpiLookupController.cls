/*public with sharing class NpiLookupController {
    @AuraEnabled(cacheable=true)
    
    public static Npi__c createNpiRecord(String npiNumber) {
    system.debug('npiNumber'+npiNumber); 
    List<Npi__c> npiList = new  List<Npi__c>();
    Npi__c npi = new Npi__c ();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://npiregistry.cms.hhs.gov/api/?version=2.1&&number=' + npiNumber);
      request.setMethod('GET');
  
      Http http = new Http();
      HttpResponse response = http.send(request);
  
      if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                system.debug('responseBody'+response.getBody()); 
                
                Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object>        results        = (List<Object>) parsedResponse.get('results');
                
  if (results.size() > 0) 
  {
    Map<String, Object> result     = (Map<String, Object>) results[0];
    Map<String, Object> basic      = (Map<String, Object>) result.get('basic');
  
    //List<Object> addresses = (List<Object>) result.get('addresses');
    //List<Object> taxonomies = (List<Object>) result.get('taxonomies');
   
        system.debug('basic   '+basic     );
       
        npi.First_Name__c = (String) basic.get('first_name');
        npi.NPI_No__c     = npiNumber;
        npi.Last_Name__c = (String) basic.get('last_name');
       npiList.add(npi);
       system.debug('npiList.size'+npiList.size());
       
        Database.insert(npiList, false);
        
      }  
      }return npi; 
    }
  }*/

  public with sharing class NpiLookupController {
    
    @AuraEnabled(cacheable=true)
    public static List<Npi__c> createNpiRecords(List<String> npiNumbers) {
        try{
            List<Npi__c> npiList = new List<Npi__c>();
            
            for(String npiNumber : npiNumbers) {
                System.debug('npiNumber'+npiNumber); 
                Npi__c npi = new Npi__c();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('https://npiregistry.cms.hhs.gov/api/?version=2.1&&number=' + npiNumber);
                request.setMethod('GET');
  
                Http http = new Http();
                HttpResponse response = http.send(request);
  
                if (response.getStatusCode() == 200) {
                    String responseBody = response.getBody();
                    System.debug('responseBody'+response.getBody()); 
                    
                    Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                    List<Object> results = (List<Object>) parsedResponse.get('results');
                    
                    if (results.size() > 0) {
                        Map<String, Object> result = (Map<String, Object>) results[0];
                        Map<String, Object> basic = (Map<String, Object>) result.get('basic');
      
                        System.debug('basic'+basic);
                       
                        npi.First_Name__c = (String) basic.get('first_name');
                        npi.NPI_No__c = npiNumber;
                        npi.Last_Name__c = (String) basic.get('last_name');
                        npiList.add(npi);
                        System.debug('npiList.size'+npiList.size());
                    }  
                }
            }
            if(!npiList.isEmpty()){
                Database.insert(npiList, false);
            }
            return npiList;
        }
        catch(Exception e){
            System.debug('Exception: '+e.getMessage());
            return null;
        }
    }
}