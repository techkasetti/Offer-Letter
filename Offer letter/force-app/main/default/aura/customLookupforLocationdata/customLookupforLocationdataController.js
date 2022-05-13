({
    selectUserRecord : function(component, event, helper){      
        // get the selected record from list
        var getSelectUserRecord = component.get("v.oUser"); 
        console.log(getSelectUserRecord);
      
        // call the event   
        //alert("Inside");
        var compEvent = component.getEvent("oRetailerdataEvent1");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({
                             "recordLocationByEvent" : getSelectUserRecord,
                             
                            });  
        // fire the event  
        compEvent.fire();
    },
})