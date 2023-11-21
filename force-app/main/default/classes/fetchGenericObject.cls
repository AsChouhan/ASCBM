public with sharing class fetchGenericObject {
    @AuraEnabled//Method to get the List of All Objects
    public static Map<String, String> getAllObject(){ 
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
        //System.debug(returnObjectMap);
        if(returnObjectMap != null && returnObjectMap.size() > 0){
            return returnObjectMap;
        }else{
            return null;
        }
    }
}