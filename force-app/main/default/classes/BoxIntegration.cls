public class BoxIntegration {
    public static Integration_Data__mdt keyOfBox = [SELECT Client_Key__c, Client_Secret_Key__c, Redirect_Uri__c FROM Integration_Data__mdt WHERE label = 'Box Integration'];
    public static String key1 = keyOfBox.Client_Key__c;
    public static String clientSecret = keyOfBox.Client_Secret_Key__c;
    public static String redirectUri = keyOfBox.Redirect_Uri__c;
    
    @AuraEnabled
    public static String checkUserData(){
        String userNameId = userInfo.getUserId();
        List<Box_Integration__c> user = [SELECT User_Id__c, Access_Token__c FROM Box_Integration__c WHERE User_Id__c=:userNameId ];
        if(user.size() > 0){
            return 'Found';
        }
        else{
            return 'Not Found';
        }
    }
    @AuraEnabled
    public static String getUrlCode(){
        System.debug('hii code');
        System.debug('hii apex class');
        String authUrl = 'https://account.box.com/api/oauth2/authorize' +
            '?response_type=code' + 
            '&client_id=' + key1 + 
            '&redirect_uri=' + EncodingUtil.urlEncode (redirectUri, 'UTF-8') + '&token_access_type=offline';
        return authUrl;
    }
    
    @AuraEnabled
    public static string getAccessToken(String authCode){
        
        System.debug('authCode'+authCode);
        System.debug('hii i am access token');
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod ('POST');
        req.setEndpoint('https://api.box.com/oauth2/token?');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+authCode+'&client_id='+key1+'&client_secret='+clientSecret+'&redirect_uri='+redirectUri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.Length()));
        req.setBody(messageBody);
        
        
        Http h = new Http();
        System.debug('http');
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        System.debug('resp=='+resp);
        //System.debug(res.getBody());
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(resp);  
        String token =  String.valueOf(responseMap.get('access_token'));
        String refreshToken = String.valueOf(responseMap.get('refresh_token'));
        
        System.debug('token'+token);
        System.debug('refreshToken'+refreshToken);
        string username = UserInfo.getName();
        string userid = UserInfo.getUserId();
        Datetime dTime = Datetime.now();
        Long tokenDate = dTime.getTime();
        System.debug('hi');
        tokenDate = tokenDate + (Integer) responseMap.get('expires_in') * 1000;
        dTime = Datetime.newInstance(tokenDate);
        System.debug('time'+dTime);
        
        
        
        Box_Integration__c userInformation = new Box_Integration__c(Access_Token__c = token, Refresh_Token__c = refreshToken, Expire_Date__c = dTime, User_Id__c = userid);
        System.debug('-->>>>>>>>>'+userInformation);
        if(userInformation.Refresh_Token__c != null){
            insert userInformation;
        }
        System.debug('token is '+ token);
        return token;
    }
    
    @AuraEnabled
    public static string checkForAccessToken(){
        System.debug('hii checkForAccessToken');
        String userNameFieldOnObj = userInfo.getUserId();
        Box_Integration__c userDetail = [SELECT Expire_Date__c FROM Box_Integration__c WHERE User_Id__c=:userNameFieldOnObj];
        Datetime dTime = Datetime.now();
        if(userDetail.Expire_Date__c < dTime){
            // Get new access token
            return 'EXPIRED';
        }
        else{
            // Get files
            return 'NOT EXPIRED';
        }
    }
    @AuraEnabled
    public static String getNewAccessToken(){
        String userId = userInfo.getUserId();
        Box_Integration__c userDetails = [SELECT Refresh_Token__c FROM Box_Integration__c WHERE User_Id__c =:userId];
        HttpRequest request = new HttpRequest();
        String methodName = 'POST';
        String endPoint = 'https://api.box.com/oauth2/token';
       	String body = 'grant_type=refresh_token' + 
              '&client_id=' + key1 +
              '&client_secret=' + clientSecret +
              '&refresh_token=' + userDetails.Refresh_Token__c;
        Map<String, String> headerMap = new Map<String, String>();
        Integer timeOut = 60000;
        headerMap.put('Content-Type', 'application/x-www-form-urlencoded');
        HttpResponse res = BoxIntegrationService.getRresponse(methodName, endPoint, headerMap, body, timeOut); 
        
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ; 
        System.debug('body'+res.getBody());
        String accesstoken =  String.valueOf(responseMap.get('access_token'));
        String refreshToken = String.valueOf(responseMap.get('refresh_token'));
        System.debug('accesstoken'+accesstoken);
        Datetime dTime = Datetime.now();
        Long tokenDate = dTime.getTime();
        tokenDate = tokenDate + ((Integer) responseMap.get('expires_in') * 1000);
        dTime = Datetime.newInstance(tokenDate);
        
        String userName = userInfo.getUserId();
        List<Box_Integration__c> userDet = [SELECT Access_Token__c, Refresh_Token__c, Expire_Date__c FROM Box_Integration__c WHERE User_Id__c =:userId];
        if(userDet.size() > 0){
            userDet[0].Access_Token__c = accesstoken;
            userDet[0].Expire_Date__c = dTime;
            userDet[0].Refresh_Token__c = refreshToken;
            Update userDet;
        }
        System.debug(res.getBody());
        return 'UPDATED'; 
    }
    
   @AuraEnabled
    public static List<object> getFiles(String rootFolder){
        List<object> files = new List<object>();
       String userId = userInfo.getUserId();
        Box_Integration__c userDetails = [SELECT Access_Token__c, Refresh_Token__c FROM Box_Integration__c WHERE User_Id__c =:userId];
        String methodName = 'GET';
        String endPoint = 'https://api.box.com/2.0/folders/'+rootFolder+'/items';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization', 'Bearer '+userDetails.Access_Token__c);
        HttpResponse res = BoxIntegrationService.getRresponse(methodName, endPoint, headerMap);  
        System.debug(res.getStatusCode());  
        System.debug(res.getBody());
        Map<String, object> responseMap = (Map<String, object>)JSON.deserializeUntyped(res.getBody()); 
        System.debug(res.getStatusCode());
        if(res.getStatusCode() == 200){
            files = (List<object>)responseMap.get('entries');
            System.debug(files.size());
            return files;
        }else{
            System.debug(files.size());
            return files;
        }
    }
    @AuraEnabled
    public static String deleteFile(String fileFolderId){
        System.debug('hii delete ');
        System.debug('file id is '+fileFolderId);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.box.com/2.0/files/' + fileFolderId);
        String userName = userInfo.getUserId();
        Box_Integration__c userDetail = [SELECT Access_Token__c FROM Box_Integration__c WHERE User_Id__c=:userName];
        req.setHeader('Authorization', 'Bearer ' + userDetail.Access_Token__c);
        req.setHeader('accept', 'application/json');
        req.setMethod('DELETE');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug('body'+res.getBody());
        Integer statusCode = res.getStatusCode();
        System.debug(statusCode);
        if(statusCode == 204){
            return 'Success';
        }
        else{
            return 'Error';
        }
    }
    @AuraEnabled
    public static String downloadFiles(String fileId){
        System.debug('id'+fileId);
        String userId = userInfo.getUserId();
        Box_Integration__c userDetails = [SELECT Access_Token__c, Refresh_Token__c FROM Box_Integration__c WHERE User_Id__c =:userId];
        String accessToken = userDetails.Access_Token__c;
        String endpoint = 'https://api.box.com/2.0/files/' + fileId + '/content';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getStatusCode()+'\n'+res.getHeader('location'));
        if (res.getStatusCode() == 302) {
            String downloadUrl = res.getHeader('location');
            System.debug('Download URL: ' + downloadUrl);
            return downloadUrl;
        } else {
            System.debug('Error getting download URL: ' + res.getBody());
            return 'not found';
        }
    }
    
  
    @AuraEnabled
    public static String createFolder1(String folderName, String parentId){
        System.debug('create folder apex call');
        String userId = userInfo.getUserId();
        Box_Integration__c userDetails = [SELECT Access_Token__c, Refresh_Token__c FROM Box_Integration__c WHERE User_Id__c =:userId];
        System.debug(folderName+'   '+parentId);
        String methodName = 'POST';
        String endPoint = 'https://api.box.com/2.0/folders';
        String body = '{ "name": "' + folderName + '", "parent": { "id": "' + parentId + '" } }';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization', 'Bearer '+userDetails.Access_Token__c);
        headerMap.put('Content-Type', 'application/json');
        Integer timeOut =  120000;
        HttpResponse res = BoxIntegrationService.getRresponse(methodName, endPoint, headerMap, body, timeOut);
        System.debug(res.getStatusCode());
        if(res.getStatusCode() == 201){
            return 'success';
        }else if(res.getStatusCode() == 409){
            return 'Folder with this name alredy exisit';
        }else{
            return 'error';
        }
    }
   @AuraEnabled 
    public static String uploadFile(String base64, String filename, String folderId){
        System.debug('hi upload file');
        String userId = userInfo.getUserId();
        Box_Integration__c userDetails = [SELECT Access_Token__c, Refresh_Token__c FROM Box_Integration__c WHERE User_Id__c =:userId];
         String accessToken = userDetails.Access_Token__c;
         if(base64!=null){
             blob base64EncodeFile = base64EncodeFileContent(EncodingUtil.base64Decode(base64), filename);
             String uploadEndPointURL='https://upload.box.com/api/2.0/files/content?parent_id='+folderId;
             String boundary = '----------------------------741e90d31eff';
             String body = '{"name":"' + filename + '", "parent":{"id":"' + folderId + '"}}';
             HttpRequest req = new HttpRequest();
             req.setBody(body);
             req.setBodyAsBlob(base64EncodeFile);
             req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
             //req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
             req.setHeader('Authorization', 'Bearer ' + accessToken);
             req.setMethod('POST');
             req.setEndpoint(uploadEndPointURL);
             req.setTimeout(120000);
             //Send request to Box
             Http ht = new Http();
             HTTPResponse res = ht.send(req);
             
             System.debug('**Files upload Response: ' + res.getBody());

             Integer uploadStatusCode=res.getStatusCode();
             System.debug(uploadStatusCode);
             if(uploadStatusCode==201){
                 return 'SUCCESS';
             }else{
               throw newMessageException('Error encountered. Status Code: ' + uploadStatusCode);                
             }
         }else{
             throw newMessageException('Please select file.');
         }
    }
  
     private static AuraHandledException newMessageException(String message) {
         AuraHandledException e = new AuraHandledException(message);
         e.setMessage(message);
         return e;
     }
  
     public static blob base64EncodeFileContent(Blob file_body, String file_name){
         String boundary = '----------------------------741e90d31eff';
         String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
         String footer = '--'+boundary+'--';             
         String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
         while(headerEncoded.endsWith('='))
         {
             header+=' ';
             headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
         }
         String bodyEncoded = EncodingUtil.base64Encode(file_body);
         Blob bodyBlob = null;
         String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
   
         if(last4Bytes.endsWith('==')) {
             last4Bytes = last4Bytes.substring(0,2) + '0K';
             bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
         } else if(last4Bytes.endsWith('=')) {
             last4Bytes = last4Bytes.substring(0,3) + 'N';
             bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
             footer = '\n' + footer;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
         } else {
             footer = '\r\n' + footer;
             String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
         }
   
         return bodyBlob;
     }
    // @AuraEnabled
    // public static String uploadFileApex(String base64, String filename, String folderId){
    //     String userName = userInfo.getUserId();
    //     Box_Integration__c userDetail = [SELECT Access_Token__c FROM Box_Integration__c WHERE User_Id__c=:userName];
        
    //     String uploadEndPointURL='https://upload.box.com/api/2.0/files/content?parent_id='+folderId;
    //     String boundary = '--741e90d31eff';
    //     String body = '{"name":"' + filename + '", "parent":{"id":"' + folderId + '"}}';
        
    //     HttpRequest req = new HttpRequest();
    //     Blob b = EncodingUtil.base64Decode(base64.substring(22));
    //     req.setBodyAsBlob(b);
    //     req.setHeader('Content-Type', 'multipart/form-data; boundary='+boundary);
    //     req.setHeader('Authorization', 'Bearer '+ userDetail.Access_Token__c);
    //     req.setMethod('POST');
    //     req.setEndpoint(uploadEndPointURL);
    //     req.setTimeout(120000);
        
    //     //Send request to Box
    //     Http ht = new Http();
    //     HTTPResponse res = ht.send(req);
        
    //     System.debug('Files upload Response: '+ res);
        
    //     System.debug(res.getStatusCode());
    //      if(res.getStatusCode() == 201){
    //         return 'success';
    //     }
    //     return 'error';
    // }
    // @AuraEnabled
    // public static  List<object> getFiles1(){
    //     List<object> files = new List<object>();
    //     String rootFolder = '0';
    //     String methodName = 'GET';
    //     String endPoint = 'callout:BoxIntegration/2.0/folders/'+rootFolder+'/items';
    //     HttpRequest req = new HttpRequest();
    //     req.setMethod(methodName);
    //     req.setEndpoint(endPoint);

    //     Http ht = new Http();
    //     HttpResponse res = ht.send(req);
    //     System.debug(res.getStatusCode());
    //     System.debug(res.getBody());
    //     Map<String, object> responseMap = (Map<String, object>)JSON.deserializeUntyped(res.getBody()); 
    //     System.debug(res.getStatusCode());
    //     if(res.getStatusCode() == 200){
    //         files = (List<object>)responseMap.get('entries');
    //         System.debug(files.size());
    //         return files;
    //     }else{
    //         System.debug(files.size());
    //         return files;
    //     }     
    // }
}