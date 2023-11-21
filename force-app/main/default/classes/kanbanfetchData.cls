public class kanbanfetchData {
    @AuraEnabled
    public static Map<String,String> getFields(String selectedObject){
        Map<String,String> allFieldsMap = new Map<String,String>(); 
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        SObjectType objType = objectMap.get(selectedObject);
        Map<String,Schema.SObjectField> objTypeFields = objType.getDescribe().fields.getMap();
        
        for(String fieldName: objTypeFields.keySet()){
            if(objTypeFields.get(fieldName).getDescribe().getType()==Schema.DisplayType.Picklist){
                allFieldsMap.put(objTypeFields.get(fieldName).getDescribe().getLabel(),objTypeFields.get(fieldName).getDescribe().getName());
            }
        }
        system.debug(allFieldsMap.values().size());
        return allFieldsMap;    
    }

    @AuraEnabled
    public static KanBanWrapper getRecords(String selectedObject , String pickListField){ 
        System.debug('inmethod');
        String query='';
        if(selectedObject == 'Case'){
             query  = ' SELECT Id , CaseNumber , ' + pickListField + ' FROM ' + selectedObject;
        }
        else{
         query  = ' SELECT Id , Name , ' + pickListField + ' FROM ' + selectedObject;
        }
        List <sObject> records = Database.query(query);
        System.debug(records);

        List<String> pickListValuesList = new List<String>();
        Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(selectedObject);
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(pickListField).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            pickListValuesList.add(objPickList.getValue());
        }
        pickListValuesList.add('None');
        
        system.debug(new KanBanWrapper(records,pickListValuesList));
        return new KanBanWrapper(records,pickListValuesList);
    }

    @AuraEnabled
    public static String getUpdatePickListValue_Apex(Id recordId, String sObjectPickListValue, String pickListUpdatedValue) {
        SObject sObjectRecord = recordId.getSObjectType().newSObject(recordId);
        sObjectRecord.put(sObjectPickListValue, pickListUpdatedValue);
        update sObjectRecord;
        return 'Success';
    }

    public class KanBanWrapper{
        @AuraEnabled
        public List<sObject> records {get;set;}
        @AuraEnabled
        public List<String> pickVals {get;set;}
        
        public KanBanWrapper(List<sObject> recs, List<String> pVals){
            this.records = recs;
            this.pickVals = pVals;
        }
    }
}