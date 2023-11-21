public with sharing class Client_Side_Pagination_Controller {
   @AuraEnabled 
   public static map<String, String> getAllObjects(){
    Map<String , String> allObjects = new Map<String , String>();
        for(Schema.SObjectType obj : Schema.getGlobalDescribe().values()){
            Schema.DescribeSObjectResult ObjResult = obj.getDescribe();
            if (objResult.isQueryable() && objResult.isDeletable() && objResult.isAccessible()
                && objResult.isCreateable() && objResult.isUpdateable() && objResult.isSearchable()){
                    String key = obj.getDescribe().getName();
                    String value = obj.getDescribe().getLabel();
                    allObjects.put(key, value);
                }  
        }
        if(allObjects != null && allObjects.size() > 0){
            return allObjects;
        }else{
            return null;
        }
   }
   @AuraEnabled
   public static List<PicklistOptions> fetchFieldsList(String objectName) {
       List<PicklistOptions> fieldsList = new List<PicklistOptions>();
       if(String.isNotBlank(objectName)){
           Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
           for (String fieldName: fieldMap.keySet()) {  
               Schema.DescribeFieldResult field = fieldMap.get(fieldName).getDescribe();
               if (field.isAccessible() && field.isCreateable()) {
                   fieldsList.add(new PicklistOptions(field.getLabel(), field.getName(), apexTypetoJSType.get(String.valueof(field.getType())) ));
               }
           }
       }
       fieldsList.sort();
       return fieldsList;     
   }

   @AuraEnabled
   public static List<sObject> fetchRecords(String objectName, List<String> fieldsList) {
       try {
           if(String.isNotBlank(objectName) && fieldsList != null){
               String query = 'SELECT  ' + String.join(fieldsList, ',') + ' FROM '+objectName + ' LIMIT 50000';                
               List<sObject> records = Database.query(query);
               return records;
           }
           return null;
       } catch(Exception ex) {
           throw new AuraHandledException(ex.getMessage());
       }    
   }

   public class PicklistOptions implements Comparable {
       @AuraEnabled public String label;
       @AuraEnabled public String value;
       @AuraEnabled public String datatype;
       public PicklistOptions(String label, String value, String datatype) {
           this.label = label;
           this.value = value;
           this.datatype = datatype;
       }
       
       public Integer compareTo(Object ObjToCompare) {
           return label.CompareTo(((PicklistOptions)ObjToCompare).label);
       }
   }

   public class ReturnWrapper {
       @AuraEnabled public List<sObject> records;
   }

   public static Map<String, String> apexTypetoJSType = new Map<String, String> {
       'ADDRESS' => 'text',
       'ID' => 'text',
       'TEXTAREA' => 'text',
       'STRING' => 'text',
       'REFERENCE' => 'text',
       'PICKLIST' => 'text',
       'MULTIPICKLIST' => 'text',
       'DATE' => 'date',
       'DOUBLE' => 'number',
       'PERCENT' => 'percent',
       'PHONE' => 'phone',
       'URL' => 'url',
       'INTEGER' => 'number',
       'CURRENCY' => 'currency',
       'DATETIME' => 'date',
       'BOOLEAN' => 'boolean',
       'EMAIL' => 'email'
   };

}