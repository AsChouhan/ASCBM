public class Display_Record {
   public List<Account> acc {get;set;}
    public Display_Record(){ 
    acc = [SELECT Id,Name,Industry,Rating FROM account];
    }
}