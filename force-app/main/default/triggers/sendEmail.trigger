trigger sendEmail on School__c (After insert) {
    if(trigger.isInsert && trigger.isAfter){
        SendEmailTriggerHandler.sendEmail(trigger.new);
    }

}