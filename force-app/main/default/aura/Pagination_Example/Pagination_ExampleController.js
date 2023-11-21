({ 
    //Handler function load initial Values 
    doInit: function(cmp, event, helper) { 
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        //Get selected the value 
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        //Saving the columns  
        cmp.set('v.Account', [ 
            {label: 'Account Name', fieldName: 'Name', type: 'Name'},                    
            {label: 'Phone', fieldName: 'Phone', type: 'Phone'}]); 
         
        // call the helper function    
        helper.getAccounts(cmp, page, recordToDisplay); 
         
    }, 
    // this function call on click on the previous/Next page button   
    navigate: function(cmp, event, helper) { 
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        // get the button's label   
        var direction = event.getSource().get("v.label"); 
         
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
         
        // set the current page 
        page = direction === "Previous Page" ? (page - 1) : (page + 1); 
         
        // call the helper function 
        helper.getAccounts(cmp, page, recordToDisplay); 
         
    }, 
     
    // this function call on the select opetion change,  
    onSelectChange: function(cmp, event, helper) { 
         
        var page = 1 
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        // call the helper function 
        helper.getAccounts(cmp, page, recordToDisplay); 
    }, 
     
})