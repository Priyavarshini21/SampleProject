public class MyFirstRestApiCallout {
    public static MindfulFoxAPICustomSettings__c customSettings = [SELECT Client_Id__c,Client_Secret__c,Password__c,Service_Token__c,User_Name__c,EndPointURL_for_Token_Gen__c,EP_URL_For_getContacts_API__c from MindfulFoxAPICustomSettings__c Limit 1];
    public class deserializeResponse{
        public String id;
        public String access_token;
   }
    public String ReturnAccessToken (MyFirstRestApiCallout acount){
        String reqbody = 'grant_type=password&client_id='+customSettings.Client_Id__c+'&client_secret='+customSettings.Client_Secret__c+'&username='+customSettings.User_Name__c+'&password='+customSettings.Password__c +'&servicetoken='+customSettings.Service_Token__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(customSettings.EndPointURL_for_Token_Gen__c);
        HttpResponse res = h.send(req);
        deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
        system.debug('Access_token => '+resp1.access_token );
        return resp1.access_token;
    }
    @AuraEnabled
    public static list<Contact> callgetContact ( String department ){
        MyFirstRestApiCallout acount1 = new MyFirstRestApiCallout();
        String accessToken;
        accessToken =acount1.ReturnAccessToken (acount1);
        System.debug('Acc token => '+accessToken);
        list<Contact> LstContact=new List<Contact>();
        if(accessToken != null){ 
            Http h2 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('GET');
            
            req1.setEndpoint(customSettings.EP_URL_For_getContacts_API__c +department);
            HttpResponse res1 = h2.send(req1);
            String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
            system.debug('RESPONSE => '+trimmedResponse);
            JSONParser parser = JSON.createParser(res1.getBody());
            set<Contact> contList=new set<Contact>();
            while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) ){
                    Contact cont;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')) {
                        parser.nextToken();
                        string sId= parser.getText();
                        cont=new Contact();
                        cont.External_Id__c=sId;
                        system.debug('External_Id__c =>' + sId);
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Name')) {
                            parser.nextToken();
                            string sName= parser.getText();
                            cont.LastName=sName;
                            system.debug('Name =>' + sName );
                        }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Email')) {
                            parser.nextToken();
                            string sEmail= parser.getText();
                            cont.Email=sEmail;
                            system.debug('Email =>' + sEmail);
                        }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Department')) {
                            parser.nextToken();
                            string sDepartment= parser.getText();
                            cont.Department=sDepartment;
                            system.debug('Department =>' + sDepartment);
                        }
                    }
                    contList.add(cont); 
                } 
                contList.remove(null);
                
            }
            LstContact.AddAll(contList);
        }
        return LstContact;
    }

    public class contactWrapper{
        public Id contactId;
        public String contactName;
        public String email;
        public String department;
        
    }
}


 /*   @AuraEnabled
    public static void showContact(){
        
        HTTP htp = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint('https://mindful-fox-hxfqee-dev-ed.my.salesforce.com/services/apexrest/getContacts/Finance');
        req.setMethod('GET');
        HTTPResponse rep = htp.send(req);
        String jsonBody =  rep.getBody();
        system.debug('Json Body => '+jsonBody);       
    }*/
  // private final String clientId = '3MVG9fe4g9fhX0E7__Z7wPOyivBiCmytOKNuMLjgOtm8EVZ2c7fgy4cx8r4vZMaZ72LzO6vn0n4NARcExRiGb';
   //private final String clientSecret = 'CF99FEB9E71E670D401112DDD48B51B9D2818712B409B11950DEAD63FE3F094C';
  // private final String username = 'priyavarshini.d@mindful-fox-hxfqee.com';
  // private final String password = '1001percentagesec';
   //private final String serviceToken = 'viFbNvFyWp5nFlPruCIdU9e1';
   //   //req.setEndpoint('https://mindful-fox-hxfqee-dev-ed.my.salesforce.com/services/oauth2/token');
   //   // String endPoint = 'https://mindful-fox-hxfqee-dev-ed.my.salesforce.com/services/apexrest/getContacts/Finance';
   //   //req1.setEndpoint(endPoint);