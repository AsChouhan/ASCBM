@isTest
public with sharing class MultiSelect_ComboboxTest {
    @isTest
    static void TestgetAllObjectList() {
        Map<String,String> expectedObjectMap = new Map<String,String>();
        expectedObjectMap.put('Account', 'Account');
        expectedObjectMap.put('Contact', 'Contact');
        expectedObjectMap.put('Opportunity', 'Opportunity');
        
        Map<String,String> actualObjectMap = MultiSelect_Combobox.getAllObjectList();
        
        System.assertEquals(expectedObjectMap, actualObjectMap, 'false');
    }
    
    @isTest
    static void TestgetRecords() {
        // Insert test records
        List<Account> accountsToInsert = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert accountsToInsert;
        
        List<sObject> expectedRecords = new List<sObject>{
            accountsToInsert[0],
            accountsToInsert[1]
        };
        
        // Call the getRecords method with the test object name
        List<sObject> actualRecords = MultiSelect_Combobox.getRecords('Account');
        
        System.assertEquals(expectedRecords, actualRecords, 'The getRecords method did not return the expected records.');
    }
}