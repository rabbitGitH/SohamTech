public class wer {
 
    private static final String BASE_URL = 'https://progress.oandp.com/pecos/opie';

    public static String getResponse(string num) {
        String url = BASE_URL + '/' + num;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        string body = response.getBody();
        system.debug('result'+response.getBody());
        
        system.debug('response'+response);
        return response.getBody();
    }
}