public class CaseObjectRecordType {
  @InvocableMethod(label='Get CaseALL RecordType' category = 'Case')
    public static List<RecordTypeWrapper> getRecordTypes() {
         List<RecordTypeWrapper> recordTypeList = new List<RecordTypeWrapper>();
            List<SelectOption> recordTypes = new List<SelectOption>();
        for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isActive() && info.isAvailable() && !info.isMaster()) {
                recordTypes.add(new SelectOption(info.getRecordTypeId(), info.getName()));
            }
        }
        
        for( SelectOption selopt: recordTypes ) {
            //System.debug( selopt.getLabel() + ',' + selopt.getValue() );
            recordTypeList.add(new RecordTypeWrapper(selopt.getLabel(), selopt.getValue()));
        }
         System.debug(recordTypeList);
        return recordTypeList;
    }
    public class RecordTypeWrapper{
        @InvocableVariable
        public String name;
        @InvocableVariable
        public String ids;
        
         public RecordTypeWrapper(String name, String ids) {
            this.name = name;
            this.ids = ids;
        }
    }
}