@isTest
private class Client_Side_Pagination_Controller_Test {

    @isTest
    static void testGetAllObjects() {
        Test.startTest();
        Map<String, String> result = Client_Side_Pagination_Controller.getAllObjects();
        Test.stopTest();
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testFetchFieldsList() {
        Test.startTest();
        List<Client_Side_Pagination_Controller.PicklistOptions> result = Client_Side_Pagination_Controller.fetchFieldsList('Account');
        Test.stopTest();
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testFetchRecords() {
        Test.startTest();
        List<String> fieldsList = new List<String>{'Name', 'Industry', 'Type'};
        List<sObject> result = Client_Side_Pagination_Controller.fetchRecords('Account', fieldsList);
        Test.stopTest();
        System.assertNotEquals(null, result);
    }
}