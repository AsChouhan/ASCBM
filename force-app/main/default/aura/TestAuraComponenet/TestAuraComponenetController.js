/*({
	trmp : function(component, event, helper) {
        //component.set("v.var1","Demo value from component's controller")
        var data = {'name' : 'Test Name',
                    'Email' : 'bsofficial@gmail.com'};
        component.set("v.jsObject",data);
        
        component.set("v.userData",
                      {
                      'myString1' : 'Stringvalue',
                      'myInteger1':  2023
                      })
    }
})*/
({
     doInit : function(component, event, helper){
    component.set("v.message1","Button1 Initialized")
     component.set("v.message2","Button2 Initialized")	
     },
     handleClick : function(component, event, helper){
    component.set("v.message1","Button clicked")
     },
     SecondhandleClick : function(component, event, helper){
    component.set("v.message2","Button clicked")
     }
})