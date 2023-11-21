@IsTest
public class TestRecordGenreate {
    Public static List<Account> AccountRecords(){
        List<Account> accountList=new List<Account>();
        for(Integer i=1;i<=15;i++){
           accountList.add(new Account(Name = 'test'+i));
        }
        insert accountList;
        return accountList;
    }
    public static List<Contact> getContact(){ 
        List<Contact> cntList = new List<Contact>(); 
        for(Integer i = 0 ; i < 10; i++){ 
            Contact cnt = new Contact(); 
            cnt.lastName = 'Demo Batch Contact ' + i; 
            //cnt.LastCURequestDate = Date.today(); 
           // cnt.BirthDate = DateTime.now(); 
            cnt.DoNotCall = true; 
            cnt.Description = 'Demo, Description'; 
            cntList.add(cnt); 
        } 
        insert cntList; 
        return cntList; 
    }
}