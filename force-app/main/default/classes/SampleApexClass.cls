public class SampleApexClass {
    public void sampleFunction(){
        List<Account> lst = [Select Id, Name,Website,Phone,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account];
        
        for(Account acc : lst){
            acc.Description = 'This is sample Account';
        }
        
        update lst;
    }
}