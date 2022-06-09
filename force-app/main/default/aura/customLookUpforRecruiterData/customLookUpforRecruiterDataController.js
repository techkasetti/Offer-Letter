({
    selectUserRecord : function(component, event, helper){      
        // get the selected record from list
        var getSelectUserRecord = component.get("v.oUser");   
        console.log(JSON.stringify(getSelectUserRecord));
        // call the event   
       
         //alert('getSelectUserRecord'+getSelectUserRecord);
        var compEvent = component.getEvent("oRecruiterdataEvent");
       
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({
                             "recordByEvent" : getSelectUserRecord
                            });  
        // fire the event  
        compEvent.fire();
    },
})