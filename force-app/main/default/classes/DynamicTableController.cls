public with sharing class DynamicTableController {
//     @AuraEnabled(cacheable=true)
//    public static String picListValue(String recordId){
//     List<Account> picValue = [SELECT Id, Status__c FROM Account WHERE Id = :recordId LIMIT 1];
//     return picValue[0].Status__c;
//    }

//    @AuraEnabled(cacheable=true)
//    public static List<Account__c> getRecordsAcc(String recordId){
//     List<Account__C> picValue = [SELECT Id, Name, Rating__c, Industry__c, Date__c FROM Account__c WHERE Account__c = :recordId];
//     return picValue;
//    }
   
//    @AuraEnabled(cacheable=true)
//    public static List<Contact__c> contactRec(String recordId){
//     List<Contact__c> contactsRecord = [SELECT Id, Name, Status__c,  Date__c FROM Contact__c WHERE Account__c = :recordId];
//     return contactsRecord;
//    }

//    @AuraEnabled(cacheable=true)
//    public static List<Case__c> caseRecords(String recordId){
//     List<Case__c> caseRecord = [SELECT Id, Name, Start_Date__c,  Status__c, Subject__c  FROM Case__c WHERE Account__c = :recordId];
//     return caseRecord;
//    }

//    @AuraEnabled(cacheable=true)
//    public static List<Contract__c> contractRecords(String recordId){
//     List<Contract__c> contractRec = [SELECT Id, Name, Activated_Date__c,  Status__c, Special_Terms__c  FROM Contract__c WHERE Account__c = :recordId];
//     return contractRec;
//    }

//    @AuraEnabled
//    public static void insertAccounts(String jsonOfListOfAccounts) {
//        List<Account__c> listOfAccounts = (List<Account__c>) JSON.deserialize(jsonOfListOfAccounts, List<Account__c>.class);
//        System.debug('list of records is>>>'+listOfAccounts);
//        upsert listOfAccounts;
//    }  
}