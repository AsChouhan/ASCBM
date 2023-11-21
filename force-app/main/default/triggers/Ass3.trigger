trigger Ass3 on Account (After insert) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            Account Acc = Trigger.New[0];
            Contact c = new Contact(Lastname=Acc.Name, AccountId=Acc.Id);
            System.debug(c);
            insert c;
        }
    }
}