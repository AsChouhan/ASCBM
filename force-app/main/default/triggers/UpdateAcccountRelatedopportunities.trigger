trigger UpdateAcccountRelatedopportunities on Account (After update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            AccountTriggerHandler.updateOpp(Trigger.new);
        }
    }

}