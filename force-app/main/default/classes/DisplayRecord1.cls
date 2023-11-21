public class DisplayRecord1 {
    public Id rec {get;set;}
     public List<Account> acc {get;set;}
    public DisplayRecord1(){ 
    acc = [SELECT Id,Name,Industry,Rating FROM account];
    }
     public PageReference save(){
        update acc;
       
        PageReference pageRef = new PageReference('https://briskmindssoftwaresoluti-3f-dev-ed.my.salesforce.com/001/o');
        return pageRef;
    }
    public void Quick(){
        update acc;
        
    }
}