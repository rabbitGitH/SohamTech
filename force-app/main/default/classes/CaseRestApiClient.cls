/*public class CaseRestApiClient {
    @future(callout=true)
    public static void upsertCasesAsync(String caseDataJson) {
        system.debug('caseDataJson'+caseDataJson);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
       // request.setEndpoint(System.URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/cases/');
        
        request.setEndpoint('https://davlatraolimited-dev-ed.my.salesforce.com/services/apexrest/cases');
        request.setHeader('Authorization', 'Bearer 00D0o00000170rX!ARIAQNJ9M3cPEE_B.XtaAf9PUCsm.GZp202oyTtIZlgrG.RcewARlpMz3zbSf0WyAqaDob4.Dra2BqZV0MFXpfr.C3Uby0mQ');
        
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(caseDataJson);
      
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
     
             String responseBody = response.getBody();
             System.debug('responseBody'+responseBody);
        } else {
         
            String errorMessage = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
            System.debug(errorMessage);
        }
        
        
    }
}*/

public class CaseRestApiClient {
    @future(callout=true)
    public static void upsertCasesAsync(String caseDataJson) {
        system.debug('caseDataJson'+caseDataJson);
      //  system.assertEquals(1,2);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
       // request.setEndpoint(System.URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/cases/');
        
        request.setEndpoint('https://davlatraolimited-dev-ed.my.salesforce.com/services/apexrest/cases1');
        request.setHeader('Authorization', 'Bearer 00D0o00000170rX!ARIAQA3L06Dt.YtrHVtwWYgaxPaV5sxawmAzGTE7aUp9I7B3dUkCxy1snb2_ilu2DKbdc7_eMjJi76I.g6U8hEoPgq6QKMGz');
        
        //request.setMethod('PUT');
          request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(caseDataJson);
      
        HttpResponse response = http.send(request);
        system.debug('response'+response);
       
        if (response.getStatusCode() == 200) {
     
             String responseBody = response.getBody();
             System.debug('responseBody'+responseBody);
        } else {
         
            String errorMessage = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
            System.debug(errorMessage);
        }
        
        
    }
}