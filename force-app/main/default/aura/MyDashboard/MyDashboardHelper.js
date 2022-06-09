({
    
    
    searchUserHelper : function(component,event,getInputkeyWord) { 
        // alert(getInputkeyWord);
        // call the apex class method 
        var action = component.get("c.fetchLookupRecruiterdataList");
        action.setParams({
            'enteredValue': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") { 
                
                var storeResponse = response.getReturnValue();
                
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                console.log(storeResponse);
                // set searchResult list with return value from server.
                component.set("v.listOfUserSearchRecords", storeResponse);
            }
            
        });
        $A.enqueueAction(action);        
    },
    
    
    
    handleChangeHelper: function (component, event,selectedValue) {
        //alert('inside');
        
        var action = component.get("c.getRecruiterData");
        //alert('inside');
        action.setParams({
            'selectedValue': selectedValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('inside'+state);
            
            if(state === 'SUCCESS'){
                var ids =response.getReturnValue();
                console.log(ids);
                component.set("v.recruiterData",ids);
                //alert('ids>>'+ids);
                component.set("v.showSpinner",false);
            }
            else if(state === 'ERROR'){ 
                alert('Insertion Failed');   
            }
        })
        $A.enqueueAction(action);   
    },
    
    handleChangeResultHelper: function (component, event,selectedValue) {
        //alert(selectedValue);
        
        var action = component.get("c.getRecruiterDataDateWise");
        //alert('inside');
        action.setParams({
            'selectedValue': selectedValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('inside'+state);
            
            if(state === 'SUCCESS'){
                var ids =response.getReturnValue();
                console.log(ids);
                component.set("v.recruiterData",ids);
                //alert('ids>>'+ids);
                component.set("v.showSpinner",false);
            }
            else if(state === 'ERROR'){ 
                alert('Insertion Failed');   
            }
        })
        $A.enqueueAction(action);   
    },
})