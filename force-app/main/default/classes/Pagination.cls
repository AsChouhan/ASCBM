public class  Pagination {
    
    public map<String ,Schema.SObjectType>     AllObject      			{get;set;} // get all objects in options
    public List<SelectOption>                  objectList     			{get;set;} // get all objects in options List
    Map<String, Schema.SObjectField>           AllField      			{get;set;} // get all fields
    public List<String>                        selectedFields 			{get;set;} 	//it have all selected fields
    public List<SelectOption>                  FieldList      			{get;set;} //get fields in selected objects
    public String                              secObject      			{get;set;} // Hold Selected Object Name
    public List<SelectOption>                  addFields      			{get;set;} //it have all selected fields
    public List<String>                        showselectedfield  		{get;set;} //show field list
    public Boolean 							   piclistblock				{get;set;} //show/hide field panel  
    public boolean 							   disableAddButton     	{get;set;} //enable and disable add Button
    public boolean                             disableRemoveButton  	{get;set;} //enable and disable Remove Button
    public boolean                             renderChildComponent 	{get;set;} //show/hide pagination panel

    
//************************************************************Constructor***********************************************************************************************************    
    public Pagination(){
        
        AllField = new  Map<String, Schema.SObjectField>();
        AllObject = Schema.getGlobalDescribe();
        objectList = new List<SelectOption>();
        objectList.add(new SelectOption('',' --none-- '));   //By Default add None 
        selectedFields = new List<String>();
        FieldList = new List<SelectOption>();
        addFields = new List<SelectOption>();        
        showselectedfield= new List<String>(); 
        piclistblock = false;
        disableRemoveButton=true;
        disableAddButton =false;
        renderChildComponent =false;
     
//********************************************************Fetch all Object*****************************************************************************************//
        for(Schema.SObjectType obj: Schema.getGlobalDescribe().values()){
            Schema.DescribeSObjectResult objResult = obj.getDescribe();
            if (objResult.isQueryable() && objResult.isDeletable() && objResult.isAccessible()
                && objResult.isCreateable() && objResult.isUpdateable() && objResult.isSearchable()){
                    SelectOption op1 = new SelectOption(objResult.getName(), objResult.getLabel()); //object Name as a Key and label as a value
                    objectList.add(op1); // add into options 
                }
            objectList.sort();  
        }
        
    }  
    
//********************************************************Reset Button ***********************************************************************************************//

    public void reset() {
        objectList.get(0).setdisabled(false);
        selectedFields.clear();
        showselectedfield.clear();
        FieldList.clear();
        addFields.clear();
        piclistblock = false;
        secObject='';
        renderChildComponent = false;
        
    }
//******************************************************displayFields Fetch all Fields**********************************************************************************//

    public void displayFields(){
        selectedFields.clear();
        addFields.clear();
        FieldList.clear();
        showselectedfield.clear();
        piclistblock = true;
        objectList.get(0).setdisabled(true);
        AllField=AllObject.get(secObject).getdescribe().fields.getmap();
        for(String st : AllField.keyset()){
            if(AllField.get(st).getDescribe().isUpdateable() && AllField.get(st).getDescribe().isSortable()){
                FieldList.add(new SelectOption(st, AllField.get(st).getDescribe().getLabel())); 
            }
        }
        
        FieldList.sort(); 
        renderChildComponent = false;
    }
//*******************************************************Add Button*******************************************************************************************************//
    public void addButton(){ 
        renderChildComponent = false;
        
        for(String s: selectedFields){
            if(addFields.size() < 10){
                addFields.add(new SelectOption(s,AllField.get(s).getDescribe().getLabel()));
            }
            FieldList.remove(FieldList.indexOf(new SelectOption(s,AllField.get(s).getDescribe().getLabel())));    
        }
        
        addFields.sort();
        FieldList.sort();
        if(addFields.size() <= 0){
            disableRemoveButton = true;
        }
        else{
            disableRemoveButton = false;
        }
    }
//****************************************************** Remove Button **********************************************************************************************//
    
    public void removeButton(){
        renderChildComponent = false;
        for(String st: showselectedfield){
            addFields.remove(addFields.indexOf(new SelectOption(st,AllField.get(st).getDescribe().getLabel())));
            FieldList.add(new SelectOption(st,AllField.get(st).getDescribe().getLabel()));            
        }
        addFields.sort();
        FieldList.sort();        
        if(addFields.size() <= 0){
            disableRemoveButton = true;
        }
        else{
            disableRemoveButton = false;
        }
        if(FieldList.size() <= 0){
            disableAddButton = true;
        }
        else{
            disableAddButton = false;
        }
    }
    
//******************************************************Process Button *****************************************************************************************************************//

    public void processButton(){
        if(addFields.size() > 0){
            renderChildComponent = true;
        }
        else{
            renderChildComponent = false;
        }
    } 
}