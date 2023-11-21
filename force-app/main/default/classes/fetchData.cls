public class fetchData {
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
    
    @AuraEnabled //Method to get all the fields of a particular Object
    public static Map<String,String> getAllfields(String objectName){
        Map<String,String> allFields = new Map<String,String>();
        
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        SObjectType objType = objectMap.get(objectName);
        
        // Map of fields with api name and Api name as value
        Map<String,Schema.SObjectField> objTypeFields = objType.getDescribe().fields.getMap();
        if(!objTypeFields.isEmpty()){
            for (String fieldName: objTypeFields.keySet()) {
                //getting labels of the fields
                String  fieldApi = objTypeFields.get(fieldName).getDescribe().getName();
                String fieldLabel = objTypeFields.get(fieldName).getDescribe().getLabel();
                allFields.put(fieldApi,fieldLabel);
            }
        }
        //System.debug(allFields);
        return allFields;
    }
    @AuraEnabled
    public static RecordsWrapper retrieveRecord( String ObjectName, List<String> Fields , Integer pagesize1){
        List<Sobject> recList = new List<Sobject>(); 
        String qry = 'SELECT ';
        qry+= fields[0];
        for (Integer i = 1; i < fields.size(); i++){
            qry += ',' + fields[i] +' ';
        }
        qry +=' FROM ' + objectName+ ' ORDER BY Id Limit:pagesize1';
        //System.debug(qry);
        recList = Database.query(qry);
        // System.debug('record'+recList);
        RecordsWrapper recWrap = new RecordsWrapper(); 
        recWrap.totalRecords = Database.query('SELECT Id FROM ' + objectName).size(); 
        recWrap.ListOfRecords = recList;
        return  recWrap;       
    }
    @AuraEnabled
    public static List<sObject> getSortRecords( List<Id> idofrecord, List<String> fields, String objectName, String sortField, String sortDir , Integer pagesize1){
        String query = 'SELECT ' + String.join(fields, ',  ')+ ' FROM ' + objectName + ' WHERE Id IN :idofrecord'+' ORDER BY ' + sortField + ' '+sortDir + ' Limit:pagesize1';
        // System.debug('records >>>>>>>'+query);
        List<sObject> records= Database.query(query);
        return records;
    }
    @AuraEnabled
    public static List<sObject> nextButtonRecord(Id recotdId, String objectName, List<String> Fields, Integer pagesize1){
        System.debug('hii ');
        String query = 'SELECT ' + String.join(Fields, ',  ')+ ' FROM ' + objectName + ' WHERE Id > :recotdId ORDER BY Id Limit:pagesize1';
        List<sObject> nextRecords = Database.query(query);
        System.debug('next>>'+nextRecords);
        return nextRecords;
    }
    @AuraEnabled
    public static List<sObject> previousButtonRecords(Id recotdId, String objectName, List<String> Fields, Integer pagesize1){
            String query = 'SELECT ' + String.join(Fields, ',  ')+ ' FROM ' + objectName + ' WHERE Id < :recotdId ORDER BY Id DESC';
        List<sObject> previousRecords = Database.query(query);
        List<sObject> records = new List<sObject>();
        for(integer i=0;i<pagesize1;i++){
           
            records.add(previousRecords[i]);
        }
        return records;
    } 
    @AuraEnabled
    public static List<sObject> lastButtonRecords(String objectName, List<String> Fields, Integer pagesize1){
        System.debug('hii ');
        String query = 'SELECT ' + String.join(Fields, ',  ')+ ' FROM ' + objectName + ' ORDER BY Id DESC';
        List<sObject> lastRecords = Database.query(query);
        System.debug('next>>'+lastRecords);
        List<sObject> records = new List<sObject>();
        for(integer i=0;i<pagesize1;i++){
            records.add(lastRecords[i]);
        }
        return records;
    }
    @AuraEnabled
    public static List<sObject> setPageRecord(Id recotdId, String objectName, List<String> Fields, Integer pagesize1){
        String query = 'SELECT ' + String.join(Fields, ',  ')+ ' FROM ' + objectName + ' WHERE Id >= :recotdId ORDER BY Id ASC Limit:pagesize1';   
        List<sObject> changeRecordSizeGetRecords = Database.query(query);
        return changeRecordSizeGetRecords;
    }
    public class RecordsWrapper{ 
        @AuraEnabled public List<sObject> ListOfRecords {get;set;} 
        @AuraEnabled public Integer totalRecords {get;set;} 
    }
}