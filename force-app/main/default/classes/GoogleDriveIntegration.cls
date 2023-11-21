public class GoogleDriveIntegration {
    public static Integration_Data__mdt keyOfGoogle = [SELECT Client_Key__c, Client_Secret_Key__c, Redirect_Uri__c FROM Integration_Data__mdt WHERE label = 'Google Drive Info'];
    
    static String key1 = keyOfGoogle.Client_Key__c;
    static String secert = keyOfGoogle.Client_Secret_Key__c;
    static string redirect_uri = keyOfGoogle.Redirect_Uri__c;
    
    // Method for checking user is present in database or not.
    @AuraEnabled
    public static String checkUserInDatabase(){ 
        String userId = userInfo.getUserId();
       
        List<Integration__c> userDetail = [SELECT User_Id__c, Access_Token__c FROM Integration__c WHERE User_Id__c=:userId ];
        if(userDetail.size() > 0){
            return 'Found';
        }else{
            return 'Not Found';
        }
    }
    
    // Method for creating auth URL for authentication.
    @AuraEnabled
    public static String createAuthURL(){       
        String key = EncodingUtil.urlEncode(key1,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope=https://www.googleapis.com/auth/drive'+
            '&redirect_uri='+uri+
            '&access_type=offline';
        
        return authuri;
    }    
    
    // Method for getting accessToken using auth code.
    // Parameter = code :- authCode.

    @AuraEnabled
    public static String getAccessToken(String code){
        String methodName = 'POST';
        String endPoint = 'https://accounts.google.com/o/oauth2/token';
        String body = 'code='+code+'&client_id='+key1+'&client_secret='+secert+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        Integer timeOut = 60000;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('content-type','application/x-www-form-urlencoded');
        headerMap.put('Content-length',String.valueOf(body.length()));

        String resp;
        HttpResponse res = GoogleDriveIntegrationService.getRresponse(methodName, endPoint, headerMap, body, timeOut);
        resp = res.getBody();
        
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(resp) ;  
        String token =  String.valueOf(responseMap.get('access_token'));
        String refreshToken = String.valueOf(responseMap.get('refresh_token'));
        
        Datetime dTime = Datetime.now();   //get current time...
        Long tokenDate = dTime.getTime();   // get time in milisecond...
        tokenDate = tokenDate + (Integer) responseMap.get('expires_in') * 1000;
        
        dTime = Datetime.newInstance(tokenDate); 
      
        
        if(refreshToken == null){
            Integration__c accessInfo = [select Name__c, Access_Token__c, Refresh_Token__c, User_Id__c, Expire_Date__c from Integration__c where User_Id__c =: userInfo.getUserId()];
        	accessInfo.Name__c = userInfo.getName();
            accessInfo.Access_Token__c = token;
            accessInfo.Refresh_Token__c = refreshToken;
            accessInfo.User_Id__c = UserInfo.getUserId();
            accessInfo.Expire_Date__c = dTime;
            update accessInfo;
        }else{
            Integration__c accessInfo = new Integration__c(Name__c = UserInfo.getName(), Access_Token__c= token, Refresh_Token__c= refreshToken, User_Id__c = UserInfo.getUserId(), Expire_Date__c = dTime);
            insert accessInfo;
        }
        
        return token;
    }
    
    
    //Method for retrive files from drive.
    //Parameter = folderId :- 
    @AuraEnabled
    public static List<object> getfile1(String folderId){
        System.debug('hii i am get files');
        List<object> files = new List<object>();
        String userId = userInfo.getUserId();      
        
        Integration__c userDetail = [SELECT Access_Token__c FROM Integration__c WHERE User_Id__c =:userId];
        String accessToken = userDetail.Access_Token__c;
        
        String methodName = 'GET';
        String endPoint = 'https://www.googleapis.com/drive/v3/files?q='+'"'+folderId+'"'+'+in+parents&trashed=false&fields=*';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization','Bearer ' + accessToken);
        HttpResponse res = GoogleDriveIntegrationService.getRresponse(methodName, endPoint, headerMap);     
        
       
        if(res.getStatusCode()==200){
            string response = res.getBody();
            Map<String, Object> results = (Map<String, Object>)
                JSON.deserializeUntyped(res.getBody());
            files = (List<Object>) results.get('files');
        }
      
        return files;
    }
    
    
    //Method for delete file from drive.
    //Parameter = fileId :- id of document/file for delete.
    @AuraEnabled
    public static void deleteData(String fileId){
        String userId = userInfo.getUserId();
        
        Integration__c userDetail = [SELECT Access_Token__c FROM Integration__c WHERE User_Id__c =:userId];
        String methodName = 'DELETE';
        String endPoint = 'https://www.googleapis.com/drive/v3/files/'+ fileId;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization','Bearer ' + userDetail.Access_Token__c);
        headerMap.put('accept','application/json');
        HttpResponse res = GoogleDriveIntegrationService.getRresponse(methodName, endPoint, headerMap);
        System.debug('status code =>   '+ res.getStatusCode());
        if(res.getStatusCode() == 204){
            System.debug('success');
        }else{
            System.debug('failed');
        }        
    }    
    
    // Method for Create folder on drive.
    // Parameter = folderName :- name of creating folder, folderId :- parent folder Id.
    
     @AuraEnabled
    public static string createFolderinDrive(String folderName, String folderId){

        String userId = userInfo.getUserId();
		Integration__c userDetail = [SELECT Access_Token__c FROM Integration__c WHERE User_Id__c =:userId];

        String methodName = 'POST';
        String endPoint = 'https://www.googleapis.com/drive/v2/files';
        String body = '{"title":"'+folderName+'","mimeType" : "application/vnd.google-apps.folder","parents": [{"kind": "drive#fileLink","id": "'+folderId+'"}]}';
        Integer timeOut = 60000;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization','Bearer ' + userDetail.Access_Token__c);
        headerMap.put('content-type','application/json');
        headerMap.put('Accept', 'application/json');      
        HttpResponse res = GoogleDriveIntegrationService.getRresponse(methodName, endPoint, headerMap, body, timeOut);       
        System.debug(res.getStatusCode());
        if(res.getStatusCode() == 200){
            return 'Success';
        }
        return 'Cannot create Folder';
    } 
    
    // Method for Upload file.
    // Parameter = filename :- uploding file name, filetype :- uploading fileType, file :- encoded file for upload, folderId :- parent folder Id.
    
    @AuraEnabled
    public static String uploadFile(String filename, String filetype, object file, String folderId){
        String userId = userInfo.getUserId();
		Integration__c userDetail = [SELECT Access_Token__c FROM Integration__c WHERE User_Id__c =:userId];

        String boundary = '----------9889464542212';
        String delimiter = '\r\n--' + boundary + '\r\n';
        String close_delim = '\r\n--' + boundary + '--';

        String methodName = 'POST';
        String endPoint = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart';
        String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '","parents": [{"kind": "drive#fileLink","id": "'+folderId+'"}] }' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + file + close_delim;       
        Integer timeOut = 60000;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization','Bearer ' + userDetail.Access_Token__c);
        headerMap.put('content-type','multipart/mixed; boundary="' + boundary + '"');
        headerMap.put('Content-length', String.valueOf(body.length()));      
        HttpResponse res = GoogleDriveIntegrationService.getRresponse(methodName, endPoint, headerMap, body, timeOut);
    	System.debug(res.getStatusCode());
        if(res.getStatusCode() == 200){
            return 'success';
        }
        return 'error';
    }
    
    // Checking for aceess token is expired or not..
    
     @AuraEnabled
    public static string checkForAccessToken(){
        System.debug('hii checkForAccessToken');
        String userId = userInfo.getUserId();
        Integration__c userDetail = [SELECT Expire_Date__c FROM Integration__c WHERE User_Id__c =:userId];
        Datetime dTime = Datetime.now();
        if(userDetail.Expire_Date__c < dTime){
            return 'EXPIRED';
        }
        else{
            return 'NOT EXPIRED';
        }
    }
    
    // Method for renew access token...
    
    @AuraEnabled
    public static string getNewAccessToken(){
        String userId = userInfo.getUserId();
        
        Integration__c userDetail = [SELECT Refresh_Token__c FROM Integration__c WHERE User_Id__c =:userId];

        String methodName = 'POST';
        String endPoint = 'https://www.googleapis.com/oauth2/v3/token';
        String body = 'refresh_token=' + userDetail.Refresh_Token__c + '&grant_type=refresh_token&client_id=' +key1+ '&client_secret=' + secert;
        Integer timeOut = 60000;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-length', String.valueOf(endPoint.length()));      
        HttpResponse res = GoogleDriveIntegrationService.getRresponse(methodName, endPoint, headerMap, body, timeOut);  
       
        
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ; 
        String accesstoken =  String.valueOf(responseMap.get('access_token'));
        Datetime dTime = Datetime.now();
        Long tokenDate = dTime.getTime();
        tokenDate = tokenDate + ((Integer) responseMap.get('expires_in') * 1000);
        dTime = Datetime.newInstance(tokenDate);
        
        String userName = userInfo.getUserId();
        List<Integration__c> userDet = [SELECT Access_Token__c, Refresh_Token__c, Expire_Date__c FROM Integration__c WHERE User_Id__c =:userId];
        if(userDet.size() > 0){
            userDet[0].Access_Token__c = accesstoken;
            userDet[0].Expire_Date__c = dTime;
            Update userDet;
        }
        return 'UPDATED';
    }
    
    // Method for open folder 
    // Parameter = folderId  :- parent folder Id.
    
    @AuraEnabled
    public static List<object> openFolder(String folderId){
        List<object> files = new List<object>();
        String userId = userInfo.getUserId();
        Integration__c userDetail = [SELECT Access_Token__c FROM Integration__c WHERE User_Id__c =:userId];

        String methodName = 'GET';
        String endPoint = 'https://www.googleapis.com/drive/v3/files?q='+'"'+folderId+'"'+'+in+parents&trashed=false&fields=*';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Authorization','Bearer ' + userDetail.Access_Token__c);
        HttpResponse res = GoogleDriveIntegrationService.getRresponse(methodName, endPoint, headerMap);
                
        if(res.getStatusCode()==200){
            string response = res.getBody();
            Map<String, Object> results = (Map<String, Object>)
                JSON.deserializeUntyped(res.getBody());
            files = (List<Object>) results.get('files');
        }
        return files;
    }

}