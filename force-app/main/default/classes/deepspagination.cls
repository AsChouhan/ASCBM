public class deepspagination {
    
    //MAP FOR OBJECT
    public Map<String, Schema.SObjectType> mapOfObject{get;set;}                            
    
    //STRING OBJECT STORES  SELECTED OBJECT NAME
    public String selectedSobject {get;set;} 
    //public String updatedSobejct {get;set;} 
    
    //SELECT OPTION LIST CONTAINS ALL OBJECTS
    public List<SelectOption> objectList{get;set;}
    
    //MAP FOR FIELDS
    public Map<String, Schema.SObjectField> mapOfField {get;set;}

    //SELECT OPTION LIST CONTAINS ALL FIELDS
    public List<SelectOption> allFieldsListOfObject{get;set;}
	
	public List<SelectOption> updatedRecords{get;set;}
    
    //SELECT OPTION LIST CONTAINS ONLY REQUIRED FIELDS
    public List<Selectoption> selectedFieldsListOfObject{get;set;}	
    
    //LIST OF STRING CONTAINS SELECTED FIELDS  
    public List<String> addFields{get;set;}
    
    //LIST OF STRING CONTAINS REMOVED FIELDS  
    public List<String> removeFields{get;set;}
    
    //BOOLEAN OBJECT USED TO RENERED THE SECOND PAGE BLOCK SECTION
    public boolean showFields{get;set;}
    
    //STRING OBJECT THAT STORES OBJECT NAME                                      
    public String objFldHeader{get;set;}
    
    //BOOLEAN OBJECT USED TO ENABLE AND DISABLE THE RESET BUTTON
    public Boolean disableReset{get;set;}
    
    //BOOLEAN OBJECT USED TO ENABLE AND DISABLE THE ADD BUTTON
    public Boolean disableAdd{get;set;}

    //BOOLEAN OBJECT USED TO ENABLE AND DISABLE THE REMOVE BUTTON
    public Boolean disableRemoveProcess{get;set;}
    
    //BOOLEAN OBJECT THAT RENERED CHILD COMPONENT
    public boolean  processRender{get;set;}
    public boolean renderChildComponent{get;set;}
    //CONSTRUCTOR OF CONTROLLER
    public deepspagination() {
       
        mapOfField=new Map<String,Schema.SObjectField>();
        objectList=new List<SelectOption>();
        allFieldsListOfObject=new List<SelectOption>();
        addFields=new List<String>();
        selectedFieldsListOfObject=new List<SelectOption>();
        removeFields=new List<String>();
        disableAdd = false;
        processRender = false;
        disableRemoveProcess = true;
        disableReset = true;
        updatedRecords = new List<SelectOption>();
        renderChildComponent=false;
       
        
        
        //Add object into select list
        objectList.add(new SelectOption('--None--','--None--'));
        String stdObjs = Label.Standard_Obj_Supported_By_SSC;
        mapOfObject=Schema.getGlobalDescribe();
        for(Schema.SObjectType sObjType:mapOfObject.values()) {
            Schema.DescribeSObjectResult objDetail = sObjType.getDescribe();
            if(stdObjs.contains(objDetail.getName()) ||  (objDetail.isAccessible()  && objDetail.isCustom() && objDetail.isUpdateable() && objDetail.isQueryable())){
                objectList.add(new selectoption(objDetail.getName(), objDetail.getLabel()));
            }
        }
        //If objectList is not empty then call sort method  by using it.
        if(!objectList.isEmpty()) {
            objectList.sort();
        }
    }
    /****************************************************************************************************************
     Reset method is used to take back page into its intial state. 
     ******************************************************************************************************************/
    public pageReference reset() {
        allFieldsListOfObject.clear();
        addFields.clear();
        selectedFieldsListOfObject.clear();
        removeFields.clear();
        PageReference pg = new PageReference('https://briskmindssoftwaresolutio41-dev-ed--c.vf.force.com/apex/PaginationProjectVFPage?core.apexpages.request.devconsole=1');
        showFields = false;
        selectedSobject = '--None--'; 
        disableAdd = false;
        disableRemoveProcess = true;
        disableReset = true;
        return pg;
    }
    /**********************************************************************************************
     This method is used to get the fields of the selected object.
     ********************************************************************************************************** */
    public void retrieveField() {
       try{
           allFieldsListOfObject.clear();
           selectedFieldsListOfObject.clear();
           addFields.clear();
           removeFields.clear();
           
        objFldHeader = selectedSobject.replace('__c', '').replace('_', ' ') + ' : Fields';
            if(!allFieldsListOfObject.isEmpty()) {
                allFieldsListOfObject = new List<SelectOption>();
            }
            if(!selectedFieldsListOfObject.isEmpty()) {
                selectedFieldsListOfObject = new List<SelectOption>();
            }
            mapOfField = mapOfObject.get(selectedSobject).getDescribe().fields.getMap();
            processRender=false;    
            for(Schema.SObjectField sObjField : mapOfField.values()) {
                Schema.DescribeFieldResult fieldsInfo = sObjField.getDescribe();
                if( fieldsInfo.isCreateable() && fieldsInfo.isUpdateable() && fieldsInfo.isSortable()){
                allFieldsListOfObject.add(new selectoption(fieldsInfo.getName(), fieldsInfo.getLabel()));
                }
                showFields=true;
            } 
            if(!allFieldsListOfObject.isEmpty()) {
                allFieldsListOfObject = new List<SelectOption> (sorting(allFieldsListOfObject));
                disableAdd = false;
                disableReset =  false;
            } else {
                disableAdd = true;
            } 
        }
        catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            showFields=false;
            processRender = false;
        }
    } 
    /*******************************************************************************************************************
     This method is used to add only selected fields into another list and removes from the first list.
    *******************************************************************************************************************/
    public void add(){
        processRender = false;
        
       for(String singleAddFld:addFields){
            selectedFieldsListOfObject.add(new SelectOption(singleAddFld,mapOfField.get(singleAddFld).getDescribe().getLabel()));
            allFieldsListOfObject.remove(allFieldsListOfObject.indexOf(new Selectoption(singleAddFld,mapOfField.get(singleAddFld).getDescribe().getLabel())));   
        }
        if(!selectedFieldsListOfObject.isEmpty()) {
            selectedFieldsListOfObject = new List<SelectOption>(sorting(selectedFieldsListOfObject));
            disableRemoveProcess = false;
        } else {
            disableRemoveProcess = true;
        }
        if(!allFieldsListOfObject.isEmpty()) {
            allFieldsListOfObject = new List<SelectOption>(sorting(allFieldsListOfObject));
            disableAdd = false;
        } else {
            disableAdd = true;
        }
        
        addFields.clear();
    }
     /*******************************************************************************************************************
     This method is used to removes only selected fields from the second list and adds back to the first list.
    *******************************************************************************************************************/
    public void remove(){
        for(String singleRemFld : removeFields){
            allFieldsListOfObject.add(new selectoption(singleRemFld,mapOfField.get(singleRemFld).getDescribe().getLabel()));
            selectedFieldsListOfObject.remove(selectedFieldsListOfObject.indexOf(new selectoption(singleRemFld,mapOfField.get(singleRemFld).getDescribe().getLabel())));
        }
        if(!selectedFieldsListOfObject.isEmpty()) {
            selectedFieldsListOfObject = new List<SelectOption>(sorting(selectedFieldsListOfObject));
            disableRemoveProcess = false;
        } else {
            disableRemoveProcess = true;
        }
        if(!allFieldsListOfObject.isEmpty()) {
            allFieldsListOfObject = new List<SelectOption>(sorting(allFieldsListOfObject));
            disableAdd = false;
        } else {
            disableAdd = true;
        }
    }
     /*******************************************************************************************************************
     This method is used to sort the fields by its LabelName.
    *******************************************************************************************************************/
    public List<SelectOption> sorting(List<SelectOption> listUnsorted) {
        for(Integer i = 0; i < listUnsorted.size(); i++) {
            for(Integer j = i+1; j < listUnsorted.size(); j++) {
                if(listUnsorted[i].getLabel() > listUnsorted[j].getLabel()) {
                    SelectOption temp = listUnsorted[i] ;
                    listUnsorted[i] =listUnsorted[j];
                    listUnsorted[j] = temp;
                }
            } 
        }
        return listUnsorted;
    }
     public void processB(){        
     }
}