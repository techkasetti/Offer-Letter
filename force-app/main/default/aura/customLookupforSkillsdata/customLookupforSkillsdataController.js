({
    selectUserRecord : function(component, event, helper){      
        // get the selected record from list
        var getSelectUserRecord = component.get("v.oUser");        
        // call the event   
        var compEvent = component.getEvent("oRetailerdataEvent");
        var expandskill = component.get("v.selectedSkillsetExp");
        //alert(expandskill);
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({
                             "recordUserByEvent" : getSelectUserRecord,
                             "selectedexp" : expandskill
                            });  
        // fire the event  
        compEvent.fire();
    },
})