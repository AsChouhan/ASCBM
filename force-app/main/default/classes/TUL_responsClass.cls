public  class TUL_responsClass {
    @AuraEnabled
    public static String fetchLoyaltyInfo(){
        // String endpointToFetchData = 'https://ppapi.tatadigital.com/api/v2/loyalty/frontend/pos/customer/transactionpoints-history-neup?external_id=90cc24498946c7678a95b3cc3213c58a HTTP/1.1&client_id=CS-WEB-APP&store_id=a004.11';
        String endpointToFetchData = 'https://ppapi.tatadigital.com/api/v2/loyalty/frontend/pos/customer/transactionpoints-history-neup?external_id=90cc24498946c7678a95b3cc3213c58a';
        HttpRequest objHttpRequest = new HttpRequest();
        objHttpRequest.setMethod('GET');
        objHttpRequest.setEndpoint(endpointToFetchData);
        objHttpRequest.setHeader('Authorization', 'Q1RjYVNkSXdHRWJ0YWxBcHBwbmlqbQ==');
        objHttpRequest.setHeader('client_id', 'CS-WEB-APP');
        objHttpRequest.setHeader('store_id', 'a004.11');
       // objHttpRequest.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        System.debug(objHttpRequest.getBody());
        HTTPResponse loyaltyPointsSummaryResponse = new HTTPResponse();
        if(!Test.isRunningTest()){
            loyaltyPointsSummaryResponse = http.send(objHttpRequest);    
        }
        System.debug(loyaltyPointsSummaryResponse.getBody());
        System.debug(loyaltyPointsSummaryResponse.getStatus());
        return loyaltyPointsSummaryResponse.getBody();
    }
   @AuraEnabled 
     public static String getRecordsOfPoint(){
    //TUL_API_Configurations__c loyaltyPointsAPIConfig = TUL_API_Configurations__c.getInstance('LoyaltyPointsInfo');
        String endpointToFetchData = 'https://ppapi-partner.tatadigital.com/api/v1/capillary-api/pos/loyalty-points';
        endpointToFetchData += '?store_id=a004.11'+'&externalId=b7f27279f133e1e3148bb83576a0b16e';
        HttpRequest objHttpRequest = new HttpRequest();
        objHttpRequest.setMethod('GET');
        objHttpRequest.setEndpoint(endpointToFetchData);
        system.debug(endpointToFetchData);
        //objHttpRequest.setEndpoint('callout:LoyaltyPointsInfo'+'?store_id='+loyaltyPointsAPIConfig.TUL_Terminal_Id__c+'&externalId='+lstAccount[0].TUL_Customer_hash__c);
        objHttpRequest.setHeader('Authorization', 'YmphY2JoamJzdmJ2Ympmc2R6Ym12YmRjYmg=');
        objHttpRequest.setHeader('client_id', 'TATACLIQ-POS');
        objHttpRequest.setHeader('Content-Type', 'application/json');
        // if(loyaltyPointsAPIConfig.TUL_Header__c != null){
        //      //objHttpRequest.setHeader(loyaltyPointsAPIConfig.TUL_Header__c.split(':')[0], loyaltyPointsAPIConfig.TUL_Header__c.split(':')[1]);
        //     objHttpRequest.setHeader('User-Agent', 'axios/*');
        // }
        Http http = new Http();
        HTTPResponse loyaltyPointsSummaryResponse = new HTTPResponse();
        loyaltyPointsSummaryResponse = http.send(objHttpRequest);    
        system.debug(loyaltyPointsSummaryResponse.getBody());
        return loyaltyPointsSummaryResponse.getBody();
   }
}