public class contact_List_controller {
  public integer Limitsize=10;
    public integer count=0;
    public list<contact> contactList{get;set;}
  
    
    public  contact_List_controller() {
        
        contactList=[select name from contact ];
        
    }
    
    public list<contact> getContacts(){
       list <contact> conList = new list<contact>();
        for(integer i=count;i<limitsize;i++)
        {
            conList.add(contactList[i]);
        }
        return conList;
    }
    
    public void last()
    {
        count= contactList.size()-math.mod(contactList.size(),10);
        limitsize = contactList.size();
    }
    public void first()
    {
        count =0;
        limitsize=10;
    }
    
    public void next()
    {
        if(limitsize==contactList.size()-math.mod(contactList.size(),10))
        {
            count=count+10;
            limitsize=contactList.size();
        }
        else
        {
            count=count+10;
            limitsize=limitsize+10;
        }
    }
    
    public void previous(){
        
        if(count==contactList.size()-math.mod(contactList.size(),10))
        {
           limitsize = count;
            count=count-10;
           
        }
        else
        {
           count= count-10;
            limitsize=limitsize-10;
        }
    }
    
    public boolean getNO_Next()
    {
        if(limitsize==contactList.size())
            return true;
        else
            return false;
    }
    
    public boolean getNO_prev()
        {
            if(count==0)
                return true;
            else
                return false;
        }
    
    
    
    public Integer getTotalPages()
    {
         integer rem= math.mod(contactList.size(),10);
        Integer quo = contactList.size() / 10;
        if(rem!=0)
        {
            quo=quo+1;
            return quo;
        }
        else
            return quo;
    }
}