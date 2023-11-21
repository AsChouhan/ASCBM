public with sharing class BMT_getAllSobjectDataAndFields {
 public List<SelectOption>               allObjects              {get;set;} // get all objects in options
    public List<SelectOption>               allFields               {get;set;} // get all fields in options
    public Map<String, Schema.SObjectField> mapOfField              {get;set;} //all the field names (keys) and the field tokens (values) for an sObject 
    public String                           selectedObject          {get;set;} // Hold Selected Object Name
    public Boolean                          fieldPanel              {get;set;} // use for show/hide field panel
   
    public List<SelectOption>               nonSelectedPicklist     {get;set;} //Option get all not selected fields
    public List<SelectOption>               SelectedPicklist        {get;set;} //Option get all selected fields
    
        public set<String>                      nonSelectedFields       {get;set;} //it have all unselected fields
    public set<String>                      SelectedFields          {get;set;} //it have all selected fields
    
    public List<String>                     addElement              {get;set;} //For add the fields
    public List<String>                     removeElement           {get;set;} //For remove the fields


    public String                           objectName               {get;set;} //get object Name
    public List<String>                     fields                   {get;set;} // get all the selected fields 
    public Boolean                          disbaledProcessButton    {get;set;} //Used to Disabled/Enabled Process button
    public Boolean                          paginationPanel          {get;set;} // show/hide pagination panel
    
    public BMT_getAllSobjectDataAndFields() {

        paginationPanel = false;
        disbaledProcessButton = true;
        fieldPanel = false;
        allObjects = new List < SelectOption > (); // Declaration
        allFields = new List < SelectOption > (); // Declaration

        nonSelectedPicklist = new List < SelectOption > ();
        SelectedPicklist = new List < SelectOption > ();

        nonSelectedFields = new set < String > ();
        SelectedFields = new set < String > ();


        addElement = new List < String > ();
        removeElement = new List < String > ();

        allObjects.add(new SelectOption('A', '--None--')); //By Default add None 

        //--------------------------------------------------Fetch all Object----------------------------------------------------------

        for (Schema.SObjectType obj: Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult objResult = obj.getDescribe(); //get the description of given object
            if (objResult.isQueryable() && objResult.isaccessible() && objResult.isDeletable() && objResult.isCreateable() && objResult.isUpdateable() && objResult.isSearchable() && objResult.getName() != 'Document' && objResult.getName() != 'Attachment' && objResult.getName() != 'CaseComment' && objResult.getName() != 'EmailTemplate' && objResult.getName() != 'Event' && objResult.getName() != 'FeedComment' && objResult.getName() != 'FeedItem' &&
                objResult.getName() != 'Group' && objResult.getName() != 'IdeaComment' && objResult.getName() != 'Note' && objResult.getName() != 'PermissionSet' && objResult.getName() != 'Pricebook2' && objResult.getName() != 'UserEmailPreferredPerson' && objResult.getName() != 'UserRole') //Check object is queryable or not
            {
                //System.debug( 'Sobject: ' + objResult );
                //System.debug( 'Sobject API Name: ' + objResult.getName() );
                //System.debug( 'Sobject Label Name: ' + objResult.getLabel() );  
                SelectOption op1 = new SelectOption(objResult.getName(), objResult.getLabel()); //object Name as a Key and label as a value
                allObjects.add(op1); // add into options

            }
        }
        if (allObjects.size() > 0 && !allObjects.isEmpty() && allObjects != null) {
            allObjects.sort(); //Sort the list of all objects 
        }
    }

    //--------------------------------------------------Fetch all Fields----------------------------------------------------------
    public void fetchFields() {

        if (selectedObject != 'A') {
            System.debug('selectedObject = ' + selectedObject);
            Map < String, String > fieldNameMap = new Map < String, String > ();
            fieldPanel = true;
            paginationPanel = false;
            nonSelectedFields.clear(); //Whenever this function call, this will clear the list
            SelectedFields.clear(); //Whenever this function call, this will clear the list
            mapOfField = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            for (String key: mapOfField.keySet()) {
                Schema.DescribeFieldResult fieldResult = mapOfField.get(key).getDescribe();
                if (mapOfField.get(key).getDescribe().isCreateable() && mapOfField.get(key).getDescribe().isAccessible() && mapOfField.get(key).getDescribe().isSortable()) {
                    fieldNameMap.put(key, mapOfField.get(key).getDescribe().getLabel());
                }
            }
            System.debug('mapOfField = ' + mapOfField);
            nonSelectedFields.addAll(fieldNameMap.keySet());
            System.debug('nonSelectedFields = ' + nonSelectedFields);
            displayField();
        } else {
            System.debug('Selected object = '+selectedObject);
            nonSelectedFields.clear(); //If user select None, then it will clear the List
            SelectedFields.clear();
            fieldPanel = false; // hide field block
            paginationPanel = false;
        }
    }



    //-------------------------------------------------- Reset Button ----------------------------------------------------------
    public void doReset() {
        nonSelectedFields.clear();
        SelectedFields.clear(); //clear the all the fields
        fieldPanel = false; // hide field block
        selectedObject = 'A';
        paginationPanel = false;
    }

    //------------------------------ display field function to fill value in left and right field panel-----------------------
    public void displayField() {
        nonSelectedPicklist.clear();
        SelectedPicklist.clear();

        if (nonSelectedFields.size() > 0 && !nonSelectedFields.isEmpty() && nonSelectedFields != null) {
            for (String nsf: nonSelectedFields) {
                SelectOption so = new SelectOption(nsf, mapOfField.get(nsf).getDescribe().getLabel());
                nonSelectedPicklist.add(so);

            }
            if (nonSelectedPicklist.size() > 0 && !nonSelectedPicklist.isEmpty() && nonSelectedPicklist != null) {
                nonSelectedPicklist.sort(); //Sort the list of all fields 
            }
        }

        if (SelectedFields.size() > 0 && !SelectedFields.isEmpty() && SelectedFields != null) {
            for (String sf: SelectedFields) {
                SelectOption so = new SelectOption(sf, mapOfField.get(sf).getDescribe().getLabel());
                SelectedPicklist.add(so);

            }
            if (SelectedPicklist.size() > 0 && !SelectedPicklist.isEmpty() && SelectedPicklist != null) {
                System.debug('First ='+disbaledProcessButton);
                disbaledProcessButton = false;
            } else {
                System.debug('After ='+disbaledProcessButton);
                disbaledProcessButton = true;
            }
        }
    }

    //-------------------------------------------------- Add Button ----------------------------------------------------------
    public void doAddElement() {
        //System.debug('addElement = ' + addElement);
        nonSelectedFields.removeAll(addElement);
        SelectedFields.addAll(addElement);
        displayField();
    }


    //-------------------------------------------------- Del Button ----------------------------------------------------------
    public void doDelElement() {
        System.debug('removeElement = ' + removeElement);
        SelectedFields.removeAll(removeElement);
        nonSelectedFields.addAll(removeElement);
        displayField();
        If(SelectedFields.size() > 0){
            disbaledProcessButton = false;
        }else{
            disbaledProcessButton = true;
        }
    }

    //-------------------------------------------------- Process Button ----------------------------------------------------------
    public void doProcess() {
        objectName = selectedObject;
        System.debug('objectName = ' + objectName);

        fields = new List < String > ();
        for (System.SelectOption op: SelectedPicklist) {
            fields.add(op.getValue());
        }
        System.debug('fields = ' + fields);
        paginationPanel = true;
    }
}