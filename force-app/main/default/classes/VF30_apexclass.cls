public class VF30_apexclass {
    public Integer i{get;set;}
    public Account acc{get;set;}
    public Boolean bool;
    
    public VF30_apexclass(){
        i=10;
        System.debug('constructor' + i);
        acc=new Account();
    }
    public void Save(){
        i=20;
        System.debug('test save' + i);      
    }
    public void testSave(){
        bool =true;
        i=25;
        System.debug('test save' + i);
    }
}