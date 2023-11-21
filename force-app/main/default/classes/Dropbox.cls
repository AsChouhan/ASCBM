public with sharing class Dropbox {
    public static Integration_Data__mdt keyOfBox = [SELECT Client_Key__c, Client_Secret_Key__c, Redirect_Uri__c FROM Integration_Data__mdt WHERE label = 'DropboxInfo'];
    public static String key1 = keyOfBox.Client_Key__c;
    public static String clientSecret = keyOfBox.Client_Secret_Key__c;
    public static String redirectUri = keyOfBox.Redirect_Uri__c;
  
    @AuraEnabled 
    public static string checkUserInDatabase(){
        String userId = userInfo.getUserId();
        List<Dropbox__c> userDetails = [SELECT User_Id__c  FROM Dropbox__c WHERE User_Id__c =:userId];
        if(userDetails.size() > 0){
            return 'Found';
        }else{
            return 'Not Found';
        }
    }
    @AuraEnabled
    public static String getAuthorizationCode(){
        System.debug('hii code');
        String authUrl = 'https://www.dropbox.com/oauth2/authorize'+ 
        '?response_type=code'+
        '&client_id='+key1+ 
        '&redirect_uri='+redirectUri+ 
        '&token_access_type=offline';
        return authUrl;
    }
    @AuraEnabled 
    public static String checkAccessToken(){
        String userId = userInfo.getUserId();
        Dropbox__c userDetails = [SELECT Expire_Date__c FROM Dropbox__c WHERE User_Id__c =:userId];
        Datetime expireTime = Datetime.now();
        if(userDetails.Expire_Date__c < expireTime){
            return 'EXPIRED';
        }else{
            return 'NOT EXPIRED';
        }
    }
    @AuraEnabled
    public static string getAccessToken(String code){
            String methodName = 'POST';
            String endPoint = 'https://api.dropboxapi.com/oauth2/token';
            String body = 'code='+code+'&client_id='+key1+'&client_secret='+clientSecret+'&redirect_uri='+redirectUri+'&grant_type=authorization_code';
            System.debug(body);
            Integer timeOut = 60000;
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put('content-type','application/x-www-form-urlencoded');
            headerMap.put('Content-length',String.valueOf(body.length()));
            HttpResponse res = DropboxService.getRresponse(methodName, endPoint, headerMap, body, timeOut);
           
            System.debug(res.getStatusCode());
            String resp = res.getBody();
            System.debug('body'+res.getBody());
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(resp) ;
            String accessToken =  String.valueOf(responseMap.get('access_token'));
            String refreshToken = String.valueOf(responseMap.get('refresh_token'));
            System.debug('refresh token   ->   '+refreshToken);
            Datetime dTime = Datetime.now();
            Long tokenDate = dTime.getTime();
            tokenDate = tokenDate + (Integer) responseMap.get('expires_in') * 1000;
            dTime = Datetime.newInstance(tokenDate); 

            if(refreshToken == null){
                Dropbox__c userDetail = [SELECT Name__c, Access_Token__c, Refresh_Token__c, User_Id__c, Expire_Date__c FROM Dropbox__c WHERE User_Id__c =: userInfo.getUserId()];
                userDetail.Name__c = userInfo.getName();
                userDetail.Access_Token__c = accessToken;
                userDetail.User_ID__c = UserInfo.getUserId();
                userDetail.Expire_Date__c = dTime;
                update userDetail;
            }else{
                Dropbox__c userDetail = new Dropbox__c(Name__c = UserInfo.getName(), Access_Token__c = accessToken, Refresh_Token__c = refreshToken, Expire_Date__c =  dTime, User_Id__c = UserInfo.getUserId());
                insert userDetail;
            }
            System.debug(res.getStatusCode());
            return accessToken;       
    }
    @AuraEnabled
    public static String getNewAccessToken(){
        String userId = userInfo.getUserId();
        Dropbox__c userDetails = [SELECT Refresh_Token__c FROM Dropbox__c WHERE User_Id__c =:userId];
        //HttpRequest request = new HttpRequest();
        String methodName = 'POST';
        String endPoint = 'https://api.dropboxapi.com/oauth2/token';
        String body = 'refresh_token=' + userDetails.Refresh_Token__c + '&grant_type=refresh_token&client_id=' +key1+ '&client_secret=' + clientSecret;
        Map<String, String> headerMap = new Map<String, String>();
        Integer timeOut = 60000;
        headerMap.put('Content-Type', 'application/x-www-form-urlencoded');
        HttpResponse res = DropboxService.getRresponse(methodName, endPoint, headerMap, body, timeOut); 

        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ; 
        String accesstoken =  String.valueOf(responseMap.get('access_token'));
        Datetime dTime = Datetime.now();
        Long tokenDate = dTime.getTime();
        tokenDate = tokenDate + ((Integer) responseMap.get('expires_in') * 1000);
        dTime = Datetime.newInstance(tokenDate);
        
        String userName = userInfo.getUserId();
        List<Dropbox__c> userDet = [SELECT Access_Token__c, Refresh_Token__c, Expire_Date__c FROM Dropbox__c WHERE User_Id__c =:userId];
        if(userDet.size() > 0){
            userDet[0].Access_Token__c = accesstoken;
            userDet[0].Expire_Date__c = dTime;
            Update userDet;
        }
        System.debug(res.getBody());
        return 'UPDATED'; 
    }
    @AuraEnabled 
    public static List<object> getFiles( String folId) {
        List<object> files = new List<object>();
        List<object> folderList = new List<object>();
        String userId = userInfo.getUserId();
        Dropbox__c userDetails = [SELECT User_Id__c, Access_Token__c FROM Dropbox__c WHERE User_Id__c = :userId];
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        String endpoint = 'https://api.dropboxapi.com/2/files/list_folder';
        request.setEndpoint(endpoint);
        request.setHeader('Authorization', 'Bearer ' + userDetails.Access_Token__c);
        request.setHeader('Content-Type', 'application/json');
        if(folId == null){
        request.setBody('{"include_deleted": false, "include_has_explicit_shared_members": false, "include_media_info": false, "include_mounted_folders": true, "include_non_downloadable_files": true, "path": "", "recursive": false}');
        }else{
            request.setBody('{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,\"include_media_info\":false,\"include_mounted_folders\":true,\"include_non_downloadable_files\":true,\"path\":\"'+folId+'",\"recursive\":false}');
        }
        Http h = new Http();
        HttpResponse res = h.send(request);
        String responseBody = res.getBody();
        responseBody = responseBody.replaceAll('.tag', 'tag');
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.debug(responseMap);
        files = (List<Object>) responseMap.get('entries');
       /* for(SObject x : files){
            if(x. == 'folder'){
                folderList.add(x);
            }
        }
        System.debug(folderList);*/
        System.debug(files);
        return files;
    
    }
    @AuraEnabled
    public static Object downloadFiles(String path){
        String userId = userInfo.getUserId();
        Dropbox__c userDetails = [SELECT User_Id__c, Access_Token__c FROM Dropbox__c WHERE User_Id__c = :userId];
        String methodName = 'POST';
        String endPoint = 'https://api.dropboxapi.com/2/files/get_temporary_link';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization', 'Bearer '+userDetails.Access_Token__c);
        headerMap.put('Content-Type', 'application/json');
        String body = '{"path":"' + path + '"}';
        Integer timeOut = 60000;

        HttpResponse res = DropboxService.getRresponse(methodName, endPoint, headerMap, body, timeOut);  
        System.debug(res.getStatusCode());
        System.debug(res.getBody());

        if(res.getStatusCode() == 200){
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody());
            for(String str : responseMap.keyset()){
                System.debug(str+'  ->   '+responseMap.get(str));
            }            
            return responseMap.get('link');
        }
        return 'none';
    }
