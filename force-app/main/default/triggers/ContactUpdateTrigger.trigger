trigger ContactUpdateTrigger on contact (before update) {
    for(Contact ct : trigger.new){
        System.debug(ct.Id);
    }
	/*System.debug('trigger called');    
    Set<Id> contectIds = new Set<Id>();
    contectIds.addAll(trigger.NewMap.keySet());
    List<ContentDocumentLink> ContentDocuments = [select id, LinkedEntityId, contentDocumentId from ContentDocumentLink where LinkedEntityId IN :contectIds];
    Map<Id, ContentDocumentLink> documentMap = new Map<Id, ContentDocumentLink>();
    for(ContentDocumentLink cdl : ContentDocuments){
        if(!documentMap.containsKey(cdl.LinkedEntityId)){
            documentMap.put(cdl.LinkedEntityId, cdl);
        }
    }
    for(Contact ct : Trigger.new){
        if(documentMap.containsKey(ct.Id)){
            ct.addError('Can\'t upload multiple files');
        }
    }    */
}