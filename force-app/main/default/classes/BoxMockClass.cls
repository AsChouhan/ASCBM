@isTest
public class BoxMockClass implements HttpCalloutMock {
    public static HttpResponse respond(HttpRequest req){
        System.debug('mock class called');
        System.debug('............endpoint...........'+req.getEndpoint());
        HttpResponse res = new HttpResponse();
        String id = 'test_file_id';
        System.debug('https://upload.box.com/api/2.0/files/content?parent_id='+id);
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        System.debug('condition>>>>>>>>>>>'+req.getEndpoint());
        if(req.getEndpoint()=='https://www.box.com/api/oauth2/token?' ){
            System.debug('condition>>>>>>Called token');
            res.setStatusCode(200);
            res.setBody('{"access_token": "xyzzy","token_type": "bearer","refresh_token": "0eTsQ","expires_in": 3600}');
        }
        else if(req.getEndpoint() == 'https://api.box.com/2.0/folders/'+id){
            //delete file
            System.debug('delete mock called');
            res.setStatusCode(204);
            res.setBody('Success');
        }
        else if(req.getEndpoint()=='https://api.box.com/2.0/folders/'+id+'/items'){
            //get files
            System.debug('in get files ********************');
            res.setStatusCode(200);
            System.debug('condition>>>>>>Called folder');
            res.setBody('{"entries": [{".tag": "folder", "name": "New folder (2)", "path_lower": "/new folder (2)", "path_display": "/New folder (2)", "id": "id:5CGifG5mzNEAAAAAAAAAEg"}]}');
        }
        else if(req.getEndpoint()=='https://api.box.com/2.0/files/' + id + '/content'){
            
            //download file.
            res.setStatusCode(304);
            res.setHeader('location', 'https://uc4aacdbe6675a38619f48fdc893.dl.dropboxusercontent.com/cd/0/');
            res.setBody('{"link": "https://uc4aacdbe6675a38619f48fdc893.dl.dropboxusercontent.com/cd/0/"}');
        }
        else if(req.getEndpoint()=='https://upload.box.com/api/2.0/files/content?parent_id='+id){
            System.debug('upload called');
            res.setStatusCode(201);
            res.setBody('upload');
        }
        else if(req.getEndpoint()=='https://api.box.com/2.0/folders'){
            System.debug('Create Folder');
            res.setStatusCode(201);
            res.setBody('Create Folder Successfull');
        }else if(req.getEndpoint()== 'https://api.box.com/oauth2/token'){
            // renew access token
            res.setStatusCode(200);
            res.setBody('{"access_token": "xyzzy","token_type": "bearer","refresh_token": "0eTsQ","expires_in": 3600}');
        }
        
        return res;
    }
}