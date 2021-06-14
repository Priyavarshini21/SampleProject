public class GetAccountUsingRESTAPI {
    private final String clientId = '3MVG9fe4g9fhX0E7__Z7wPOyivGhKHM06y3AykhM7J_pdgXrzrG_gRQeLolyfFMjNwlvLbOMa5HDpDQIfwpbU';
    private final String clientSecret = 'AD029826EB023FB8317A16AE96A0B12AD8CBB7A05D735260421FF03D4BC4D78F';
    private final String username = 'Priyavarshini.d@mindful-fox-hxfqee.com';
    private final String password = '1001%sec';
    public class deserializeResponse{
        public String id;
        public String access_token;
    }
    public String ReturnAccessToken (GetAccountUsingRESTAPI acount){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
		req.setBody('grant_type=password&client_id=' + ClientId + '&client_secret=' + ClientSecret + '&username=' + username +'&password=' + password);  
        req.setMethod('POST');
        req.setEndpoint('https://mindful-fox-hxfqee-dev-ed.my.salesforce.com/services/oauth2/token');
        HttpResponse res = h.send(req);
        system.debug('Response: ' + res.getBody());
        deserializeResponse response = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
        system.debug('@@@@access_token@@'+response );
        return response.access_token;
    }
    public static list<account> callGetAccount(){
        GetAccountUsingRESTAPI acount1 = new GetAccountUsingRESTAPI();
        String accessToken;
        accessToken = acount1.ReturnAccessToken (acount1);
        list<account> ListAccount=new List<account>();
        if(accessToken != null) {
            String endPoint = 'https://mindful-fox-hxfqee-dev-ed.my.salesforce.com/services/apexrest/v1/getAccounts/';
            Http h2 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' +accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('GET');
            req1.setEndpoint(endPoint);
            HttpResponse res1 = h2.send(req1);            
            String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
            system.debug('@@@RESPONSE@@'+trimmedResponse);
            JSONParser parser = JSON.createParser(res1.getBody());
            set<account> accList=new set<account>();
            while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) ) {
                    Account acc;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')) {
                        parser.nextToken();
                        String sId= parser.getText();
                        acc=new Account();
                        acc.Id=sId;
                        system.debug('Id@@@' + sId);
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Name')) {
                            parser.nextToken();
                            string sName= parser.getText();
                            acc.Name=sName;
                            system.debug('Name@@@' + sName );
                        }
                    }
                    accList.add(acc); 
                }
                accList.remove(null);
            }
            ListAccount.AddAll(accList);
            system.debug('AccountList@@@@'+Json.serialize(ListAccount));
        }
        return ListAccount;
    }
}