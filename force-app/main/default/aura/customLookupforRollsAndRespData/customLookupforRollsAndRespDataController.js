({
	 selectUserRecord : function(component, event, helper){      
        // get the selected record from list
        
        var getSelectUserRecord = component.get("v.oUser");   
         console.log(getSelectUserRecord);
        // call the event   
        var compEvent = component.getEvent("oRetailerdataEvent3");
        //var expandskill = component.get("v.selectedSkillsetExp");
        //alert('expandskill');
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({
                             "recordRollsAndRespByEvent" : getSelectUserRecord,
                             
                            });  
        // fire the event  
        compEvent.fire();
    },
})