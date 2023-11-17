@isTest
public class GoogleDrive_Test {
    static String client_id= '628511661444-b31n71hm3v6kigbphkm9bn58d1qd63g2.apps.googleusercontent.com';
    static String redirectUri = 'https://briskmind9-dev-ed.my.site.com/DemoCompInt/s/?tabset-b975d=2';
    @isTest
    public  static void testCheckUserInDatabase() {
        // Create a test user
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
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            // Call the Apex method being tested
            Test.startTest();
            String result = GoogleDriveApexController.checkUserInDatabase();
            Test.stopTest();
            
            // Assert that the result is as expected
            System.assertEquals('Found', result);
            
        }
        
        
    }
    @TestSetup
    public static void setupData(){
        // Load the test accounts from the static resource
        List<sObject> ls = Test.loadData(Account.sObjectType, 'AccountTestData');
        system.debug('test Check '+ls);
    }
    
    @isTest
    static void testCreateAuthURL() {
        String uri = EncodingUtil.urlEncode(redirectUri,'UTF-8');
        // Define test data
        String expectedAuthUri = 'https://accounts.google.com/o/oauth2/auth?' +
            'client_id='+client_id+'&response_type=code&scope=https://www.googleapis.com/auth/drive&' +
            'redirect_uri='+uri+'&access_type=offline';
        String key1 = 'KEY_VALUE';
        String redirect_uri = 'REDIRECT_URI_VALUE';
        
        // Call the method being tested
        Test.startTest();
        
        String authUri = GoogleDriveApexController.createAuthURL();
        Test.stopTest();
        
        // Check the result
        System.debug(authUri);
        System.debug(expectedAuthUri);
        System.assertEquals(expectedAuthUri, authUri);
    }
    
    
    
    @isTest
    static void testGetAccessToken() {
        
        Test.setMock(HttpCalloutMock.class, new MockClassOfGoogleDrive());
        // Define test data
        
        String code = 'test_code';
        
        
        String oout = GoogleDriveApexController.getAccessToken(code);
        System.debug(oout);
        System.assertEquals('xyzzy', oout);
    }
    
    @isTest
    static void testDeleteData() {
         Test.setMock(HttpCalloutMock.class, new MockClassOfGoogleDrive());
        // Create a test user
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
        
        System.runAs(testUser){
            System.debug(userInfo.getUserId());
            // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            String res;
            // Call the method with test data
           	Test.startTest();
            res = GoogleDriveApexController.deleteData('test_file_id');
            Test.stopTest();
            System.debug(res);        
            // Verify the response            
            System.assertEquals('success', res);            
        }       
    }  
    
    @isTest
    static void testgetfile1() {
        Test.setMock(HttpCalloutMock.class, new MockClassOfGoogleDrive());
        // Create a test user
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
        
        System.runAs(testUser){
             // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            
            
            
            List<Object> res = new List<Object>();
            // Call the method with test data
           	Test.startTest();
            res = GoogleDriveApexController.getfile1('test_file_id');
            Test.stopTest();
            System.debug(res.size());
            System.assertEquals(res.size() !=0, true); 
        }
    }
    
    @isTest
    static void testcreateFolderinDrive() {
        Test.setMock(HttpCalloutMock.class, new MockClassOfGoogleDrive());
        // Create a test user
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
        
        System.runAs(testUser){
             // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            String res;
            // Call the method with test data
           	Test.startTest();
            res = GoogleDriveApexController.createFolderinDrive('Ashish','test_file_id');
            Test.stopTest();

            System.assertEquals(res, 'Success');            
        }
    }
    
     @isTest
    static void testuploadFile() {
        Test.setMock(HttpCalloutMock.class, new MockClassOfGoogleDrive());
        // Create a test user
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
        
        System.runAs(testUser){
             // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            String res;
            object obFile;
            // Call the method with test data
           	Test.startTest();
            res = GoogleDriveApexController.uploadFile('Ashish','file', obFile, 'test_file_id');
            Test.stopTest();

            System.assertEquals(res, 'success');            
        }
    }
    
    
     @isTest
    static void testgetNewAccessToken() {
        Test.setMock(HttpCalloutMock.class, new MockClassOfGoogleDrive());
        // Create a test user
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
        
        System.runAs(testUser){
             // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            String res;
            object obFile;
            // Call the method with test data
           	Test.startTest();
            res = GoogleDriveApexController.getNewAccessToken();
            Test.stopTest();

            System.assertEquals(res, 'UPDATED');            
        }
    }
    
     @isTest
    static void testopenFolder() {
        Test.setMock(HttpCalloutMock.class, new MockClassOfGoogleDrive());
        // Create a test user
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
        
        System.runAs(testUser){
             // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            List<object> res = new List<object>();
            object obFile;
            // Call the method with test data
           	Test.startTest();
            res = GoogleDriveApexController.openFolder('test_file_id');
            Test.stopTest();

            System.assertEquals(res.size()!=0, true);            
        }
    }
    
     @isTest
    static void testcheckForAccessToken() {

        // Create a test user
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
        
        System.runAs(testUser){
             // Create a test GoogleDriveUserData__c record for the test user
            GoogleDriveUserData__c testUserDetail = new GoogleDriveUserData__c(
                User_ID__c = userInfo.getUserId(),
                Access_Token__c = 'testAccessToken'
            );
            insert testUserDetail;
            String res;

            // Call the method with test data
           	Test.startTest();
            res = GoogleDriveApexController.checkForAccessToken();
            Test.stopTest();
            System.assertEquals(res.length()!=0, true);            
        }
    }
}