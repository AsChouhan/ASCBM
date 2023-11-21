public with sharing class BMT_PaginationComponentClass {
   public String                           objname                       {get;set;}	
    public List<String>                     fieldsname                    {get;set;}
    public List<WrapperClassObject>         wrapperObjRecList             {get;set;}  
    public ApexPages.StandardSetController  setCon                        {get;set;} 
    public Integer                          pgSize                        {get;set;}
    public String                           query                         {get;set;}  
    public String                           allFields                     {get;set;}
    public Integer                          temp;
    //-------------------------------------------------------------------------------------------
    public Map<id, WrapperClassObject>      mapHoldingSelectedRecords     {get;set;}
    public String                           recordId;
    //-------------------------------------------------------------------------------------------
    public id                               retrieveId                    {get;set;}
    public Boolean                          editRecordList                {get;set;}
    public Sobject                          tempObjectList                {get;set;}
    //-------------------------------------------------------------------------------------------
    public String                           sortExp                       {get;set;}
    public String                           sortFieldName                 {get;set;} 
    //-------------------------------------------------------------------------------------------
    public List<String>                     allAlphabet                   {get;set;}
    public String                           alphaSearchConct              {get;set;}
    //-------------------------------------------------------------------------------------------
    public String                           CSVFile                       {get;set;}
    //-------------------------------------------------------------------------------------------
    public List<String>                     oldFields                     {get;set;}     
    public object                           oldobj;       
    //-------------------------------------------------------------------------------------------
    public Boolean                          headerCheck                   {get;set;}
    public Integer                          count                         {get;set;}
    //-------------------------------------------------------------------------------------------
    public Boolean                          paginationCheck               {get;set;}
    //-------------------------------------------------------------------------------------------
	public list<id> 						lstofDeletedRec;    
    
    public BMT_PaginationComponentClass() {
        mapHoldingSelectedRecords = new Map<id, WrapperClassObject>();
        oldFields = new List<String>();
        temp=0;
        paginationCheck = true;
        allAlphabet=new List<String>{'A ','B ','C ','D ','E ','F ','G ','H ','I ','J ','K ','L ','M ','N ','O ','P ','Q ','R ','S ','T ','U ','V ','W ','X ','Y ','Z ','Other ','All'};
            editRecordList = false;
    }
    
    public void firstTimeQueryMaker() {
        oldobj = objname;
        oldFields = fieldsname.clone();
        //System.debug('fieldsname = '+fieldsname);
        allFields = String.join(fieldsname, ',');
        //System.debug('allFields = '+allFields);
        query = 'SELECT ' + allFields + ' FROM ' + objname;
        //query = 'SELECT  ' + allFields + ' FROM ' + objname;
        //System.debug(query);
        
        //if setCon is empty then it will fire query otherwise it will return setCon with previous value
        pgSize = 5;
        //System.debug(query);
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        setCon.setPageSize(pgSize);
        //setCon.getRecords(); ////get the records
        // sets the number of records to show in each page view
        
        //System.debug('setCon.getRecords() = '+setCon.getRecords());										
        
    }
    
    
    //---------------This is the method which manages to remove the deselected records, and keep the records which are selected in map.------
    public void updateSearchItemsMap() {
        for (WrapperClassObject wrp: wrapperObjRecList) {
            if (wrp.isCheck) {
                mapHoldingSelectedRecords.put(wrp.objectRecords.id, wrp);
            }
            if (wrp.isCheck == false && mapHoldingSelectedRecords.containsKey(wrp.objectRecords.id)) {
                mapHoldingSelectedRecords.remove(wrp.objectRecords.id);
            }
        }
    }
    
    //-------------------------------------------------- getRecords Function call --------------------------------------------------
    public List < WrapperClassObject > getrecords() {
        if (temp != 0 && oldFields.size() != fieldsname.size() || oldobj != objname) {
            sortExp = 'ASC';
            firstTimeQueryMaker();
        }
        temp++;
        count = 0;
        wrapperObjRecList = new List < WrapperClassObject > ();
        wrapperObjRecList.clear();
        for (Sobject cont: (List < Sobject > ) setCon.getRecords()) {
            recordId = cont.id;
            if (mapHoldingSelectedRecords != null && mapHoldingSelectedRecords.containsKey(cont.id)) {
                wrapperObjRecList.add(mapHoldingSelectedRecords.get(cont.id));
                count++;
                System.debug(count);
            } else {
                wrapperObjRecList.add(new WrapperClassObject(cont, false));
            }
        }
        System.debug('wrapperObjRecList = ' + wrapperObjRecList);
        if(count == wrapperObjRecList.size() || count == setCon.getResultSize()){
            headerCheck = true;
        }else{
            headerCheck = false;
        }
        
        if(setCon.getRecords().isEmpty()){
            paginationCheck = false;
            headerCheck = false;
        }else{
            paginationCheck = true;
        }
        return wrapperObjRecList;
    }
    
    
    //---------------------------------- Edit , Delete and Save Functionality --------------------------------------------------------
    public void doEdit(){
        editRecordList = true;
        allFields = String.join(fieldsname,',');
        String queryRes = 'SELECT  ' + allFields + ' FROM ' + objname + ' WHERE id =:retrieveId';
        System.debug(queryRes);
        tempObjectList = Database.query(queryRes);
        System.debug(tempObjectList);
    }
    
    
    public void doDelete() {
        //System.debug('pgSize = ' + pgSize);
        //System.debug('pgNum = '+pgNum);
        Integer tempPgNum = pgNum;
        //System.debug('TempPgNum = '+tempPgNum);
        //System.debug('tempDeleteId = ' + retrieveId);
        try {
            Database.delete(retrieveId);
            firstTimeQueryMaker();
            getrecords();
            // System.debug('pgNum = '+ pgNum);
            setCon.setPageNumber(tempPgNum);
            //System.debug('After pgNum = '+ pgNum);
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Deletion Unsucessful'));
        }
    }
    
    public void doSave(){
        //System.debug('pgNum = '+pgNum);
        Integer tempPgNum = pgNum;
        //System.debug('TempPgNum = '+tempPgNum);
        update tempObjectList;
        setCon.setPageSize(pgSize);
        firstTimeQueryMaker();
        getrecords();   
        setCon.setPageNumber(tempPgNum);
        editRecordList = false;
    }
    
    //----------------------------------Pagination Functionality -----------------------------------------
    public void firstPage() {
        updateSearchItemsMap();
        setCon.first(); //Returns the First page of records.
        getrecords();
        
    }
    
    
    public void prevPage() {
        updateSearchItemsMap();
        setCon.previous(); //Returns the previous page of records.  
        getrecords();
    }
    
    public void nextPage() {
        updateSearchItemsMap();
        setCon.next(); //Returns the next page of records.
        //System.debug(' next Result = '+setCon.next());
        getrecords();
    }
    
    
    public void lastPage() {
        updateSearchItemsMap();
        setCon.last(); //Returns the last page of records.
        //pgSize = setCon.getResultSize() - (pgSize*(this.totalPages-1)) ;
        //System.assert(false,pgSize);
        getrecords();
        
        
    }
    
    public void changePageSize() {
        setCon.setPageSize(pgSize); //set the page Size
        getrecords();
        
        
    }
    
    public void changePageNumber() {
        setCon.setPageNumber(pgNum);
        setCon.setPageSize(pgSize);     //set the page Size
        pgNum = setCon.getPageNumber(); //get the page Number
        getrecords();
    }
    
    public Integer pgNum {
        get { //To get current page number
            this.pgNum = setCon.getPageNumber();
            return this.pgNum;
        }
        set { // To navigate to the page number entered by the user
            setCon.setPageNumber(value);
        }
    }
    
   /* public Integer totalPages { // Total number of pages as per user selection of Records per page
        get {
            if (setCon.getResultSize() <= 5)
                this.totalPages = 1;
            if (Math.Mod(setCon.getResultSize(), setCon.getPageSize()) == 0)
                this.totalPages = (setCon.getResultSize() / setCon.getPageSize());
            else
                this.totalPages = (setCon.getResultSize() / setCon.getPageSize()) + 1;
            //System.Debug(this.totalPages);
            return totalpages;
        }
        set;
    }*/
    
    public Integer totalPages{ // Total number of pages as per user selection of Records per page
        get{
            totalPages=setCon.getResultSize()/setCon.getPageSize();
            if(Math.mod(setCon.getResultSize(), pgSize) !=0 ){
                totalPages++;
            }
            return totalPages;
        }
        set;
    }
    
    
    
    
    
    //------------------------------- Sorting Code ----------------------------------------------------------------------
    
    public void doSortField() {
        updateSearchItemsMap();
        //System.debug('pageSize = '+pgSize);
        //sortFieldName = System.currentPagereference().getParameters().get('sortField');
        allFields = String.join(fieldsname, ',');
        //System.debug('sortFieldName = '+sortFieldName);
        String sortQuery = '';
        if (sortExp == 'ASC') {
            sortExp = 'DESC';
            sortQuery = 'SELECT  ' + allFields + ' FROM ' + objname + ' ORDER BY ' + sortFieldName + ' ' + sortExp;
            //System.debug('sortQuery = '+sortQuery);
            pgSize = setCon.getPageSize();
            //set the page Size
            //System.debug(' After pageSize = '+pgSize);
            //getrecords();
        } else {
            sortExp = 'ASC';
            sortQuery = 'SELECT  ' + allFields + ' FROM ' + objname + ' ORDER BY ' + sortFieldName + ' ' + sortExp;
            //System.debug('sortQuery = '+sortQuery);
            //setCon = new ApexPages.StandardSetController(Database.getQueryLocator(sortQuery));
            pgSize = setCon.getPageSize();
        }
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(sortQuery));
        setCon.setPageSize(pgSize); 
    }
    
    //--------------------------------------- New Record, Delete Selected, Download CSV --------------------------------------------- 
    
    public pagereference doNewRecordPopUp() {
        //System.debug(objectid);
        PageReference newRec = new PageReference(('https://rahulchamp-dev-ed.my.salesforce.com/' + recordId.subString(0, 3) + '/e'));
        return newRec;
    }
    
    
    
    public pagereference doDeleteSelectedRecord() {
        Integer tempPgNum = pgNum;
        pgSize = setCon.getPageSize();
        //setCon = null;
        lstofDeletedRec = new List<id>();
        updateSearchItemsMap();
        System.debug('map holding all keys = '+mapHoldingSelectedRecords.keySet());
        for(Id delRecId: mapHoldingSelectedRecords.keySet()){
            lstofDeletedRec.add(delRecId);
        }
        System.debug(lstofDeletedRec);
        if(lstofDeletedRec.size() > 0){
            try {
                if(lstofDeletedRec.size() > 0){
                    Database.delete(lstofDeletedRec);
                    firstTimeQueryMaker();
                    getrecords();
                    setCon.setPageNumber(tempPgNum);
                    setCon.setPageSize(pgSize);
                }
            } catch (Exception ex) {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, ex.getMessage()));
            }
            mapHoldingSelectedRecords.clear();
        }else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Select Atlest One Record to delete... '));
        }
        
        return null;
    }
    
    public void downloadCSV() {
        updateSearchItemsMap();
        CSVFile='';
        if(!mapHoldingSelectedRecords.isEmpty()){
            List<string> recordscomaseprated=new List<string>();
            allFields = String.join(fieldsname, ',');
            recordscomaseprated.add(allFields);
            //System.debug('recordscomaseprated = '+recordscomaseprated);
            for(WrapperClassObject i : mapHoldingSelectedRecords.values()){
                String rowstr='';
                if(i.isCheck == true ){
                    //System.debug('Inside the first loop>>>');
                    for(String fname: fieldsname){
                        if(fieldsname.indexOf(fname) == 0){ 
                            //System.debug('fieldsname.indexOf(fname) ='+fieldsname.indexOf(fname));
                            rowstr = rowstr + i.objectRecords.get(fname);
                            //System.debug('rowstr = '+rowstr);
                        }
                        else {
                            rowstr =rowstr +','+ i.objectRecords.get(fname);  
                        }
                    }
                    recordscomaseprated.add(rowstr); 
                    System.debug('recordscomaseprated>>>>='+recordscomaseprated);
                }
                //System.debug('After complet loop >>>');
                CSVFile=String.join(recordscomaseprated,'\\n');
                mapHoldingSelectedRecords.clear();
                System.debug('CSVFile>>>>>'+CSVFile);  
            }
        }else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Select Atlest One Record to download CSV... '));
        }
        /* for(String rec:recordscomaseprated){
            System.debug('rec=>>'+rec);
            CSVFile += rec;
            CSVFile +='\n';
            System.debug('CSVFile=>>'+CSVFile);
        }*/
        
        
    }
    
    //---------------------------------- Alphabates Sorting Functionality -----------------------------------------------------------
    
    public Pagereference charRecShow() {
        updateSearchItemsMap();
        //System.debug('Page Size = '+pgSize);
        //System.debug(alphaSearchConct);
        allFields = String.join(fieldsname, ',');
        String firstField = fieldsname.get(0);
        //System.debug(firstField);
        alphaSearchConct = alphaSearchConct.remove(' ');
        String qryResult = '';
        try {
            if (alphaSearchConct == 'All') {
                qryResult = 'SELECT Id, ' + allFields + ' FROM ' + objname;
                //System.debug('charRecShow = '+qryResult);
                //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator(qryResult));
                //setCon = ssc;
                //setCon.setPageSize(pgSize); //set the page Size
                //getrecords();
               
            } else if (alphaSearchConct == 'Other') {
                qryResult = 'SELECT Id, ' + allFields + ' FROM ' + objname + ' WHERE ' + '(' + firstField + ' < \'A\' OR ' + firstField + ' > \'Z\')';
                //System.debug('charRecShow = '+qryResult);
                //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator(qryResult));
                //System.debug('charRecShow = '+qryResult);
                //setCon = ssc;
                //setCon.setPageSize(pgSize); //set the page Size
                //getrecords();
                
               //setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qryResult));
                
            } else {
                qryResult = 'SELECT Id, ' + allFields + ' FROM ' + objname + ' WHERE ' + firstField + ' LIKE \'' + alphaSearchConct + '%\'';
                //System.debug('charRecShow = '+qryResult);
                //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator(qryResult));
                //System.debug('charRecShow = '+qryResult);
                //setCon = ssc;
                //setCon.setPageSize(pgSize); //set the page Size
                //getrecords();
                //setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qryResult));
            }
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qryResult));
            setCon.setPageSize(pgSize);
            //getrecords();
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Filtering is not available for this field.'));
        }
        return null;
    }
    
    
    //------------------------------------------------------------ Wrapper Class -----------------------------------------------------
    public class WrapperClassObject {
        public Sobject objectRecords {
            get;
            set;
        }
        public Boolean isCheck {
            get;
            set;
        }
        
        public WrapperClassObject(Sobject objectRecords, Boolean isCheck) {
            this.objectRecords = objectRecords;
            this.isCheck = isCheck;
            //System.debug('objectRecords = ' + objectRecords);
            //System.debug('isCheck = ' + isCheck);
        }
    }
}