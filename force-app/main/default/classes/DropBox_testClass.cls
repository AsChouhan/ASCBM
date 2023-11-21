@isTest
public class DropBox_testClass {
	static String client_id= 'enbuz6cte3x12dd';
    static String redirectUri = 'https://briskmind9-dev-ed.my.site.com/DemoCompInt/s/?tabset-b975d=3';
    
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
    public  static void testCheckUserInDatabase() {
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test GoogleDriveUserData__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            // Call the Apex method being tested
            Test.startTest();
            String result = DropBoxApex.checkUserInDB();
            Test.stopTest();
            System.debug(result);
            // Assert that the result is as expected
            System.assertEquals(result, 'FOUND');            
        }        
    }
    
    @isTest
    static void testCreateAuthURL() {
        String uri = EncodingUtil.urlEncode(redirectUri,'UTF-8');
        // Define test data
        String expectedAuthUri = 'https://www.dropbox.com/oauth2/authorize?' +
            'client_id='+client_id+'&token_access_type=offline'+
        '&response_type=code'+            
        '&redirect_uri='+uri;       
        // Call the method being tested
        Test.startTest();        
        String authUri = DropBoxApex.creatAuthUrl();
        Test.stopTest();        
        // Check the result  
        System.assertEquals(expectedAuthUri, authUri);
    }  
    
    @isTest
    static void testGetAccessToken() {        
        Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Define test data        
        String code = 'test_code';       
        String oout = DropBoxApex.getAccessToken(code);
        System.debug(oout);
        System.assertEquals( oout, 'xyzzy');
        
    }
    
    
    @isTest
    static void testDeleteData() {
         Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Create a test user
        User testUser = createUser();
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
           	Test.startTest();
            res = DropBoxApex.deleteFiles('test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 'FILE DELETED');            
        }       
    }  
    
    @isTest
    static void testgetFiles() {
        Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Create a test user
        User testUser = createUser();        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            List<object> res = new List<object>();
            // Call the method with test data
           	Test.startTest();
            res = DropBoxApex.getFiles('test_file_id');
            Test.stopTest();
            System.debug(res.size());        
            // Verify the response            
            System.assertEquals(res.size()!=0, true);            
        }       
    } 
    
      @isTest
    static void testgetNewAccessToken() {
         Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Create a test user
        User testUser = createUser();
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
           	Test.startTest();
            res = DropBoxApex.getNewAccessToken();
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 'UPDATED');            
        }       
    }  
    
        @isTest
    static void testdownloadFiles() {
         Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Create a test user
        User testUser = createUser();
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            object res;
            // Call the method with test data
           	Test.startTest();
            res = DropBoxApex.downloadFiles('test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res!=null, true);            
        }       
    }  
    
      @isTest
    static void testuploadFile() {
         Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Create a test user
        User testUser = createUser();
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
           	Test.startTest();
            res = DropBoxApex.uploadFile('aasheesh', 'test_file_id', 'tempFileData');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 'success');            
        }       
    } 
    
    @isTest
    static void testtryCreate() {
         Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Create a test user
        User testUser = createUser();
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
           	Test.startTest();
            res = DropBoxApex.tryCreate('aasheesh', 'test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res, 'pass');            
        }       
    }  
    
    @isTest
    static void testcheckExpiration() {
         Test.setMock(HttpCalloutMock.class, new DropBoxMockClass());
        // Create a test user
        User testUser = createUser();
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test DropBox_Users__c record for the test user
            DropBox_Users__c testUserDetail = new DropBox_Users__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
           	Test.startTest();
            res = DropBoxApex.checkExpiration();
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals(res.length()!=0, true);            
        }       
    }  
    
    
}