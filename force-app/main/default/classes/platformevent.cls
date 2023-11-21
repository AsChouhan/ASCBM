public with sharing class platformevent {
   public static void SentNotificationbyEvent(List<Contact> con){
    Show_Tost_Message__e eventObj = new Show_Tost_Message__e(Notification__c = 'Record Update');
        Database.SaveResult sr = EventBus.publish(eventObj);
        if(sr.isSuccess()){
            System.debug('successfully');
        }else{
            System.debug('not successfull');
        }
   }
}