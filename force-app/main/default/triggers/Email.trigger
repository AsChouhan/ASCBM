trigger Email on Account (before insert,before update) {
    for(Account ac:Trigger.new){
        for(Account acAdd:[Select Email__c from Account]){
            if(ac.Email__c==acAdd.Email__c && ac.Id != acAdd.Id)
                ac.addError('This Email is Already Existing .');
        }
    }
}