@AuraEnabled 
   public static String deleteFile(String FileId){
    System.debug('hii delete ');
    System.debug('file id is '+FileId);
    String userId = userInfo.getUserId();
    Dropbox__c userDetails = [SELECT Access_Token__c FROM Dropbox__c WHERE User_Id__c = :userId];
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://api.dropboxapi.com/2/files/delete_v2');
    req.setHeader('Authorization', 'Bearer ' + userDetails.Access_Token__c);
    req.setHeader('Content-Type', 'application/json');
    req.setMethod('POST');
    String body = '{"path": "' + FileId + '"}';
    req.setBody(body);
    Http h = new Http();
    HttpResponse res = h.send(req);
    Integer statusCode = res.getStatusCode();
    System.debug(statusCode);
    if(statusCode == 200){
        return 'Success';
    }
    else{
        return 'Error';
    }
}
/*@AuraEnabled 
public static String createFolder1(String folderPath, String folderName){
    System.debug('hii createFolder');
 String userId = UserInfo.getUserId();
 Dropbox__c userDetails = [SELECT Access_Token__c FROM Dropbox__c WHERE User_Id__c = :userId];
 String endPoint = 'https://api.dropboxapi.com/2/files/create_folder_v2';
 String methodName = 'POST';
 String body = '{\"autorename\":false,\"path\":\"/'+folderPath+'/'+folderName+'\"}';
 System.debug(body);
 Integer timeOut = 60000;
 Map<String, String> headerMap = new Map<String, String>();
 headerMap.put('Authorization', 'Bearer' + userDetails.Access_Token__c);
 headerMap.put('Content-Type', 'application/json');
 HttpResponse res = DropboxService.getRresponse(methodName, endPoint, headerMap, body, timeOut);
 System.debug('body'+res.getBody());
 System.debug('code'+res.getStatusCode());
 return 'SUCCESS';
 }*/
 @AuraEnabled
    public static String createFolder1(String folderPath, String folderName){
        String userId = UserInfo.getUserId();
        System.debug('folderpath'+folderPath);
        System.debug('folderName'+folderName);
        Dropbox__c userDetails = [SELECT Access_Token__c FROM Dropbox__c WHERE User_Id__c = :userId];
        System.debug('folderPath >>>'+folderPath);
        String endPoint = 'https://api.dropboxapi.com/2/files/create_folder_v2';
        String body = '{"path":"'+ folderPath + '/' + folderName + '", "autorename":true}';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer '+userDetails.Access_Token__c);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(body);
        res = http.send(req);
        System.debug(res.getStatusCode());
        if(res.getStatusCode() == 200){
            System.debug('send pass');
            return 'Success';
        }else{
            System.debug('fali');
            return 'fail';
        }
    }

    @AuraEnabled
    public static String uploadFile1(String filename, String path, String file){
        String userId = UserInfo.getUserId();
        Dropbox__c userDetails = [SELECT Access_Token__c FROM Dropbox__c WHERE User_Id__c = :userId];
  
        String dbxApiArg = '{"path":"'+ path + '/' + filename + '", "mode": "add", "autorename": true, "mute": false, "strict_conflict": false }';
        System.debug('at top');
        blob  b = EncodingUtil.base64Decode(file);
           Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://content.dropboxapi.com/2/files/upload');
            req.setMethod('POST');
            req.setHeader('Authorization','Bearer '+userDetails.Access_Token__c);
            req.setHeader('Content-Type', 'application/octet-stream');
            req.setHeader('Dropbox-API-Arg', dbxApiArg);
            req.setBodyAsBlob(b);
            req.setTimeout(120000);
            HttpResponse res = http.send(req);
            System.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
                return 'Success';
            }
            return 'error';
    }
}