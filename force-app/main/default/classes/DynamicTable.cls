public with sharing class DynamicTable {
    
    @AuraEnabled(cacheable=true)
    public static String picListValue(String recordId){
     List<Account> picValue = [SELECT Id, Status__c FROM Account WHERE Id = :recordId LIMIT 1];
     return picValue[0].Status__c;
    }
    //Method for retrive record releted to given account id...
    // Parameter = accountId - parent account id...
    @AuraEnabled
    public static List<sObject> getData(String accountId){
        try {
            String query = 'select name, Status__c, (select parent__r.Name, Date__c, Industry__c, Name, Rating__c from Accounts__r), (select parent__r.Name, name, Date__c, Description__c, Status__c from Cases__r), (select parent__r.Name, name, PickList__c, Date__c from Contacts__r), (select parent__r.Name, name, Date__c, Description__c, Status__c from Contracts__r) from account where Id=\''+accountId+'\'';
            List<Account>accList = Database.query(query);
            return accList;
        } catch (Exception e) {
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }


    // Method for upload 
    // paremeter updatingRecords  -  list of object for update or insert records..
    @AuraEnabled
    public static List<sObject> uploadData(List<object> updatingRecords){
        List<sobject> obList = new List<sObject>();
        for(object ib : updatingRecords){
            String st = JSON.serialize(ib);
            sObject obb = (sObject)JSON.deserialize(st, sObject.class);
            obList.add(obb);
            System.debug(obb);          
        }
        upsert obList;
        System.debug(obList[0].getSObjectType().getDescribe().getName());
        if(obList[0].getSObjectType().getDescribe().getName() == 'Case__c'){
            obList = [select name, Date__c, Description__c, Status__c from Case__c];
            return obList;
        }else if(obList[0].getSObjectType().getDescribe().getName() == 'Contract__c'){
            obList = [select name, Date__c, Description__c, Status__c from Contract__c ];
            return obList;
        }else{
            return obList;
        }
    }
}