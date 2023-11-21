public with sharing class WeatherApi {
    @AuraEnabled
    Public static String getWeatherinfo(String city){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:WeatherApi/current.json?q='+city);
        req.setMethod('GET');

        HttpResponse res = http.send(req);
        return res.getBody();
   } 
}