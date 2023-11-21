public class TataCliqClass {
    Public static void GetData(){
               String endpointToFetchData = 'https://api-partner.tatadigital.com/api/v2/loyalty/frontend/pos/customer/transactionpoints-history-neup?external_id=07afbea919597ccdde4cae1ede0f1ae3';
                    HttpRequest objHttpRequest = new HttpRequest();
                    objHttpRequest.setMethod('GET');
                    objHttpRequest.setEndpoint(endpointToFetchData);
                    system.debug(endpointToFetchData);
                    //objHttpRequest.setEndpoint('callout:LoyaltyPointsInfo'+'?store_id='+loyaltyPointsAPIConfig.TUL_Terminal_Id__c+'&externalId='+lstAccount[0].TUL_Customer_hash__c);
                    objHttpRequest.setHeader('Authorization', 'plsb5463KNyvK65686jhgkjhjk6Jhjhgsfws8rpopoiwbabmnv');
                    objHttpRequest.setHeader('client_id', 'TATACLIQ-POS');
                    objHttpRequest.setHeader('Content-Type', 'application/json');
        			objHttpRequest.setHeader('User-Agent','axios/*');
        			objHttpRequest.setHeader('store_id','cliq.marketplace');
                    Http http = new Http();
                    HTTPResponse loyaltyPointsSummaryResponse = new HTTPResponse();
                    loyaltyPointsSummaryResponse = http.send(objHttpRequest);    
                    system.debug(loyaltyPointsSummaryResponse.getBody());
                    System.debug('<><loyaltyPointsSummaryResponse.getStatusCode()><>'+loyaltyPointsSummaryResponse.getStatusCode());
    }
}