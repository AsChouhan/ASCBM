public class ComponentController {
    //*********************************************************All List and Map***********************************************************************************************************     
    public List<SelectOption>                            SelectedFieldOptions       {get;set;}
    public List<String>                                  ListIteration              {get;set;}
    public List<WrapperClass>                            myList                     {get;set;}
    public ApexPages.StandardSetController               ssc                        {get;set;}
    public Map<id,WrapperClass>                          mapHoldingSelectedRecords  {get;set;}
    public List<String> 								 allAlphabet				{get;set;}
    public List<SelectOption> 						     options					{get;set;}
    public List<SObject> 								 DeleteSelected				{get;set;}
    public String                                        objectName                 {get;set;}
    
    //*******************************************************pagination varibales***********************************************************************************************   
    public Integer 										pageSize					{get;set;}
    public Integer 										TotalPages					{get;set;}
    public Integer 										pageNumber					{get;set;}
  //public Integer                                      pagNumber                   {get;set;}
    public boolean  									disablePageButton 			{get;set;}
    public Boolean 										disableLastPageButton 		{get;set;}
    public boolean  									disableNextPageButton 		{get;set;}
    //******************************************************Display Record use varibale******************************************************************************************* 
    public String 										query						{get;set;}
    public String 										filterQuery					{get;set;}
    public String 										selectedAlphabet			{get;set;}
    public String 										sortQuery 					{get;set;}
    public String 										sortExp						{get;set;}
    public String 										sortFieldName				{get;set;}
    
    public id 											retrieveId 					{get;set;}
    public Boolean 										paginationCheck				{get;set;}
    public Integer 										count						{get;set;}
    public String  										recordId					{get;set;}
    public Boolean 										componenthide				{get;set;}
    public Boolean										headerCheck					{get;set;}
    public String 										CSVFile						{get;set;}
    
    //*********************************************************Constructor***********************************************************************************************************    
    public ComponentController(){
        SelectedFieldOptions = new List<SelectOption>();
        mapHoldingSelectedRecords = new Map <id, WrapperClass>();
        paginationCheck = true;
        disablePageButton=true;
        disableLastPageButton = false;
        disableNextPageButton=false;
        pageNumber=1;
        pageSize=5;
        options = new list<SelectOption>{
            new SelectOption('5', '5'),
                new SelectOption('10', '10'),
                new SelectOption('20', '20')
                };
                    componenthide=false;
        myList = new List<WrapperClass>();
        allAlphabet=new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Other ','All'};   
       }
    
    
    //****************************************************************** Display Record*******************************************************************************************//
    public void display(){
        myList.clear();
        sortExp='ASC';
        sortFieldName='';
        componenthide=true;
        
        listIteration = new List<String>();
        query='SELECT ';
        for(SelectOption s:SelectedFieldOptions){
            
            query+=s.getValue()+',';
            listIteration.add(s.getValue());
        }
        query+='FROM '+objectName;
        query=query.replace(',FROM', ' FROM');
        
        ssc = new apexPages.StandardSetController(Database.getQueryLocator(query));
        ssc.setPageSize(pageSize);
        
        System.debug('-->'+pageSize);
        for(sObject obj : ssc.getRecords()){
            myList.add(new WrapperClass(obj,false));
        }
        TotalPages = (ssc.getResultSize() / ssc.getPageSize());
        if(TotalPages == 0){
            pageNumber = 0;
        }
        ssc.setPageNumber(pageNumber);    
    } 
    
    
    //***************************************************************Alphabetic Filter******************************************************************************************//
    public void filterRecord(){
        updateSearchItemsMap();
        mylist.clear();
        selectedAlphabet = selectedAlphabet.remove(' ');
        filterQuery = query;
        
        if(selectedAlphabet == 'All') {
            filterQuery = query;
        } 
        else if(selectedAlphabet=='Other') { 
            filterQuery +=' where not(Name like \'A%\''; 
            
            for(Integer i=1; i<allAlphabet.size()-2; i++){ 
                filterQuery += ' or Name like \'' + allAlphabet[i] + '%\''; 
            } 
            filterQuery += ')'; 
            System.debug(filterQuery);
        }
        else{
            // System.debug('----->'+selectedAlphabet);
            filterQuery = filterQuery + ' WHERE Name Like \''+selectedAlphabet+'%\'';
            // System.debug(filterQuery);
        }
        System.debug('-->'+Database.getQueryLocator(filterQuery));
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(filterQuery));
        ssc.setPageSize(pageSize);
        // System.debug('--->'+ssc.getRecords());
        for(sObject obj1 : ssc.getRecords()) {
            //System.debug('---->'+obj1);
            myList.add(new WrapperClass(obj1,false));
        }
        TotalPages = (ssc.getResultSize() / ssc.getPageSize());
    }
