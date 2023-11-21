@Istest
public class MockClassOfGoogleDrive implements HttpCalloutMock {
    
    public static HttpResponse respond(HttpRequest req){
        System.debug('mock class called');
		System.debug('............endpoint...........'+req.getEndpoint());
        HttpResponse res = new HttpResponse();
        String id = 'test_file_id';
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        System.debug('condition>>>>>>>>>>>'+req.getEndpoint());
        if(req.getEndpoint()=='https://accounts.google.com/o/oauth2/token' ){
            System.debug('condition>>>>>>Called token');
            res.setStatusCode(200);
            res.setBody('{"access_token": "xyzzy","token_type": "bearer","scope": "https://www.googleapis.com/auth/drive","refresh_token": "0eTsQ","expires_in": 3600}');
        }
        else if(req.getEndpoint() == 'https://www.googleapis.com/drive/v3/files/'+ id){
            //records
            System.debug('delete mock called');
            res.setStatusCode(204);
            res.setBody('Success');
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/drive/v3/files?q='+'"'+id+'"'+'+in+parents&trashed=false&fields=*'){
            //filefolder
			System.debug('in get files ********************');
            res.setStatusCode(200);
            System.debug('condition>>>>>>Called folder');
            res.setBody('{"files": [{"mimeType": "file", "Id": "12345678"}, {"mimeType" : "folder", "Id" : "987654321"}]}');
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/drive/v2/files'){
            //create folder
            res.setStatusCode(200);
            res.setBody('FolderCreate');
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart'){
            res.setStatusCode(200);
            res.setBody('upload');
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/oauth2/v3/token'){
            System.debug('renew access token');
            res.setStatusCode(200);
            res.setBody('{"access_token": "xyzzy","token_type": "bearer","scope": "https://www.googleapis.com/auth/drive","refresh_token": "0eTsQ","expires_in": 3600}');
        }
        return res;
    }
    
}