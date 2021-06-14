public class APITrail {
    @AuraEnabled
    public static Decimal conCurrencyToINR(Decimal value, String convTo){
        Decimal rate = 0.0;
        HTTP htp = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint('https://openexchangerates.org/api/latest.json?app_id=YOUR_APP_ID');
        req.setMethod('GET');
        HTTPResponse rep = htp.send(req);
        Map<String,Object> jsonBody = (Map<String,Object>)Json.deserializeUntyped(rep.getBody());
        system.debug('Json Body => '+jsonBody);
        Map<String,Object> rateMap = (Map<String,Object>) jsonBody.get('rates');
        Decimal conversionRate =  (Decimal) rateMap.get('INR');
        rate = value * conversionRate ;
        return rate;   
    }
}