//******************************************************* method  manages to remove the deselected records*******************************************************************************//
    public Map<id, WrapperClass> updateSearchItemsMap() { 
        for (WrapperClass wrp: myList) { 
            if (wrp.isCheck) { 
                mapHoldingSelectedRecords.put(wrp.NestObj.id, wrp); 
            } 
        }return mapHoldingSelectedRecords; 
    }
    
//*******************************************************getRecords Function call**********************************************************************************************************//   
    public List < WrapperClass > getrecords() {
        count=0;
        myList.clear();
        for (Sobject cont:ssc.getRecords()) {
            System.debug('---->'+cont.id);
            recordId = cont.id;
            if (mapHoldingSelectedRecords != null && mapHoldingSelectedRecords.containsKey(cont.id)) {
                myList.add(mapHoldingSelectedRecords.get(cont.id));
                count++;
                //System.debug(count);
            } else {
                myList.add(new WrapperClass(cont, false));
            }
        }
        // System.debug('myList = ' + myList);
        if(count == myList.size() || count == ssc.getResultSize()){
            headerCheck = true;
        }else{
            headerCheck = false;
        }
        
        if(ssc.getRecords().isEmpty()){
            paginationCheck = false;
            headerCheck = false;
        }else{
            paginationCheck = true;
        }
        return myList;
    }
    
//*********************************************************Pagination Functionality********************************************************************************************// 
    public void pageset(){
        updateSearchItemsMap();
        ssc.setPageSize(pageSize);//set the page Size
        TotalPages = (ssc.getResultSize() / ssc.getPageSize());
        myList.clear();
        for(SObject c : ssc.getRecords()){
            myList.add(new WrapperClass(c,false));
        }
        getrecords();
    }
    public void next(){
        updateSearchItemsMap();
        ssc.next();//Returns the next page of records.
        disableLastPageButton = false;
        TotalPages = (ssc.getResultSize() / ssc.getPageSize());
         pageNumber++;
        if(pageNumber==TotalPages){
             disableNextPageButton=true;
            disableLastPageButton=true;
            disablePageButton=false;
        }else{
            disablePageButton=false;
        }
        myList.clear();
        for(SObject c : ssc.getRecords()){
            myList.add(new WrapperClass(c,false));
        }
        getrecords();
    }
    public void Last(){
        updateSearchItemsMap();
        ssc.Last();//Returns the last page of records.
        pageNumber=TotalPages;
        disableLastPageButton=true;
        disablePageButton=false;
        disableNextPageButton=true;
        myList.clear();
        for(SObject c : ssc.getRecords()){
            myList.add(new WrapperClass(c,false));
        }
        getrecords();
    }
    public void previous(){
        updateSearchItemsMap();
        ssc.previous();
        disableNextPageButton=false;
        disableLastPageButton=false;
        
        pageNumber--;
        if(pageNumber==1){
            disablePageButton=true;
        }
        myList.clear();
        for(SObject c : ssc.getRecords()){
            myList.add(new WrapperClass(c,false));
        }
        getrecords();
    }
    public void first(){
        updateSearchItemsMap();
        disablePageButton=true;           
        disableNextPageButton=false;          
        disableLastPageButton=false;              
        pageNumber=1;
        ssc.first();
        myList.clear();
        for(SObject  c : ssc.getRecords()){
            myList.add(new WrapperClass(c,false));
        }
        getrecords();
    }
    /*public void pagejump(){
         updateSearchItemsMap();
        if(pageNumber<1){
            pageNumber = 1;
        }
        else if(pageNumber >(TotalPages / pageSize) +1){
            pageNumber = (TotalPages / pageSize) +1;
        }
        ssc.setPageNumber(pageNumber); 
        myList.clear();
       for(sObject obj : ssc.getRecords()){
           if(recordId.contains(obj.Id)){
            myList.add(new WrapperClass(obj,true));
           }else{
            myList.add(new WrapperClass(obj,false));

           }
       }
        getrecords();
}*/
    
    
//******************************************************SortField Method********************************************************************************************
    public void doSortField() {
        updateSearchItemsMap();
        String sortQueryString='';
        sortQuery = '';
        sortQuery+= SelectedFieldOptions.get(0).getValue(); 
        for(Integer i =1 ; i<SelectedFieldOptions.size(); i++){ 
            sortQuery += ',' + SelectedFieldOptions.get(i).getValue(); 
            //System.debug('-->'+sortQuery);
        } 
        
        if (sortExp == 'ASC') {
            sortQuery = 'SELECT  ' + sortQuery + ' FROM ' + objectName + ' ORDER BY ' + sortFieldName + ' ' + sortExp;
            System.debug('sortQuery = '+sortQuery);
            sortExp = 'DESC';
            pageSize = ssc.getPageSize();
            //set the page Size
            getrecords();
            
        } else {
            sortExp = 'DESC';
            sortQuery = 'SELECT  ' + sortQuery + ' FROM ' + objectName + ' ORDER BY ' + sortFieldName + ' ' + sortExp;
            sortExp = 'ASC';
            System.debug('sortQuery = '+sortQuery);
            //ssc = new ApexPages.StandardSetController(Database.getQueryLocator(sortQuery));
            pageSize = ssc.getPageSize();
        }
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(sortQuery));
        ssc.setPageSize(pageSize);
        ssc.setPageNumber(pageNumber);
        myList.clear();
        for(sObject obj1 : ssc.getRecords()) {
            myList.add(new WrapperClass(obj1,false));
        }
    } 
    
    
