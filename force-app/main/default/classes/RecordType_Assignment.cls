global class RecordType_Assignment {
   /* @InvocableMethod(label='Get Record Types for Case' category = 'case')
    global static List<RecordTypeWrapper> getCaseRecordTypes() {
        List<RecordTypeWrapper> recordTypeList = new List<RecordTypeWrapper>();
        
        // Query for the RecordType objects associated with the Case object
      // List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' WITH USER_MODE];
       List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case'];
        System.debug('recordType :-'+recordTypes);
        // Loop through the record types and create a RecordTypeWrapper for each one
        for (RecordType rt : recordTypes) {
            recordTypeList.add(new RecordTypeWrapper(rt.Name, rt.Id));
        }
        System.debug('RecordType:-'+recordTypeList);
        return recordTypeList;
    }
    global class RecordTypeWrapper {
        @InvocableVariable
        public String name;
        @InvocableVariable
        public String ids;
        
        public RecordTypeWrapper(String name, String ids) {
            this.name = name;
            this.ids = ids;
        }
    }*/
}