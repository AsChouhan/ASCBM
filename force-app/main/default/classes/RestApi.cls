@RestResource(urlMapping='/content/*')
global class RestApi {
    @HTTPGet
    global static List<ContentVersion> doGet(){
        List<ContentVersion> fileRecords = [SELECT Id, Title, ContentDocumentId, FileType, ContentSize, VersionNumber, OwnerId, CreatedDate FROM ContentVersion];
        return fileRecords;
    }
    @HTTPPost
    global Static void Post(){
        String title, fileStringValue;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        System.debug(req);
        System.debug(req.params);
        String jsonBody = req.params.toString();
        System.debug(jsonBody);
        JSONParser parser = JSON.createParser(jsonBody);
        System.debug(jsonBody);
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() != JSONToken.END_OBJECT){
                if(parser.getCurrentName() == 'filename'){
                    title = parser.getText();
                }else if(parser.getCurrentName() == 'file'){
                    fileStringValue = parser.getText();
                }
            }
        }
        blob fileBlob = EncodingUtil.base64Decode(fileStringValue);
        System.debug(fileBlob);
        ContentVersion cv = new ContentVersion();
        cv.Title = title;
        cv.PathOnClient = title;
        cv.VersionData = fileBlob;
        System.debug(cv);
        insert cv;
        System.debug(cv);
        ContentVersion c = [SELECT Id, ContentDocumentId, ContentSize from ContentVersion WHERE Id= :cv.Id];
        System.debug(c.ContentSize);
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = c.ContentDocumentId;
        cdl.LinkedEntityId = '0035j000018BYXVAA4';
        cdl.ShareType = 'V';
        insert cdl;
    }
}