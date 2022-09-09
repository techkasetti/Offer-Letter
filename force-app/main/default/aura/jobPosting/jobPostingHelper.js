({
    getJobPostForEdit: function(component,event,helper){
        //GET JOB POSTING DOCUMENTS FOR EDIT
        var action = component.get("c.getJobPostingDocList");
        action.setParams({
            'jobPostingId': component.get("v.jobPostRecordId")
        });
       action.setCallback(this, function(response) {
           var state = response.getState();
               if(state === 'SUCCESS'){
                   console.log('jobPostRecordId>>'+response.getReturnValue());
                   component.set("v.jobPostDocRecordId", response.getReturnValue());
                   
               }
               else if(state === 'ERROR'){
                   var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       "title": "Error!",
                       "message": "Error in getJobPostingDocList."
                   });
                   toastEvent.fire();   
                   $A.util.toggleClass(spinner, "slds-hide");
               }
       })
       $A.enqueueAction(action);
 
       //GET SKILL EXPERIENCE LIST FOR EDIT
       var action = component.get("c.getJobPostingSkillExpList");
        action.setParams({
            'jobPostingId': component.get("v.jobPostRecordId")
        });
       action.setCallback(this, function(response) {
           var state = response.getState();
               if(state === 'SUCCESS'){
                   //console.log('jobPostSkillRecordId>>'+response.getReturnValue());
                   component.set("v.jobPostSkillRecordId", response.getReturnValue());
               }
               else if(state === 'ERROR'){
                   var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       "title": "Error!",
                       "message": "Error in getJobPostingSkillExpList."
                   });
                   toastEvent.fire();   
                   $A.util.toggleClass(spinner, "slds-hide");
               }
       })
       $A.enqueueAction(action);
 
       //GET TEAM FOR EDIT
       var action = component.get("c.getTeamBasedOnAccEdit");
       action.setParams({   
           "jobPostingId": component.get("v.jobPostRecordId")
       });
       action.setCallback(this, function(response) {
           var state = response.getState();
               if(state === 'SUCCESS'){
                   component.set("v.teamList",response.getReturnValue());
                   //alert('teamList>>'+JSON.stringify(response.getReturnValue()));                
               }
               else if(state === 'ERROR'){
                   var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       "title": "Error!",
                       "message": "Error in getTeamBasedOnAccEdit."
                   });
                   toastEvent.fire();  
               }
       })
       $A.enqueueAction(action);

       //GET TEAM MEMBERS FOR EDIT
        var teamMemlookupId= component.get("v.teamList");
        var action = component.get("c.getTeamMembers");
        action.setParams({   
            "team": teamMemlookupId.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                if(state === 'SUCCESS'){
                    // component.set("v.teamID",'sjhjs');
                    component.set("v.teamMemberList",response.getReturnValue());
                    //alert('teamMembersOptions>>'+JSON.stringify(response.getReturnValue()));
                }
                else if(state === 'ERROR'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error in getTeamMembers."
                    });
                    toastEvent.fire();  
                }
        })
        $A.enqueueAction(action);
     },


    getSkillsetHelper: function(component,event,helper){
        var actionYear = component.get("c.getSkillSetPickListValues");
        actionYear.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.skillList",response.getReturnValue());
                //alert('skillList>>'+JSON.stringify(component.get("v.skillList")));                
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
        $A.enqueueAction(actionYear);
        
        
    },



    searchSkillHelper : function(component,event,getInputkeyWord) {
        
        //alert('selectedDepartmentList>>>>'+JSON.stringify(component.get("v.selectedDepartmentList")));
        var action = component.get("c.fetchSkillsSetDataList");
        action.setParams({
            'enteredValue': getInputkeyWord ,
            'department' : component.get("v.selectedDepartmentList"),
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
                component.set("v.listOfSkillsSearchRecords", storeResponse);
                //alert('j>>>>'+JSON.stringify(component.get("v.listOfSkillsSearchRecords")));
            }
            
        });
        $A.enqueueAction(action);        
    },


    saveSkillandExpHelper : function(component,event,helper){
        var profile = component.get("v.candidateProfile");
        //alert('saveSkillAndExp>>'+JSON.stringify(component.get('v.candidateProfile')));
        var skillandexp = component.get("v.selectedUserRecordClone");
        
        var skillobj = component.get("v.skillAndExp");
        //alert('skillobj'+JSON.stringify(skillobj));      
        
        this.locationHelper(component,event,helper);
        
        var action = component.get("c.saveSkillAndExp");
        action.setParams({ 
            "profile": profile,
            "skillexp": JSON.stringify(skillobj),
            
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var storeResponse = response.getReturnValue();
                component.set("v.jobApplicationList",storeResponse);
                var candiProfile = component.get("v.jobApplicationList");
                alert(candiProfile[0].Candidate_Profile__c);
                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In saveSkillandExpHelper."
                });
                toastEvent.fire();   
            }
        })
        $A.enqueueAction(action);
        
        
    },

    getSkillsetFromHelper: function(component,event,helper){
        //started showcandidateprofile
        //alert('skillexp>>'+JSON.stringify(component.get("v.skillExp")));
        
        var action = component.get("c.getCandidateProfile");                    
        action.setParams({ 
            "skillexp": JSON.stringify(component.get("v.skillExp"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(response.getReturnValue().length!=0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "SUCCESS!",
                        "message": "Records Fetched Successfully."
                    });
                    toastEvent.fire();
                    var test =component.set("v.candidateProfile",response.getReturnValue());
                    component.set("v.ShowSmartSearchComponent",true);          
                    console.log(component.get("v.candidateProfile"));  
                    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": "No Records Found."
                    });
                    toastEvent.fire();
                }
            }
          /*  else if(state === 'ERROR'){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": "Error Occured."
                });
                toastEvent.fire();
            } */
        })
        $A.enqueueAction(action);
        //ended showcandidateprofile
        
        
        
    },
    
    
    searchPreLocationHelper : function(component,event,getInputkeyWord) {
       
        //alert('getInputkeyWord>>>>'+getInputkeyWord);
        var action = component.get("c.fetchUserDataList");
        action.setParams({
            'enteredValue': getInputkeyWord
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
                component.set("v.listOfProfileUserSearchRecords", storeResponse);
                //alert('j>>>>'+JSON.stringify(component.get("v.listOfProfileUserSearchRecords")));
            }
           
        });
        $A.enqueueAction(action);        

    },

    searchDocumentHelper : function(component,event,getInputkeyWord) {
       
        //alert('getInputkeyWord>>>>'+getInputkeyWord);
        var action = component.get("c.fetchDocumentList");
        action.setParams({
            'enteredDocValue': getInputkeyWord
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
                component.set("v.listOfDocumentRecords", storeResponse);
                //alert('j>>>>'+JSON.stringify(component.get("v.listOfDocumentRecords")));
            }
           
        });
        $A.enqueueAction(action);        

    },
})