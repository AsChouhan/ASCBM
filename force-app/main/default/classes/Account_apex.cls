public class Account_apex {
    public Account a {get;set;}
    public id rec {get;set;}
    public Account_apex(){
        a=new Account();
    }
    public PageReference save(){
        insert a;
        rec = a.Id;
        PageReference pageRef = new PageReference('https://briskmindssoftwaresoluti-3f-dev-ed.my.salesforce.com/'+rec);
        return pageRef;
    }
    public void Qucike_save(){
        insert a;   
    }
    public PageReference del(){
        delete a;
        rec=a.Id;
        PageReference pageRef = new PageReference('https://briskmindssoftwaresoluti-3f-dev-ed.my.salesforce.com/search/UndeletePage');
        return pageRef;
           
    }
}