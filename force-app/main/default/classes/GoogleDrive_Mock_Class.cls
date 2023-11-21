global with sharing class GoogleDrive_Mock_Class implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
         
        //AccessToken
         if(req.getEndpoint()=='https://accounts.google.com/o/oauth2/token'){
             res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             res.setBody('{"access_token" :"ya29.a0AVvZVspINbmFOnB071MSBsrI8GolnWvoDyTmWz4wi738VtveOaDPWJE-31EUiWe7FtdnVq_X8Da9cWt40jnhL0v6rNFlOE7r1RPthyiFuGJ7tGI_ULIYYfIF9gWtRToId8USnn8jWIyfIStXhIkT63tHOoLBaCgYKAU0SARESFQGbdwaI9bFUNGsSTQ95CdHEH0fUfg0163","expires_in":3599, "refresh_token" :"1//0elWwmnTMBM2UCgYIARAAGA4SNwF-L9IrNDawwqi8YOU_osplnTtXOm4A2bRX546Xfi1bDpJlfbmTfagi46yjWeSs69py__Wcxg0", "scope":"https://www.googleapis.com/auth/drive", "token_type":"Bearer"}');
             res.setStatusCode(200);
         }
 
         //For Files and folders
         else if(req.getEndpoint()=='https://www.googleapis.com/drive/v3/files?q=%27Root%27%20in%20parents&trashed=false&fields=*'){
             res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             res.setBody('{\"files\" : [{"id": "1fn5vD1PGKRzopYvKChBaL-ftLhHT9Qio","mimeType": "image/png","name": "Untitled","webContentLink": "https://drive.google.com/uc?id=1fn5vD1PGKRzopYvKChBaL-ftLhHT9Qio&export=download","webViewLink": "https://drive.google.com/file/d/1fn5vD1PGKRzopYvKChBaL-ftLhHT9Qio/view?usp=drivesdk"}, {"id": "1fn5vD1PGKRzopYvKChBaL-ftLhHT9Qio","mimeType": "application/vnd.google-apps.folder","name": "Untitled","webContentLink": "https://drive.google.com/uc?id=1fn5vD1PGKRzopYvKChBaL-ftLhHT9Qio&export=download"}]}'); 
             res.setStatusCode(200);
         }
 
         //For Delete Files
         else if(req.getEndpoint() == 'https://www.googleapis.com/drive/v3/files/1fn5vD1PGKRzopYvKChBaL-ftLhHT9Qio'){
              res.setStatusCode(204);
         }
 
         //For Create Folder
         else if(req.getEndpoint() == 'https://www.googleapis.com/drive/v3/files/'){
             res.setStatusCode(200);
         }
 
         //For download file
         else if(req.getEndpoint() == 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media'){
              res.setStatusCode(200);
         }
        
      else if(req.getEndpoint() == 'https://www.googleapis.com/drive/v3/files?q=\'12345\' in parents&trashed=false&fields=*'){
      res.setStatusCode(200);        
      }
        return res;
     }
}