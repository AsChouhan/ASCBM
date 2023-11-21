public with sharing class MultiSelect_Combobox {
   
    @AuraEnabled//Method to get the List of All Objects
    public static Map<String, String> getAllObjectList(){ 
        Map<String,String> returnObjectMap = new Map<String,String>();
        for(Schema.SObjectType obj: Schema.getGlobalDescribe().values()){
            Schema.DescribeSObjectResult objResult = obj.getDescribe();
            if (objResult.isQueryable() && objResult.isDeletable() && objResult.isAccessible()
                && objResult.isCreateable() && objResult.isUpdateable() && objResult.isSearchable()){
                    String key = obj.getDescribe().getName();
                    String value = obj.getDescribe().getLabel();
                    returnObjectMap.put(key,value);
                }
        }
        System.debug('objectList'+returnObjectMap);
        return returnObjectMap;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> getRecords(String selectedObjectName){
        System.debug(selectedObjectName);
        List<sObject> recordOfObjectName = new List<sObject>();
        String fieldsName = 'Name';
        String recordsOfObjects = 'SELECT ' + fieldsName + ' FROM ' + selectedObjectName;
        recordOfObjectName = Database.query(recordsOfObjects);
        System.debug('record is '+ recordOfObjectName);
        return recordOfObjectName;
    }
}