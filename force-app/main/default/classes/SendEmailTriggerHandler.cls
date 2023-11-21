public with sharing class SendEmailTriggerHandler {
    public static void sendEmail(List<School__c> newSchoolRec){
        List<Id> OwnerId = new List<Id>();
        //List<User> user = new List<User>();
        List<String> user = new List<String>();
        String Email;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        // for(School__c rec : newSchoolRec){
        //     OwnerId.add(rec.CreatedById);
        // }
       EmailTemplate emailTemplate =[Select Id, Subject, Description, HtmlValue, DeveloperName, Body from EmailTemplate where name = 'SchoolEmail'];
       
       for(School__c rec : newSchoolRec){
            if(rec.Stage__c	 == 'Close'){
                message.setTargetObjectId(rec.CreatedById);

            }
       } 
       //user = [SELECT Id, Email FROM User WHERE Id IN :OwnerId AND Email != null];
       
    //    user.add('bsofficial20@gmail.com');
       
    //    user.add('kumawatbhawani51@gmail.com');
    
        for(String re : user){
       message.toAddresses = new String[] {};
       }
       message.setUseSignature(false);
       message.setBccSender(false);
       message.setSaveAsActivity(false);
       message.setTemplateID(emailTemplate.Id);
       Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
       Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}