public with sharing class AllIntegration {
    @AuraEnabled
    public static  List<object> getFiles1(){
        List<object> files = new List<object>();
        String rootFolder = '0';
        String methodName = 'GET';
        String endPoint = 'callout:BoxIntegration/2.0/folders/'+rootFolder+'/items';
        HttpRequest req = new HttpRequest();
        req.setMethod(methodName);
        req.setEndpoint(endPoint);

        Http ht = new Http();
        HttpResponse res = ht.send(req);
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
    public static  List<object> getFiles1Dropbox(){
        String folId = '';
        
        List<object> files = new List<object>();
        List<object> folderList = new List<object>();
        
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        String endpoint = 'callout:DropBox/2/files/list_folder';
        request.setEndpoint(endpoint);
        //request.setBody('{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,\"include_media_info\":false,\"include_mounted_folders\":true,\"include_non_downloadable_files\":true,\"path\":\"/Homework/math\",\"recursive\":false}');

        // if(folId == null){
        // request.setBody('{"include_deleted": false, "include_has_explicit_shared_members": false, "include_media_info": false, "include_mounted_folders": true, "include_non_downloadable_files": true, "path": "", "recursive": false}');
        // }else{
        //     request.setBody('{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,\"include_media_info\":false,\"include_mounted_folders\":true,\"include_non_downloadable_files\":true,\"path\":\"'+folId+'",\"recursive\":false}');
        // }

        System.debug('request>>>'+request);
        Http h = new Http();
        HttpResponse res = h.send(request);
        System.debug('res>>>'+res.getBody());
        String responseBody = res.getBody();
        responseBody = responseBody.replaceAll('.tag', 'tag');
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.debug(responseMap);
        files = (List<Object>) responseMap.get('entries');
        System.debug(files);
        return files;
        
    }
    @AuraEnabled
    public static List<Object> getfileGoogleDrive() {
        String folderId = 'root';
        System.debug('hii i am get files');
        List<Object> files = new List<Object>();
        String methodName = 'GET';
        //String endPoint = 'callout:GoogleDrive/drive/v3/files?q=' + '"'+folderId+'"' + '+in+parents&trashed=false&fields=*';
    
        HttpRequest req = new HttpRequest();
        req.setMethod(methodName);
        //req.setEndpoint(endPoint);
    
        // Set the named credential for the Google Drive callout
        req.setEndpoint('callout:GoogleDrive/drive/v3/files?q=' + EncodingUtil.urlEncode('"'+folderId+'"', 'UTF-8') + '+in+parents&trashed=false&fields=*');
       
        
        Http ht = new Http();
        HttpResponse res = ht.send(req);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
    
        if (res.getStatusCode() == 200) {
            String response = res.getBody();
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response);
            files = (List<Object>)results.get('files');
        }
        System.debug('files>>>>'+files);
        return files;
    }
    
}