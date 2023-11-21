({ 
    getAccounts: function(cmp, page, recordToDisplay) { 
         
        // create a server-side action.  
        var action = cmp.get("c.getAccount"); 
        // set the parameters to method  
        action.setParams({ 
            "pageNumber": page, 
            "recordToDisplay": recordToDisplay 
        }); 
         
        action.setCallback(this, function(response) { 
            // store the response 
            var result = response.getReturnValue(); 
            console.log ('**********result ' + JSON.stringify(result)); 
             
            // set the component attributes 
            cmp.set("v.AccountList", result.AccountListToDisplay); 
            cmp.set("v.page", result.pageNumber); 
            cmp.set("v.total", result.totalAccount); 
            cmp.set("v.pages", Math.ceil(result.totalAccount / recordToDisplay)); 
             
        }); 
         
        // enqueue the action  
        $A.enqueueAction(action); 
    } 
})