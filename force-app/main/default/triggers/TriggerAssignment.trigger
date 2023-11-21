trigger TriggerAssignment on Contact (After insert,after Delete,after undelete, after update) {
    TriggerHendler hendlerObj = new TriggerHendler();
        if(Trigger.isInsert && Trigger.isAfter){
            hendlerObj.insertion1(Trigger.new);
        }
        else if(Trigger.isDelete && Trigger.isAfter){
            hendlerObj.deleteRecord(Trigger.old);
        }
        else if(Trigger.isUndelete && Trigger.isAfter){
            hendlerObj.undeleteRecord(Trigger.new);
        }
       else if(Trigger.isUpdate && Trigger.isAfter && TriggerHendler.recursive1){
         TriggerHendler.recursive1=false;
         hendlerObj.updateRecord(Trigger.newMap ,Trigger.oldMap, Trigger.new,Trigger.old); 
   }
}