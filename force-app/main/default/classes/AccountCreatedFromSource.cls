public class AccountCreatedFromSource {

    public class deserializeResponse{

        public String id;

        public String access_token;

    }

    @future(callout=true)

    public static void createAccountinTargetOrg(String accName, String accId){ 

        String clientId = '3MVG9pe2TCoA1Pf5MRshhdL9xoDpjgDJbDRCgeeAUKhVMQHqFIlC_2hzVtVM5tKo.gc1NvdJAG5nYlBo902Ex';//your consumer Key

        String clientSecret = '3D8A5D1C48C388C47B8839B071B6D361DFDE0E54553F40FB71E8851374E5DE9D';//your consumer secret

        String username = 'harshal@patilcorpp.com';

        String password = 'Password@321';

        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;

        Http h = new Http();

        HttpRequest req = new HttpRequest();

        req.setBody(reqbody);

        req.setMethod('POST');

       req.setEndpoint('https://davlatraolimited-dev-ed.lightning.force.com/services/oauth2/token');

        HttpResponse res = h.send(req);
        system.debug('res'+res);

        deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);

        if(resp1.access_token != null){
            system.debug('access_token not NULL' );

            String endPoint = 'https://davlatraolimited-dev-ed.lightning.force.com/services/apexrest/createAccount/';
            String jsonstr = '{"AccName" : "' + accName + '"}';

            Http h2 = new Http();

            HttpRequest req1 = new HttpRequest();

           req1.setHeader('Authorization','Bearer ' + resp1.access_token);

            req1.setHeader('Content-Type','application/json');

            req1.setHeader('accept','application/json');

            req1.setBody(jsonstr);

            req1.setMethod('POST');

            req1.setEndpoint(endPoint);

            HttpResponse res1 = h2.send(req1);

        }

    }

}