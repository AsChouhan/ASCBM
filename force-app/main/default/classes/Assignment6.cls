public class Assignment6 {
    public static void DpRecord(List<Lead> l){
     Account Acc;
     opportunity o;
     Contact cc;
        for(Lead M:l){
            Acc=new Account();
            Acc.Name=M.FirstName;
            cc=new contact();
            cc.FirstName = M.FirstName;
            cc.LastName = M.LastName;
             o = new opportunity();
            o.Name = M.FirstName;
            o.StageName ='Closed Lost';
            o.CloseDate = date.today();
        }   
        insert Acc;
    }
}