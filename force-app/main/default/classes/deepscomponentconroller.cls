public class deepscomponentconroller {
    public String objectName{ get; set; }
    public List<SelectOption> fieldsSelectOptionList{ get; set; }
    /************************FOR SETUP QUERY***********************************/
    public String query = '';  
    public String filterQuery{get;set;}
    public List<String> fieldsName{ get; set; }
    /*******************FOR WRAPPER CLASS ********************************/
    public List<WrapperClass> allRecords{ get; set; }
    public ApexPages.StandardSetController ssc{ get; set; }
    public Boolean hideComponent{ get; set; } 
    /*************SELECT LIST FOR PAGE SIZE**********************************************************/
    public List<SelectOption> recordSizePerPage{ get; set; }
    public Integer recordSize{ get; set; }     //selected page size
    public Integer recordsOnPage{ get; set; }
    
    public Set<ID> selectedRecordIDs{ get; set; }
    public integer pageNumber{ get; set; }
    public String csv{ get; set; }            
    /********************** FOR EDIT LINK ****************************************************** */
    public String objID{ get; set; } 
    public String editRecordId{ get; set; }
    //***********FOR COLUMNWISE SORTING********************************************************** */
    public String sortQuery{get;set;}
    public String allFields{ get; set; }             //All fields Name
    public String sortingOrder{ get; set; }          // Specify order Asc /dsc
    public String sortingFieldName{ get; set; }     // SORT ACC. TO THIS FIELD
    /***********************************ALPHABET LIST oF STRING AND FILTERS***********************************/
    public List<string> alphabet{ get; set; }
    public String selectedAlphabet{ get; set; }
    /****************************************Buttons************************************************************* */
    public boolean disableCsvButton{get; set;}
    public boolean disableDeleteSelButton{get; set;}
    public List<SObject> records{get;set;}
    public Boolean componenthide{get;set;}

/*----------------------------CONSTRUCTOR------------------------------------------------*/
public deepscomponentconroller(){

    records=new List<SObject>();
    System.debug('fieldsName: ' + fieldsSelectOptionList);
    alphabet = new string[]{ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All' };
    sortingOrder = 'ASC';
    pageNumber = 1;
    sortingFieldName = 'name';
    hideComponent = false;
    csv = '';
    disableDeleteSelButton= false;
    disableCsvButton = false;
    componenthide=false;
}
/********************************************************************************
 This process() is used to create  query for the records of the object.
 *******************************************************************************/    
public void process(){
     	
    //Intialization
    System.debug('fieldsName: ' + fieldsSelectOptionList);
    System.debug('objectName: ' + objectName);
    componenthide=true;
    query = '';
    allRecords = new List<WrapperClass>();
    fieldsName = new List<String>();
    selectedRecordIDs = new Set<ID>();
    recordSize = 5;
    
    recordsOnPage = 5;
    //Insert elements into SelectList.
    recordSizePerPage = new List<SelectOption>();
    recordSizePerPage.add(new SelectOption('5', '5'));
    recordSizePerPage.add(new SelectOption('10', '10'));
    recordSizePerPage.add(new SelectOption('15', '15'));
    recordSizePerPage.add(new SelectOption('20', '20'));
    //records Default Query
    query += 'Select ';
    query += fieldsSelectOptionList.get(0).getValue();
    fieldsName.add(fieldsSelectOptionList.get(0).getValue());
    for (Integer i = 1; i < fieldsSelectOptionList.size(); i++){
        query += ',' + fieldsSelectOptionList.get(i).getValue();
        fieldsName.add(fieldsSelectOptionList.get(i).getValue());
    }
    query += ' FROM ' + objectName;
    
    ssc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
    ssc.setpageSize(recordSize);
    //Whenever records created then component will show.
    hideComponent = true;
    //If records are present into allRecordsList then clear it.
    if (!allRecords.isEmpty()){
        allRecords.clear();
    }
    //RECORDS ADD TO WRAPPER LIST
    System.debug(ssc.getRecords());
    for (sObject obj : ssc.getRecords()){
        objID = obj.Id;
        allRecords.add(new WrapperClass(obj, false));
    }
}
/*********************************************************
 This method is used to open a new record page.
 obj.ID contains id of the given object.
 **********************************************************/
public pageReference newRecord(){
    PageReference pg = new PageReference(('/' + objID.subString(0, 3) + '/e'));
    return pg;
}
/************************************************************************************
This method is used to delete only selected records from the list.
****************************************************************/
public void delSelected(){
    fetchSelectedRecordsId();
    List<Id> selListId = new list<Id>(selectedRecordIDs);
    if(selListId.size()>0){
        disableDeleteSelButton= true;
    }
    try{
        System.debug('selListId : '+selListId);
        Database.DeleteResult[] drList = Database.delete (selListId, false);
        if(!drList[0].isSuccess()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, drList[0].getErrors()[0].getMessage()));
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Delete Record Successfully.'));
        }
        System.debug('drList : '+drList);
        allRecords.clear();
        process();
        
    }
    catch (Exception e){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
    }
}


   
 /************************************************************************************************************** **/  
