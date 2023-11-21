public class VFpageAccount {
    public Account acc{get;set;}
    public VFpageAccount(){
        acc=new Account();
    }
    public void testSave(){
        System.debug('---->'+acc.name);
        insert acc;
    }

}