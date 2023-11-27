public class SendAttachmentToDrive {
    public static void sendAttachment(Id accountId){
        List<ContentDocumentLink> documentLinks = [SELECT Id, ContentDocument.Title, ContentDocument.FileType, ContentDocument.LatestPublishedVersionId
                                                   FROM ContentDocumentLink
                                                   WHERE LinkedEntityId = :accountId 
                                                   AND ContentDocument.LatestPublishedVersionId != null];
        System.debug(documentLinks.size());
        System.debug(documentLinks[0].Id);
        // Iterate over the document links to upload files to Google Drive
        for (ContentDocumentLink documentLink : documentLinks) {
            // Retrieve the file details
            System.debug(documentLink.ContentDocument.LatestPublishedVersionId);
            ContentVersion contentData = [SELECT Title, PathOnClient, VersionData, fileType
                                          FROM ContentVersion
                                          WHERE Id = :documentLink.ContentDocument.LatestPublishedVersionId
                                          AND IsLatest = true]; 
            System.debug(contentData.fileType);
            
            
            String boundary = 'Ashish';
            String delimiter = '\r\n--' + boundary + '\r\n';
            String close_delim = '\r\n--' + boundary + '--';
            Blob st1 = contentData.VersionData;
            //system.debug('===================conver.VersionData======================='+st1.toString());  
            String bodyEncoded = EncodingUtil.base64Encode( contentData.VersionData);
            System.debug(bodyEncoded);
            //bodyEncoded = bodyEncoded.substring(4);
            System.debug(bodyEncoded);
            String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "name" : "' + contentData.Title + '",' + ' "mimeType" : "image/' + contentData.FileType + '"}' + delimiter + 'Content-Type: image/' + contentData.FileType + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;  
            //,"parents" :[{"id":"'+Folder Id+'"}]}' add folder ID if needed        system.debug('==================body======================'+body);  
            HttpRequest req = new HttpRequest();
            req.setheader('Content-Length',String.valueOf(body.length()));
            req.setheader('Content-Type','multipart/related; boundary='+boundary);
            req.setMethod('POST'); 
            req.setEndpoint('callout:GoogleNC/upload/drive/v3/files?uploadType=multipart'); 
            req.setBody(body); 
            System.debug(req.getBody());
            Http h = new Http(); 
            
            Httpresponse resp = h.send(req);
            System.debug(resp.getBody());
            System.debug(resp.getStatusCode());
            System.debug(resp.getStatus());
        }         
    }
}