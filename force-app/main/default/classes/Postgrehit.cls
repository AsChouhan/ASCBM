public with sharing class Postgrehit {
        public static String getrecords(){
            String endpointToFetchData = 'http://localhost:3000/todos';
            HttpRequest objHttpRequest = new HttpRequest();
            objHttpRequest.setMethod('GET');
            objHttpRequest.setEndpoint(endpointToFetchData);
            //objHttpRequest.setHeader('Authorization', 'Token '+etranDetails.API_Key__c);
            system.debug('endpoint --->>>'+endpointToFetchData);
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            res = http.send(objHttpRequest);    
            system.debug('body is->>>'+res.getBody());
            system.debug('status code is >>>>'+res.getStatusCode());
            return res.getBody();
    }
}