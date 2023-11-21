public with sharing class  GetRecordType_16May {
    @InvocableMethod(label='16 may case Record Type' category = 'Case')
    Public static List<Choice1> AllRecords(){
         //List<RecordTypeInfo> RT = Case.SObjectType.getDescribe().getRecordTypeInfos();
        //Schema.DescribeSObjectResult R = case.SObjectType.getDescribe().getRecordTypeInfos();
        //List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        List<choice> result = new List<choice>();
        List<Choice1> choiceList = new List<Choice1>{new Choice1(result)};       
        //System.debug('recordType'+ RT);
        //
            for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
                if(info.isActive() && info.isAvailable() && !info.isMaster()) {
                    result.add(new choice(info.getName(), info.getRecordTypeId()));
                }
            }
        
        System.debug(choiceList);
        return choiceList;
    } 
    public with sharing class  Choice1{
        @InvocableVariable
        public List<choice> recordsList;
        
        public Choice1(List<choice> recordsList){
            this.recordsList = recordsList;
        }
    }
}