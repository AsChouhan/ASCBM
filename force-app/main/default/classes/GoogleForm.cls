public with sharing class GoogleForm {
    static User_Info__mdt custMeta = [select Cient_Id__c, Client_secret__c, Redirect_Url__c from User_Info__mdt];
    public static void getForms(){
        try{
            String endPoint = 'callout:Google_Forms/v1/forms/1vletpcuNbqaUJJ5i3FEi_0AiIlVVVTJ_fulgBYMEbQM';
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(endPoint);
            HttpResponse result = new Http().send(req);
            System.debug(result.getStatusCode());
            System.debug(result.getStatus());
            GoogleFormWrapper formWrapper = (GoogleFormWrapper)JSON.deserialize(result.getBody(), GoogleFormWrapper.class);
            System.debug(formWrapper.Info.title);
            createRecord(formWrapper);
        }catch(Exception ex){
            System.debug('inside getForm exception');
            System.debug(ex.getMessage());
        }
    }

    public static void getFormResponses(){
        String endPoint = 'callout:Google_Forms/v1/forms/1vletpcuNbqaUJJ5i3FEi_0AiIlVVVTJ_fulgBYMEbQM/responses';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endPoint);
        HttpResponse result = new Http().send(req);
        System.debug(result.getStatusCode());
        System.debug(result.getStatus());
        System.debug(result.getBody());
    }

    public static void createRecord(GoogleFormWrapper formWrapper){    
        String formTitle = formWrapper.info.title;
        String responderUri = formWrapper.responderUri;
        String formId = formWrapper.formId;
        Map<String, String> questionMap = new Map<String, String>();

        for(GoogleFormWrapper.Items item : formWrapper.items){
            questionMap.put(item.questionItem.question.questionId, item.title);
        }
        String questions = (String)JSON.serialize(questionMap);
        List<Google_Form__c> gf = [SELECT Id, Form_Id__c, Questions__c, Responder_Uri__c from Google_Form__c WHERE Form_Id__c = :formId WITH SECURITY_ENFORCED LIMIT 1];
        if(gf.size() == 0){
                insert new Google_Form__c(Name = formTitle, Form_Id__c = formId, Questions__c = questions, Responder_Uri__c = responderUri);
        }else {
            gf[0].Questions__c = questions;
            gf[0].Responder_Uri__c = responderUri;
            update gf;
        }
    }
}