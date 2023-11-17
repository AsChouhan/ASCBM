@isTest
public class Box_testClass {
    static String client_id= '7pwpj8a3weeokk4bm1sn8t2s5jy71m68';
    static String redirectUri = 'https://briskmind9-dev-ed.my.site.com/DemoCompInt/s/?tabset-b975d=5db90';
    
    public static User createUser(){
        User testUser = new User(
            Username = 'aashessh.singh@gmail.com',
            
            Email = 'testuser@example.com',
            Alias = 'testuser',
            CommunityNickname = 'testuser',
            LastName = 'Testing11',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = UserInfo.getProfileId(),
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        return testUser;
    }
    
    
    @isTest
    public  static void testcheckUserInDatabase() {
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test BoxUserInfo__mdt record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            // Call the Apex method being tested
            Test.startTest();
            String result = BoxApexController.checkUserInDatabase();
            Test.stopTest();
            System.debug(result);
            // Assert that the result is as expected
            System.assertEquals(result, 'FOUND');            
        }        
    }
    
    @isTest
    static void testcreateAuthUrl() {
        
        // Define test data
        String expectedAuthUri = 'https://account.box.com/api/oauth2/authorize?' +'response_type=code&'+
            'client_id='+client_id+            
            '&redirect_uri='+redirectUri;       
        // Call the method being tested
        Test.startTest();        
        String authUri = BoxApexController.createAuthUrl();
        Test.stopTest();        
        // Check the result  
        System.debug(expectedAuthUri+'\n'+authUri);
        System.assertEquals(expectedAuthUri, authUri);
    }  
    
    @isTest
    static void testgetAccessToken() {        
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Define test data        
        String code = 'test_code';       
        String oout = BoxApexController.getAccessToken(code);
        System.debug(oout == 'pass');
        System.debug(oout);
        System.assertEquals(oout, 'pass');
        
    }
    
    @isTest
    static void testDeleteData() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            Integer res;
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.DeleteData('test_file_id', 'folder');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 204);            
        }       
    } 
    
    @isTest
    static void testgetFiles() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            Map<Integer,List<object>> res = new Map<Integer, List<object>>();
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.getFiles('test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res.get(200).size()!=0, true);            
        }       
    } 
    
    @isTest
    static void testdownloadFiles() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            Map<Integer,String> res = new Map<Integer, String>();
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.downloadFiles('test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res.get(304).length()!=0, true);            
        }       
    } 
    
    @isTest
    static void testuploadFileToBox() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            Integer res;
            String tempFileData = 'eyJuYW1lIjoiYXMgc2lnbi5qcGciLCJkb2N1bWVudElkIjoiMDY5NWcwMDAwMEN4ajE2QUFCIiwiY29udGVudFZlcnNpb25JZCI6IjA2ODVnMDAwMDBEQWVWR0FBMSIsImNvbnRlbnRCb2R5SWQiOiIwNVQ1ZzAwMDAwaWxsUnNFQUkiLCJtaW1lVHlwZSI6ImltYWdlL2pwZWcifQ==';
            
            
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.uploadFileToBox(tempFileData, 'aasheesh', 'test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 201);            
        }       
    } 
    
    @isTest
    static void testcreateFolder() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            Integer res;
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.createFolder('aasheesh', 'test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 201);            
        }       
    } 
    
    @isTest
    static void testgetNewAccessToken() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            Integer res;
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.getNewAccessToken();
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 200);            
        }       
    } 
    
    @isTest
    static void testcheckForAccessToken() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.checkForAccessToken();
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res.length()!=null, true);            
        }       
    } 
    
     @isTest
    static void testdeleteUserRecord() {
        Test.setMock(HttpCalloutMock.class, new BoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            Box_User__c testUserDetail = new Box_User__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
            Test.startTest();
            res = BoxApexController.deleteUserRecord();
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 'success');            
        }       
    } 
}