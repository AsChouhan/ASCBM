@isTest
public with sharing class paymentgatewayMockclass implements HttpCalloutMock {
    public static HttpResponse respond(HttpRequest req){
       /* String body  = req.getBody();
        JSONParser parser = JSON.createParser(body);
        

        while(parser.nextToken() != null){
            if(parser.getCurrentToken() != JSONToken.END_OBJECT){                
                System.debug(parser.getCurrentName()+' ->> '+parser.getText());              
            }
        }*/       
        
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint()=='https://apitest.authorize.net/xml/v1/request.api'){
            res.setBody('"description":"This transaction has been approved."');
        }
        return res;
    }
}