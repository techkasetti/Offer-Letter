({
    searchSkillHelper : function(component,event,getInputkeyWord) {
        
        //alert('selectedparentList>>>>'+JSON.stringify(component.get("v.selectedparentList")));
        var action = component.get("c.fetchSkillsSetDataList");
        action.setParams({
            'enteredValue': getInputkeyWord ,
            'department' : component.get("v.selectedparentList"),
            'skillSet' : component.get("v.selectedSkillsetExp")
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
                
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfUserSearchRecords", storeResponse);
                //alert('j>>>>'+JSON.stringify(component.get("v.listOfUserSearchRecords")));
            }
            
        });
        $A.enqueueAction(action);        
    },
        
    getSkillset: function(component,event,helper){
        var action = component.get("c.getSkillSetPickListValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                //alert("Success");
                component.set("v.skillSetList",response.getReturnValue());
                console.log(response.getReturnValue());
                //alert('picklist>>'+component.get('v.skillSetList'));                
            }
            else if(state === 'ERROR'){
               
                var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Error!",
					"message": "Error in Picklist Values."
				});
				toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
        
        
    },
})