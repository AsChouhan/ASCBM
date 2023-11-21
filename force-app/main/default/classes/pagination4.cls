public class pagination4 {
    public List<SelectOption> Options {get;set;}
    public String FilterId {get; set;}
    public List<Account> con;
    public Integer pageSize{ get; set;}
    
    public pagination4(){
        con = [SELECT ID, Name, Rating, Industry FROM Account];
        Options = new List<SelectOption> {
            new SelectOption('all_accounts', 'All Accounts'),
                new SelectOption('my_accounts', 'My Accounts'),
                new SelectOption('recently_viewed_accounts', 'Recently Viewed Accounts'),
                new SelectOption('new_this_week', 'New This Week'),
                new SelectOption('new_last_week', 'New Last Week')
                };
        FilterId = 'all_accounts';
        Filter();
        pageSize = 5;
    }
    
    public List<Account> getAccountRecords(){
        return (List<Account>) std.getRecords();
    }
    public PageReference Filter() {
        String query = 'Select Id, Name, Rating, Industry from Account';
        if(FilterID == 'all_accounts'){
            query =query+ '';
        }
        else if(FilterID == 'my_accounts'){
            Id userId =UserInfo.getUserId();
            query =query+ ' where OwnerId =: userId';
        }
        else if(FilterID == 'recently_viewed_accounts'){
            query =query+ ' where LastViewedDate != NULL ';
        }
        else if(FilterID == 'new_this_week'){
            query =query+ ' WHERE CreatedDate = LAST_N_DAYS:7';
        }
        else if(FilterID == 'new_last_week'){
            query =query+ ' WHERE CreatedDate = LAST_N_WEEKS:1';
        }
        ApexPages.StandardSetController Aps = new ApexPages.StandardSetController(Database.Query(query));
        std = Aps;
        return null;
    }
    
    public ApexPages.StandardSetController std{
        get{
            if(std == null){
                std = new ApexPages.StandardSetController(con);
            }
            std.setPageSize(pageSize);
            return std;
        }
        set;
    }
    public Integer PageNumber {
        get{ return std.getPageNumber(); }
        set;
    }
    public Integer TotalPages{
        get{
            if(Math.Mod(std.getResultSize(), std.getPageSize()) == 0)
                this.TotalPages = (std.getResultSize() / std.getPageSize());
            else
                this.TotalPages = (std.getResultSize() / std.getPageSize()) + 1;
            return totalpages;
        }
        set;
    }
    public List<SelectOption> getPageSizeOptionList(){
        List<SelectOption> options = new list<SelectOption>{
            new SelectOption('5', '5'),
                new SelectOption('10', '10'),
                new SelectOption('20', '20')
                };
                    return options;
    }
    public PageReference customSave(){
        update std.getRecords();
        PageReference pgr = new PageReference('/');
        return pgr;
    }
    public PageReference CustomQuickSave(){
        update std.getRecords();
        return null;
    }
    
}