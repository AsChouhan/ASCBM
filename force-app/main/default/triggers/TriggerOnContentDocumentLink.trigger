trigger TriggerOnContentDocumentLink on ContentDocumentLink (before insert) {
   /* if(trigger.isBefore){
        set<Id> contactIds = new Set<Id>();
        System.debug(trigger.new.size());
   
        for(ContentDocumentLink ctl : trigger.new){
            if(ctl.LinkedEntityId != '0055g00000HLAidAAH'){
            	contactIds.add(ctl.LinkedEntityId);                
            }
        }   
        
        System.debug(contactIds);
        Map<Id, ContentDocumentLink> ContentDocumentLinkMap = New Map<Id, ContentDocumentLink>([select LinkedEntityId from ContentDocumentLink where LinkedEntityId IN :contactIds]);
        for(ContentDocumentLink ctl : ContentDocumentLinkMap.values()){
            System.debug(contactIds.contains(ctl.LinkedEntityId));
            System.debug(ctl.LinkedEntityId);
            if(contactIds.contains(ctl.LinkedEntityId)){
                ctl.addError('canUpload');
            }
        }
    }*/
}