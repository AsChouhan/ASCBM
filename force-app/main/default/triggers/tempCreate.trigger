trigger tempCreate on Account (before update) {
    List<account> accNew = Trigger.new;
    List<account> accOld = Trigger.old;
    List<Opportunity> tempList = new List<Opportunity>();
    Date dt = System.today();
    for(integer i = 0 ;i < accNew.size(); i++){
        if(accNew[i].name != accOld[i].name){
            System.debug('name changed');
            Opportunity op = new Opportunity(name=accOld[i].name, accountId = accNew[i].id, CloseDate = dt, StageName = 'Prospecting');
            tempList.add(op);
        }
    }
    System.debug(tempList.size());
    insert tempList;
}