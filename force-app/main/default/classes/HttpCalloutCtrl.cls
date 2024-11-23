public class HttpCalloutCtrl 
{   @AuraEnabled
    public static Map<String,Object> getCalloutResponseContents(String url)
    {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        system.debug(':: Response'+res.getBody());
        Map<String,Object> resultsMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        system.debug(':: ResultsMap'+resultsMap);
        return resultsMap;
    }

}