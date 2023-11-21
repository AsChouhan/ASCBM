public class sTosMockClass implements HttpCalloutMock {
    public static HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint()=='callout:salesforce_name_credential1/services/apexrest/content'){
            res.setStatusCode(200);
            res.setBody('{"attributes":{"type":"ContentVersion","url":"/services/data/v57.0/sobjects/ContentVersion/0685i00000BNE6tAAH"}, "Id":"0685i00000BNE6tAAH","Title":"paymentG","ContentDocumentId":"0695i000009oKDwAAM","FileType":"JPG","ContentSize":52927,"VersionNumber":"1","OwnerId":"0055i000006EgCHAA0","CreatedDate":"2023"}');
        }
        return res;
    }
}