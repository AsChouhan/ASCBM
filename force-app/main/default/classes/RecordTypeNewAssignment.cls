public class RecordTypeNewAssignment {   
     @InvocableMethod(label='Get Record Types' description='')
    public static List<RecordTypeChoice> getRecordTypes() {
        List<Choice> choices = new List<Choice>();
        List<RecordTypeChoice> choiceList = new List<RecordTypeChoice>{new RecordTypeChoice(choices)};
        Map<Id,Schema.RecordTypeInfo> recordTypeByIdMap = Schema.SObjectType.Case.getRecordTypeInfosById();
        for(Id recordTypeId : recordTypeByIdMap.keyset()){
            Schema.RecordTypeInfo info = recordTypeByIdMap.get(recordTypeId);
            if(info.isActive() && info.isAvailable() && !info.isMaster()){
                choices.add(new Choice(info.getName(), recordTypeId));
            }
        }
        return choiceList;
    }
    
    public class RecordTypeChoice { 
          //@AuraEnabled annotation exposes the methods to Lightning Components and Flows
          @InvocableVariable
          public List<Choice> choices; 
       
          // Define the structure of the Apex-Defined Variable
          public RecordTypeChoice(List<Choice> choices) {
              this.choices = choices;              
          }
          // Required no-argument constructor
          public RecordTypeChoice() {}
      }
}