//******************************************************Do Delete Functionality*****************************************************************************************
    public void doDelete(){
        try {
            
            Database.delete(retrieveId);
            Display();
            getrecords();
            ssc.setPageNumber(pageNumber);
            pageSize = ssc.getPageSize();
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Deletion Unsucessful'));
        }
    }
    
    
//******************************************************New Record*****************************************************************************************
    public pagereference newRecord(){
        getrecords();
        PageReference newRec = new PageReference(('https://briskmindssoftwaresoluti-3f-dev-ed.my.salesforce.com/'+recordId.subString(0, 3)+'/e'));
        return newRec;
    }
    
    
//******************************************************DeleteSelected(Method) Functionality*****************************************************************************************
    public void DeleteSelected(){
        try{
            DeleteSelected=new List<SObject>();
            updateSearchItemsMap();
            for (WrapperClass wrp: myList) {
                if (wrp.isCheck) {
                    //System.debug('-->'+wrp);
                    DeleteSelected.add(wrp.NestObj);
                    System.debug('-->'+DeleteSelected);
                } 
            }
            ssc.setPageSize(pageSize);
            pageset();
            
            Delete DeleteSelected;
            Display();
            /* myList.clear();
for(SObject  c : ssc.getRecords()){
myList.add(new WrapperClass(c,false));
}*/
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Delete Record successfully!'));
            getrecords();
            
        }catch(Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'record not delete'));
        }
    }
    
    
    //******************************************************downloadCSV Functionality*****************************************************************************************
    
    public void downloadCSV(){
        Map<id, WrapperClass> s = updateSearchItemsMap();
        // System.debug('--->'+s);
        CSVFile='';
        if(!s.isEmpty()){
            CSVFile+= SelectedFieldOptions.get(0).getValue(); 
            for(Integer i =1 ; i<SelectedFieldOptions.size(); i++){ 
                CSVFile += ',' + SelectedFieldOptions.get(i).getValue(); 
            } 
            CSVFile+='\\n'; 
            
            for(WrapperClass wrapObj : s.values()){ 
                // System.debug('-->'+wrapObj);
                if(wrapObj.isCheck){ 
                    //System.debug('-->'+wrapObj.isCheck);
                    Map<String,Object> fldmap = wrapObj.NestObj.getPopulatedFieldsAsMap();
                    Map<string,object> newMap = new  map<string,object> ();                                                                                     
                    for(string key : fldmap.keySet()){ 
                        newMap.put(key.toLowerCase(),fldmap.get(key)); 
                    }
                    fldmap = newmap;
                    //System.debug('-->'+fldmap);
                    
                    for(Integer i = 0; i< SelectedFieldOptions.size(); i++){ 
                        //System.debug('-->'+SelectedFieldOptions.get(i).getValue().toLowerCase());
                        
                        if(fldmap.containsKey(SelectedFieldOptions.get(i).getValue())){ 
                            CSVFile +=  fldmap.get(SelectedFieldOptions.get(i).getValue()) + ','; 
                            System.debug('-->'+ fldmap.get(SelectedFieldOptions.get(i).getValue()));
                        } 
                        else { 
                            CSVFile += 'null,'; 
                        } 
                    } 
                    CSVFile +='\\n';           
                } 
            }
            mapHoldingSelectedRecords.clear(); 
            // System.debug('----->'+ CSVFile);
        }else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Select Atlest One Record to download CSV... '));
        }
        
    }
    
    //******************************************************WrapperClass*****************************************************************************************
    public class WrapperClass
    {
        public SObject NestObj{get;set;}
        public Boolean isCheck{get;set;}
        public WrapperClass(SObject NestObj,Boolean isCheck)
        {
            this.NestObj=NestObj;
            this.isCheck = isCheck;
        }
    }
}