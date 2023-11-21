public class FilterView {
    public List<Account> act{get;set;}
    public List<SelectOption> option {get;set;}    
    public string str {get;set;}
    id ids = userinfo.getUserId();
    
    {
        act = [select name,rating,industry from account ];
    }
    public  FilterView(){
       option = new List<selectOption>{
                new SelectOption('select name,rating,industry from account','All Account'),
                new SelectOption('select name,rating,industry from account where ownerid = : ids','My Account'),        
                new SelectOption('select name,rating,industry from account where createddate = last_week','New Last Week'),
                new SelectOption('select name,rating,industry from account where createddate = last_month ','New Last Month')
                };        
             }   
    public void recordStore(){       
        act.clear();      
        act = database.query(str); 
    }
    public PageReference save(){
        update act;
        PageReference pageRef = new PageReference('https://briskmindssoftwaresoluti-3f-dev-ed.my.salesforce.com/001/o');
        return pageRef;
        
    }
    public void Quick(){
        update act;
    }    
}