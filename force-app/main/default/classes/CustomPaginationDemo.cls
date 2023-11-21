public  with sharing   class CustomPaginationDemo {
     class ContactWrapper
    {
        public Boolean isSelected {get;set;}
        public Contact cont{get;set;}        
        public ContactWrapper(Contact cont,Boolean isSelected)
        {
            this.cont= cont;
            this.isSelected= isSelected;
        }  
    }
    public List<ContactWrapper> lstWrapper {get;set;}
    public List<ContactWrapper> lstSetController{get;set;}
    
    CustomIterable obj;
    
    public CustomPaginationDemo() 
    {
        lstWrapper =  new List<ContactWrapper>();
        lstSetController = new List<ContactWrapper>();
        
        List<Contact> lstContact = [select id,name from Contact limit 20];
        
        for(Contact cont : lstContact )
        {
            lstWrapper.add(new ContactWrapper(cont ,false));
        }
        
        obj = new CustomIterable (lstWrapper); 
        obj.setPageSize = 5;
        next();         
    }
    
    
    public Boolean hasNext {
        get 
        {
            return obj.hasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get 
        {
            return obj.hasPrevious();
        }
        set;
    }
    
    public void next() 
    {
        lstSetController = obj.next();
    }
    
    public void previous() 
    {
        lstSetController = obj.previous();
    }
    
    public class  CustomIterable implements Iterator<list<ContactWrapper>>
    { 
        list<ContactWrapper> InnerList{get; set;}
        list<ContactWrapper> ListRequested{get; set;}
        
        Integer i {get; set;} 
        public Integer setPageSize {get; set;} 
        
        public CustomIterable(List<ContactWrapper> lstAccWr)
        {
            InnerList = new list<ContactWrapper >(); 
            ListRequested = new list<ContactWrapper >();     
            InnerList = lstAccWr;
            setPageSize = 10;
            i = 0; 
        }   
        
        public  boolean hasNext(){ 
            if(i >= InnerList.size()) {
                return false; 
            } else {
                return true; 
            }
        } 
        
        public boolean hasPrevious(){ 
            system.debug('I am in hasPrevious' + i);
            if(i <= setPageSize) {
                return false; 
            } else {
                return true; 
            }
        }   
        
        public list<ContactWrapper > next(){       
            system.debug('i value is ' + i);
            ListRequested = new list<ContactWrapper >(); 
            integer startNumber;
            integer size = InnerList.size();
            if(hasNext())
            {  
                if(size <= (i + setPageSize))
                {
                    startNumber = i;
                    i = size;
                }
                else
                {
                    i = (i + setPageSize);
                    startNumber = (i - setPageSize);
                }
                
                system.debug('i value is =====' + i);
                system.debug('i value is 2==== ' + (i - setPageSize));
                
                for(integer start = startNumber; start < i; start++)
                {
                    ListRequested.add(InnerList[start]);
                }
            } 
            return ListRequested;
        } 
        
        public list<ContactWrapper > previous(){      
            ListRequested = new list<ContactWrapper >(); 
            system.debug('i value is previous before =====' + i);
            integer size = InnerList.size(); 
            if(i == size)
            {
                if(math.mod(size, setPageSize) > 0)
                {    
                    i = size - math.mod(size, setPageSize);
                }
                else
                {
                    i = (size - setPageSize);
                } 
            }
            else
            {
                i = (i - setPageSize);
            }
            
            system.debug('i value is previous =====' + i);
            system.debug('i value is 2previous ==== ' + (i - setPageSize));
            
            for(integer start = (i - setPageSize); start < i; ++start)
            {
                ListRequested.add(InnerList[start]);
            } 
            return ListRequested;
        }   
    }
}