@RestResource(urlMapping='/getContacts/*')
   global with sharing class getContact {
     @HttpGet
      global static list<contact> fetchAccount(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String Department = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        list<contact> listcontact =[Select id , name,Phone,Fax,Email from contact where Department=:Department];
        return listcontact ;
      }
   }