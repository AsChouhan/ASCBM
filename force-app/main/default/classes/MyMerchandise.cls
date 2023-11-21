public class MyMerchandise {
    public List<Merchandise__c>  MerchandiseList{get;set;}
    public MyMerchandise(){
        MerchandiseList=[SELECT Id,Name__c,job_Description__c,Price__c,Total_inventory__c FROM Merchandise__c];
    }
}