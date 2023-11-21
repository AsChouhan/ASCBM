public class Hot {
    public static void mainMethod(list<Opportunity> l){
        list <Account> li = [SELECT Rating FROM Account];
        list<Account> listupdate = new list<Account>();
        for(opportunity o: l){
            For(Account obje : li){
                if(o.StageName == 'Closed won' && o.AccountID == obje.id){
                    obje.Rating='hot';
                    listupdate.add(obje);
                }
            }
        }
        update listupdate;
    }
}