@isTest
public class DropBoxMockClass implements HttpCalloutMock {
    public static HttpResponse respond(HttpRequest req){
        System.debug('mock class called');
        System.debug('............endpoint...........'+req.getEndpoint());
        HttpResponse res = new HttpResponse();
        String id = 'test_file_id';
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        System.debug('condition>>>>>>>>>>>'+req.getEndpoint());
        if(req.getEndpoint()=='https://api.dropboxapi.com/oauth2/token' ){
            System.debug('condition>>>>>>Called token');
            res.setStatusCode(200);
            res.setBody('{"access_token": "xyzzy","token_type": "bearer","refresh_token": "0eTsQ","expires_in": 3600}');
        }
        else if(req.getEndpoint() == 'https://api.dropboxapi.com/2/files/delete_v2'){
            //delete file
            System.debug('delete mock called');
            res.setStatusCode(200);
            res.setBody('Success');
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/list_folder'){
            //get files
            System.debug('in get files ********************');
            res.setStatusCode(200);
            System.debug('condition>>>>>>Called folder');
            res.setBody('{"entries": [{".tag": "folder", "name": "New folder (2)", "path_lower": "/new folder (2)", "path_display": "/New folder (2)", "id": "id:5CGifG5mzNEAAAAAAAAAEg"}]}');
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/get_temporary_link'){
            
            //download file.
            res.setStatusCode(200);
            res.setBody('{"link": "https://uc4aacdbe6675a38619f48fdc893.dl.dropboxusercontent.com/cd/0/"}');
        }
        else if(req.getEndpoint()=='https://content.dropboxapi.com/2/files/upload'){
            res.setStatusCode(200);
            res.setBody('upload');
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/create_folder_v2'){
            System.debug('Create Folder');
            res.setStatusCode(200);
            res.setBody('Create Folder Successfull');
        }
        return res;
    }
}