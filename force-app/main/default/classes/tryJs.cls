public class tryJs {
    {
        List<account> ac = [select name from account where name like 'atul%' for update];
    }
    public static void tempMethod(){
        List<account> ac = [select name from account where isdeleted = true and name like 'atul%' for update];
        SavePOint sp1 = Database.setSavepoint();
        Database.undelete(ac);
       // Database.rollback(sp1);
    }
    
    public static void deleteMethod(){
        List<account> ac = [select name from account where name like 'atul%'];
        Savepoint sp1 = Database.setSavepoint();
        delete ac;
        Database.rollback(sp1);
    }
}