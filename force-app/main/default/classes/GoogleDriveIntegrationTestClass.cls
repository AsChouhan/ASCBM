@isTest
global with sharing class GoogleDriveIntegrationTestClass {
            
     /* @isTest static void getAccessTokenTest() {
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl =  GoogleDriveIntegration.createAuthURL();
        String checkUser = GoogleDriveIntegration.checkUserInDatabase();
        String code='4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        Test.startTest();
        String response = GoogleDriveIntegration.getAccessToken(code);
        System.assertEquals('ya29.a0AVvZVspINbmFOnB071MSBsrI8GolnWvoDyTmWz4wi738VtveOaDPWJE-31EUiWe7FtdnVq_X8Da9cWt40jnhL0v6rNFlOE7r1RPthyiFuGJ7tGI_ULIYYfIF9gWtRToId8USnn8jWIyfIStXhIkT63tHOoLBaCgYKAU0SARESFQGbdwaI9bFUNGsSTQ95CdHEH0fUfg0163', response);
        Test.stopTest();
        }*/
    @isTest static void getAccessTokenTest() {
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl =  GoogleDriveIntegration.createAuthURL();
        String checkUser = GoogleDriveIntegration.checkUserInDatabase();
        String code = '4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        Test.startTest();
        String response = GoogleDriveIntegration.getAccessToken(code);
        System.assertEquals('ya29.a0AVvZVspINbmFOnB071MSBsrI8GolnWvoDyTmWz4wi738VtveOaDPWJE-31EUiWe7FtdnVq_X8Da9cWt40jnhL0v6rNFlOE7r1RPthyiFuGJ7tGI_ULIYYfIF9gWtRToId8USnn8jWIyfIStXhIkT63tHOoLBaCgYKAU0SARESFQGbdwaI9bFUNGsSTQ95CdHEH0fUfg0163', response);
        
        Map<String, object> responseMap = (Map<String, object>)JSON.deserializeUntyped(response);  
        String token = String.valueOf(responseMap.get('access_token'));
        String refreshToken = String.valueOf(responseMap.get('refresh_token'));
        
        Long expiresInSeconds = (Integer)responseMap.get('expires_in');
        Long tokenExpirationTime = Datetime.now().getTime() + expiresInSeconds * 1000;
        Datetime dTime = Datetime.newInstance(tokenExpirationTime); 
        
        Integration__c accessInfo = [SELECT Name__c, Access_Token__c, Refresh_Token__c, User_Id__c, Expire_Date__c FROM Integration__c WHERE User_Id__c =: UserInfo.getUserId()];
        
        if(refreshToken == null){
            accessInfo.Name__c = UserInfo.getName();
            accessInfo.Access_Token__c = token;
            accessInfo.Refresh_Token__c = refreshToken;
            accessInfo.User_Id__c = UserInfo.getUserId();
            accessInfo.Expire_Date__c = dTime;
            update accessInfo;
        }else{
            accessInfo = new Integration__c(Name__c = UserInfo.getName(), Access_Token__c= token, Refresh_Token__c= refreshToken, User_Id__c = UserInfo.getUserId(), Expire_Date__c = dTime);
            insert accessInfo;
        }
        Integration__c updatedAccessInfo = [SELECT Access_Token__c, Refresh_Token__c, Expire_Date__c FROM Integration__c WHERE User_Id__c =: UserInfo.getUserId()];
        System.assertEquals(token, updatedAccessInfo.Access_Token__c);
        System.assertEquals(refreshToken, updatedAccessInfo.Refresh_Token__c);
        System.assertEquals(dTime, updatedAccessInfo.Expire_Date__c);
        Test.stopTest();
    }
    
    
    //For Test Re-generate Access Token Functionality.
    @isTest static void getNewAccessTokenTest() {
        Integration__c userInfoAdd = new Integration__c ();
        userInfoAdd.Access_Token__c='accesstoken';
        userInfoAdd.Refresh_Token__c='refreshtoken';
        userInfoAdd.Expire_Date__c =System.now().addHours(-10);
        userInfoAdd.User_Id__c= UserInfo.getUserId();
        insert userInfoAdd;
        String userId = UserInfo.getUserId();
        List<Integration__c> userDet = [SELECT Access_Token__c, Refresh_Token__c, Expire_Date__c FROM Integration__c WHERE User_Id__c =:userId];
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl =  GoogleDriveIntegration.createAuthURL();
        String checkUser =GoogleDriveIntegration.checkUserInDatabase();
        String code='4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        Test.startTest();
        String response = GoogleDriveIntegration.getNewAccessToken();
        System.assertEquals('ya29.a0AVvZVspINbmFOnB071MSBsrI8GolnWvoDyTmWz4wi738VtveOaDPWJE-31EUiWe7FtdnVq_X8Da9cWt40jnhL0v6rNFlOE7r1RPthyiFuGJ7tGI_ULIYYfIF9gWtRToId8USnn8jWIyfIStXhIkT63tHOoLBaCgYKAU0SARESFQGbdwaI9bFUNGsSTQ95CdHEH0fUfg0163', response);
        Test.stopTest();
        
    }
    
    //For Test Files Functionality.
    @isTest static void getfile1Test() {
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl =  GoogleDriveIntegration.createAuthURL();
        String checkUser = GoogleDriveIntegration.checkUserInDatabase();
        String code='4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        String accessToken = GoogleDriveIntegration.getAccessToken(code);
        String folderId = 'Root';
        Test.startTest();
        List<object> files = GoogleDriveIntegration.getfile1(folderId);
        Map<String, Object> file = (Map<String, Object>)files[0];
        System.assertEquals(files.size() > 0, true);
        Test.stopTest();
    }
        
    //For Test Delete Files Functionality.
    @isTest 
    static void deleteDataTest() {
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl =  GoogleDriveIntegration.createAuthURL();
        String checkUser =GoogleDriveIntegration.checkUserInDatabase();
        String code='4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        String accessTokns = GoogleDriveIntegration.getAccessToken(code);
        String accessToken = 'ya29.a0AVvZVspINbmFOnB071MSBsrI8GolnWvoDyTmWz4wi738VtveOaDPWJE-31EUiWe7FtdnVq_X8Da9cWt40jnhL0v6rNFlOE7r1RPthyiFuGJ7tGI_ULIYYfIF9gWtRToId8USnn8jWIyfIStXhIkT63tHOoLBaCgYKAU0SARESFQGbdwaI9bFUNGsSTQ95CdHEH0fUfg0163';
        String fileId = '1fn5vD1PGKRzopYvKChBaL-ftLhHT9Qio';
        Test.startTest();
        GoogleDriveIntegration.deleteData(fileId);
        Test.stopTest();
    }
    
    
    //For Test Create Folder Functionality.
    @isTest static void createFolderinDriveTest() {
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl =  GoogleDriveIntegration.createAuthURL();
        String checkUser =GoogleDriveIntegration.checkUserInDatabase();
        String code='4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        String accessTokns = GoogleDriveIntegration.getAccessToken(code);
        String accessToken = 'ya29.a0AVvZVspINbmFOnB071MSBsrI8GolnWvoDyTmWz4wi738VtveOaDPWJE-31EUiWe7FtdnVq_X8Da9cWt40jnhL0v6rNFlOE7r1RPthyiFuGJ7tGI_ULIYYfIF9gWtRToId8USnn8jWIyfIStXhIkT63tHOoLBaCgYKAU0SARESFQGbdwaI9bFUNGsSTQ95CdHEH0fUfg0163';
        String folderName ='hello';
        String FolderId = 'xyz123';
        Test.startTest();
        String response = GoogleDriveIntegration.createFolderinDrive(folderName,FolderId);
        System.assertEquals(response ,'success' );
        Test.stopTest();
    }
    
    //For Test Upload Files Functionality.
    @isTest 
    static void uploadFileTest() {
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl = GoogleDriveIntegration.createAuthURL();
        String checkUser = GoogleDriveIntegration.checkUserInDatabase();
        String code = '4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        String accessToken = GoogleDriveIntegration.getAccessToken(code);
        ContentVersion con = new ContentVersion(Title = 'Cats', PathOnClient = 'Kitten.jpg', VersionData = blob.valueOf('100852'));
        insert con;
        List<ContentVersion> cvFile = [SELECT Title, VersionData, FileType, ContentDocumentId FROM ContentVersion];
        Test.startTest();
        String response = GoogleDriveIntegration.uploadFile(cvFile[0].Title, cvFile[0].FileType, cvFile[0].VersionData, 'folderId');
        System.assertEquals(response, 'success');
    }
    @isTest
    static void openFolderTest() {
        // Create a mock HTTP response
        Test.setMock(HttpCalloutMock.class, new GoogleDrive_Mock_Class());
        String authUrl =  GoogleDriveIntegration.createAuthURL();
        String checkUser =GoogleDriveIntegration.checkUserInDatabase();
        String code='4/0AWtgzh4n-3o2JdRy5361jNOoGQW1WYo_EvN4jKBUGilbl3_WsjrzBSRjuTuYMMEwmHLJPA';
        String accessTokns = GoogleDriveIntegration.getAccessToken(code);
        String accessToken = 'ya29.a0AVvZVspINbmFOnB071MSBsrI8GolnWvoDyTmWz4wi738VtveOaDPWJE-31EUiWe7FtdnVq_X8Da9cWt40jnhL0v6rNFlOE7r1RPthyiFuGJ7tGI_ULIYYfIF9gWtRToId8USnn8jWIyfIStXhIkT63tHOoLBaCgYKAU0SARESFQGbdwaI9bFUNGsSTQ95CdHEH0fUfg0163';
        String mockResponse = '{ "files": [] }';
        // Call the apex class method
        List<object> files = GoogleDriveIntegration.openFolder('12345');
        // Assert the result
        System.assertEquals(0, files.size());
    }
    
    @isTest
    static void testCheckForAccessToken() {
        // create test data
        Integration__c integration = new Integration__c(User_Id__c = UserInfo.getUserId(),
                                                        Expire_Date__c = System.now().addHours(1));
        insert integration;
        // call the method
        Test.startTest();
        String result = GoogleDriveIntegration.checkForAccessToken();
        Test.stopTest();
        // assert the result
        System.assertEquals('NOT EXPIRED', result);
    }
}