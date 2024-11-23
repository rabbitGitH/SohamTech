public class NPIRegistryAPIIntegration {
    
    
    private static String API_ENDPOINT = 'https://npiregistry.cms.hhs.gov/api/?version=2.1&&number=';
    
    // Method to make HTTP GET request to API endpoint
    @AuraEnabled(cacheable=true)
    public static String getAPIDetails(String num) {
        String input = num;
        API_ENDPOINT = API_ENDPOINT + input;
       system.debug('API_ENDPOINT'+API_ENDPOINT); 
        // Create HTTP request object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(API_ENDPOINT);
        request.setMethod('GET');
        
        // Create HTTP client object
        Http http = new Http();
        
        try {
            // Make HTTP request and get response
            HttpResponse response = http.send(request);
            
            // Process response and return as string
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                system.debug('responseBody'+response.getBody()); 
                
                Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                List<Object>        results        = (List<Object>) parsedResponse.get('results');
                
  if (results.size() > 0) 
  {
    Map<String, Object> result     = (Map<String, Object>) results[0];
    Map<String, Object> basic      = (Map<String, Object>) result.get('basic');
  
    List<Object> addresses = (List<Object>) result.get('addresses');
    List<Object> taxonomies = (List<Object>) result.get('taxonomies');
    
      
          
    if (basic != null) {

        system.debug('first_name' + (String) basic.get('first_name'));
        system.debug('last_name'  + (String) basic.get('last_name'));
        system.debug('gender'     + (String) basic.get('gender'));    
        system.debug('credential' + (String) basic.get('credential'));
    }
        
      if (addresses.size() > 0 && taxonomies[0] != null) {
        
        system.debug('addresses.country_code'    + (String) ((Map<String, Object>) addresses[0]).get('country_code'));
        system.debug('addresses.country_name'    + (String) ((Map<String, Object>) addresses[0]).get('country_name'));
        system.debug('addresses.address_purpose' + (String) ((Map<String, Object>) addresses[0]).get('address_purpose'));
        system.debug('addresses.address_type'    + (String) ((Map<String, Object>) addresses[0]).get('address_type'));
        system.debug('addresses.address_1'       + (String) ((Map<String, Object>) addresses[0]).get('address_1'));
        system.debug('addresses.city'            + (String) ((Map<String, Object>) addresses[0]).get('city'));
        system.debug('addresses.state'           + (String) ((Map<String, Object>) addresses[0]).get('state'));
      }
          if (addresses.size() > 1 && addresses[1] != null) {
             
        system.debug('addresses.country_code 1'    + (String) ((Map<String, Object>) addresses[1]).get('country_code'));
        system.debug('addresses.country_name 1'    + (String) ((Map<String, Object>) addresses[1]).get('country_name'));
        system.debug('addresses.address_purpose 1' + (String) ((Map<String, Object>) addresses[1]).get('address_purpose'));
        system.debug('addresses.address_type 1'    + (String) ((Map<String, Object>) addresses[1]).get('address_type'));
        system.debug('addresses.address_1 1'       + (String) ((Map<String, Object>) addresses[1]).get('address_1'));
        system.debug('addresses.city 1'            + (String) ((Map<String, Object>) addresses[1]).get('city'));
        system.debug('addresses.state 1'           + (String) ((Map<String, Object>) addresses[1]).get('state'));
    }
          
        if (taxonomies.size() > 0 && taxonomies[0] != null) {
            
        system.debug('taxonomies.desc'           + (String) ((Map<String, Object>) taxonomies[0]).get('desc'));
        } 
 
}
                
                return responseBody;
            }
            else {
                throw new AuraHandledException('API Request failed with status code: ' + response.getStatusCode());
            }
        }
        catch (Exception e) {
            throw new AuraHandledException('API Request failed with error: ' + e.getMessage());
        }
    }
}