trigger PlatfromEventNotification on Contact (After Update) {
    if(trigger.isAfter && trigger.isUpdate){
        System.debug('trigger run>>>>>');
            platformevent.SentNotificationbyEvent(trigger.new);
    }
}