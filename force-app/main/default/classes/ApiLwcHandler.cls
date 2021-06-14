public class ApiLwcHandler {
 public static MindfulFoxAPICustomSettings__c customSettings = [SELECT Client_Id__c,Client_Secret__c,Password__c,Service_Token__c,User_Name__c,EndPointURL_for_Token_Gen__c,EP_URL_For_getContacts_API__c from MindfulFoxAPICustomSettings__c Limit 1];
    public class accessTokenWrapper{
        public String id;
        public String access_token;
   }
    public String ReturnAccessToken (ApiLwcHandler acount){
        String reqbody = 'grant_type=password&client_id='+customSettings.Client_Id__c+'&client_secret='+customSettings.Client_Secret__c+'&username='+customSettings.User_Name__c+'&password='+customSettings.Password__c +'&servicetoken='+customSettings.Service_Token__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(customSettings.EndPointURL_for_Token_Gen__c);
        HttpResponse res = h.send(req);
        accessTokenWrapper resp1 = (accessTokenWrapper)JSON.deserialize(res.getbody(),accessTokenWrapper.class);
        system.debug('Access_token => '+resp1.access_token );
        return resp1.access_token;
    }
    @AuraEnabled
    public static list<contact> callgetOppty (){
         List<contactWrapper> conWrapList = new List<contactWrapper>();
        ApiLwcHandler acount1 = new ApiLwcHandler();
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
            req1.setEndpoint(customSettings.EP_URL_For_getContacts_API__c);
            HttpResponse res1 = h2.send(req1);
            String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
            system.debug('RESPONSE => '+trimmedResponse);
            JSONParser parser = JSON.createParser(res1.getBody());
            set<Contact> contList=new set<Contact>();
          
            while (parser.nextToken() != null) {
                contactwrapper conWrap = new contactWrapper();
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) ){
                    Contact cont;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')) {
                        parser.nextToken();
                        string sId= parser.getText();
                        cont=new Contact();
                        cont.External_Id__c=sId;
                        conWrap.contactId = sId;
                        system.debug('External_Id__c =>' + sId);
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Name')) {
                            parser.nextToken();
                            string sName= parser.getText();
                            cont.LastName=sName;
                            conWrap.contactName = sName;
                            system.debug('Name =>' + sName );
                        }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Email')) {
                            parser.nextToken();
                            string sEmail= parser.getText();
                            cont.Email=sEmail;
                            conWrap.email = sEmail;
                            system.debug('Email =>' + sEmail);
                        }
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Department')) {
                            parser.nextToken();
                            string sDepartment= parser.getText();
                            cont.Department=sDepartment;
                             conWrap.department = sDepartment;
                            system.debug('Department =>' + sDepartment);
                        }
                    }
                    contList.add(cont); 
                    conWrapList.add(conWrap);
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