public void fetchSelectedRecordsId(){
    for (WrapperClass lst : allRecords){
        if (lst.recordCheckBox){
            selectedRecordIDs.add(lst.recordsOfObject.Id);
        } else{
            selectedRecordIDs.remove(lst.recordsOfObject.Id);
        }
    }   

}

 /***************************CSV DOWNLOAD************************************************************************/

    public void CSVDownload(){
        csv = '';
        List<sObject> selectedRecordList = new List<sObject>();
        for (WrapperClass wc : allRecords){
            if (wc.recordCheckBox == true){
                selectedRecordList.add(wc.recordsOfObject);
            }
        }
        if(selectedRecordList.size()>0){
            disableCsvButton = true;
        }
        for (SelectOption sOpt : fieldsSelectOptionList){
            csv += sOpt.getLabel() + ',';
        }
        csv = csv.removeEnd(',');
        csv += '\\n';
        for (sObject sObj : selectedRecordList){
            for (SelectOption sOpt : fieldsSelectOptionList){
                if(sObj.get(sOpt.getValue()) == null) {
                    csv += ' ,';
                } else {
                    csv += sObj.get(sOpt.getValue()) + ',';
                }
                
            }
            csv = csv.removeEnd(',');
            csv += '\\n';
        }
   
    }

/*******************************************************************************************************************/


/**************************** FOR EDIT & DELETE**************************************************************************************/
    // FOR EDIT
    public pageReference editRecord(){
        PageReference pg = new PageReference(('/' + editRecordId + '/e'));
        return pg;
    }

    //For Delete
    public void del(){
        try{
            List<SObject> records = new List<SObject>();
            String delrecord = ApexPages.currentPage().getParameters().get('deleterecord');
            String query = 'Select Id FROM ' + objectName + ' Where Id = ' + '\'' + delRecord + '\'';
            System.debug(query);
            records = Database.query(query);
            delete records;
            process();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Delete Record Successfully.'));
        } catch (Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));

        }
    }
/*****************************************************************************************************************************/
 
/****************************Create filterQuery*************************************************************************/
    public void filterRecords(){

        filterQuery = query;

        if (selectedAlphabet == 'All'){
            filterQuery = query;
        } 
        else if (selectedAlphabet == 'Other'){
           filterquery = filterquery + ' where not(Name like \'A%\'';
            System.debug(filterQuery);
            for (Integer i = 1; i < alphabet.size() - 2; i++){
                filterquery = filterquery + ' or name like \'' + alphabet[i] + '%\'';
            }
            filterquery = filterQuery + ')';

            System.debug(filterQuery);
        } 
        else{

            filterQuery = filterQuery + ' WHERE Name Like \'' + selectedAlphabet + '%\'';
        }

        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(filterQuery));
        ssc.setPageSize(recordSize);
        allRecords.clear();
        // System.debug(ssc.getRecords());
        if (ssc.getResultSize() > 0){

            for (sObject obj : ssc.getRecords()){
                allRecords.add(new WrapperClass(obj, false));
            }
            hideComponent = true;
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'There is no such  records.'));
            hideComponent = false;
        }
    }

/*************************************************************************************************************************/
 // COLUMNWISE SORTING
/************************************************************************************************************************ */
    public void columnSorting(){
        fetchSelectedRecordsId();
        sortQuery = '';
        allFields = String.join(fieldsName, ',');


        if (sortingOrder == 'ASC'){
            sortingOrder = 'DESC';


        } else{
            sortingOrder = 'ASC';

        }
        System.debug('sortingFieldName******' + sortingFieldName);
        sortQuery = 'SELECT  ' + allFields + ' FROM ' + objectname + ' ORDER BY ' + sortingFieldName + ' ' + sortingOrder;
        System.debug('sortQuery******' + sortQuery);
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(sortQuery));
        System.debug('recordSize : ' + recordSize);
        ssc.setPageSize(recordSize);
        clearRec();
    }

/*************************************************************************************************************************/
 // PAGESIZE METHOD
/************************************************************************************************************************ */
    public void pageSize(){
        fetchSelectedRecordsId();
        ssc.setPageSize(recordSize);
        clearRec();
    }

/*************************************************************************************************************************/
 // PAGE NUMBER METHOD
/************************************************************************************************************************ */
    public void showpageNumber(){
        clearRec();
        System.debug('enter');
        ssc.setpageNumber(pageNumber);
        //System.debug(pageNumber);
        
    }
/*************************************************************************************************************************/
 //  METHOD FOR NEXT BUTTON
/************************************************************************************************************************ */

    public void next(){

        System.debug('hey next');
        fetchSelectedRecordsId();
        ssc.next();
        pageNumber = pageNumber + 1;
       
        clearRec();
    }
/*************************************************************************************************************************/
 // METHOD FOR PREVIOUS BUTTON
/************************************************************************************************************************ */

    public void previous(){
        fetchSelectedRecordsId();
        ssc.previous();
        
        pageNumber = pageNumber - 1;
        clearRec();
    }

/*************************************************************************************************************************
  METHOD FOR FIRST BUTTON
************************************************************************************************************************ */

    public void first(){

        fetchSelectedRecordsId();
        ssc.first();
        pageNumber = 1;

        
        clearRec();
    }
/*************************************************************************************************************************/
 // METHOD FOR LAST BUTTON
/************************************************************************************************************************ */

    public void last(){

        fetchSelectedRecordsId();
        ssc.last();
        pageNumber =  (ssc.getResultSize() / ssc.getPageSize()) + 1;
        
        clearRec();
    }

    public void clearRec() {
        allRecords.clear();
        for (SObject obj : ssc.getRecords()){
            if (selectedRecordIDs.contains(obj.id)){
                allRecords.add(new WrapperClass(obj, true));
            } else{
                allRecords.add(new WrapperClass(obj, false));
            }
        }
    }



/******************************************************************************************************************** */
    //Create Wrapper class 
/********************************************************************************************************************************/

public class WrapperClass{
        public SObject recordsOfObject{ get; set; }

        public Boolean recordCheckBox{ get; set; }

        public WrapperClass(SObject recordsOfObject, Boolean isCheck){
            this.recordCheckBox = isCheck;
            this.recordsOfObject = recordsOfObject;
        }

    }

}