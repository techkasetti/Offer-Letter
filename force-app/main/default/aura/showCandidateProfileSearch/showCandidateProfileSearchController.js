({
    doInit : function(component, event, helper) {
        
        
         //To get client Picklist values
        var action = component.get("c.getClientPicklistValues");
        var clients = component.get("v.clientList");
        console.log(JSON.stringify(component.get("v.clientList")));
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result= response.getReturnValue();
            console.log(result);
            if(state === 'SUCCESS'){
                for(let i=0; i<result.length;i++){
                    clients.push({"value":result[i].Id, "label":result[i].Name});
                }
                component.set("v.clientList",clients);
                console.log(component.get("v.clientList"));     
                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error Occured for Picklist"
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action); 
        
    },
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.showModal", true);
        //To get the selected picklist value
        var candProfile = event.getSource().get("v.value");
        
        var candProfilearray = component.get("v.jobApplication");
        
        candProfilearray.push(candProfile.Name);
        candProfilearray.push(candProfile.Id);
        component.set("v.jobApplication",candProfilearray);
        console.log(component.get("v.jobApplication"));
    },
    
    hideModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showModal", false);
    },
    
    saveDetails: function(component, event, helper) {
        //To get the selected picklist value
        var getSelectedJob = component.find('select').get('v.value');
        
        var jobApp = component.get("v.jobApplication");
        jobApp.push(getSelectedJob);
        
        component.set("v.jobApplication",jobApp);
        console.log(component.get("v.jobApplication"));
        
        var job = component.get("v.jobApplication");
        
        var action = component.get("c.saveJobApplication");
        
        action.setParams({ 
            
            "job": job
            
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                
                if(response.getReturnValue()){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been saved successfully."
                    });
                    toastEvent.fire();
                    //url redirect
                    window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
                }
                $A.get('e.force:refreshView').fire();
            }
            else if(state === 'ERROR'){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Save Unsuccessfull."
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
        
        
    },
    
    viewDocument: function(component, event, helper) {
        var candProfile = event.getSource().get("v.value");
        //alert(candProfile.Id);
        
        var action = component.get("c.fetchDocument");
        
        action.setParams({ 
            
            "parentID": candProfile.Id
            
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                
                if(response.getReturnValue()){
                    var storeResponse = response.getReturnValue();
                    console.log(JSON.stringify(storeResponse));
                    component.get("v.candidateIds");
                    //alert(storeResponse[0].ContentDocumentId);
                    
                    var openPreview = $A.get('e.lightning:openFiles');
                    openPreview.fire({
                        recordIds: [storeResponse[0].ContentDocumentId]
                    });
                    
                }
                
            }
            else if(state === 'ERROR'){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in Loading Document!!!"
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
        
    },
    
    clientSelected : function(component, event, helper){
        var clientId= component.find('selectClient').get('v.value');
        //alert(clientId);
        var array = component.get("v.jobPostingList");
        console.log(component.get("v.jobPostingList"));
        var action = component.get("c.getJobPostingPickListValues");
        
        action.setParams({
            clientId: clientId
            
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res= response.getReturnValue();
            
            if(state === 'SUCCESS'){
                for(let i=0; i<res.length;i++){
                    array.push({"value":res[i].Id, "label":res[i].Name});
                }
                component.set("v.jobPostingList",array);
                //console.log(component.get("v.jobPostingList"));       
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error Occured."
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action); 
    },
    
})