({
    
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,   
    
    uploadHelper: function(component, event,helper) {
        
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fuploader").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents) {
        
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value
        
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.saveSkillandExpHelper(component, event, file, fileContents, startPosition, endPosition, '');
    },
    
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
    
    
    searchPreLocationHelper : function(component,event,getInputkeyWord) {
        
        //alert('getInputkeyWord>>>>'+getInputkeyWord);
        var action = component.get("c.fetchPreLocationDataList");
        
        action.setParams({
            'enteredValue': getInputkeyWord
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
                console.log(storeResponse[0].Billing_City__c);
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfLocationSearchRecords", storeResponse[0].Billing_City__c);
                console.log(component.get("v.listOfLocationSearchRecords"));
            }
            
        });
        $A.enqueueAction(action);        
    },
    
    /*getSkillset: function(component,event,helper){
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
                    "message": "Error Occured."
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
        
        
    },*/
    
    searchSkillset: function(component,event,selectedUserrecordByEvent){
        if(selectedUserrecordByEvent != null && selectedUserrecordByEvent != ""){
            var pushToSelectdUser = component.get("v.selectedUserRecord")
            
            
            pushToSelectdUser.push(selectedUserrecordByEvent);
            // helper.getSkillset(component,event,helper);
            console.log(pushToSelectdUser);
            pushToSelectdUser[0].SkillSet_Experience__c=component.get("v.selectedSkillsetExp");
            console.log(pushToSelectdUser); 
            
            
            
        }
        
    },
    
    experience: function(component){
        var exp = component.get("v.selectedSkillsetExp");
        //alert('exp'+JSON.stringify(component.get('v.selectedSkillsetExp')));
        //alert(exp);
        if(exp==='NULL')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "Select Experience",
                type: "warning"
            });
            toastEvent.fire();
            return;
            return false;
            
            
        }
        else{
            return true;
        }
    },
    saveSkillandExpHelper : function(component, event, file, fileContents, startPosition, endPosition, attachId){
        
        var profile = component.get("v.candidateProfile");
        //alert('saveSkillAndExp>>'+JSON.stringify(component.get('v.candidateProfile')));
        
        var startDate =  component.get("v.fromDate");
        var endDate =  component.get("v.toDate");
        //alert('startDate??'+startDate);
        //alert('endDate??'+endDate);
        //For skills and Exp
        component.set("v.candidateProfile.From_Year_Of_Graduation__c",startDate);
        component.set("v.candidateProfile.To_Year_Of_Graduation__c",endDate);
        console.log(JSON.stringify(component.get("v.candidateProfile")));
        var skillandexp = component.get("v.selectedUserRecordClone");
        
        var skillobj = component.get("v.skillAndExp");
        //alert('skillobj'+JSON.stringify(skillobj));     
        console.log(component.get("v.skillAndExp")); 
        
        //For Rolls and Responsibilities 
        console.log(component.get("v.selectedRollsAndRespRecord"));
        var rollsAndResp = component.get("v.selectedRollsAndRespRecord");
        const rollsAndRespMap = new Map();
        for(const rolls of rollsAndResp){
            //alert(String(rolls.Name));
            rollsAndRespMap[String(rolls.Name)]=rolls;
        }
        /*for(var key in rollsAndRespMap){
            alert(key);
              alert(rollsAndRespMap[key]);
          }*/
        
        //this.locationHelper(component,event,helper);
        console.log(component.get("v.selectedLocationRecord"));
        var location = component.get("v.selectedLocationRecord");
        
        //alert(location);
        var locationArray='';
        
        for(var i =0; i<location.length; i++)
        {
            
            locationArray=locationArray+location[i]+', ';
            console.log(locationArray);
        }                  
        component.set("v.candidateProfile.Preferred_Location__c",locationArray);          
        console.log(JSON.stringify(component.get("v.candidateProfile")));
        
        var getchunk = fileContents.substring(startPosition, endPosition);      
        
        var action = component.get("c.saveSkillAndExp");
        
        action.setParams({ 
            "profile": profile,
            "skillexp": JSON.stringify(skillobj),
            "fileName": file.name,
            "base64Data": encodeURIComponent(getchunk),
            "contentType": file.type,
            "fileId": attachId,
            "rollsAndRespMap": rollsAndRespMap
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('state>>'+state);
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Candidate Profile Created."
                });
                toastEvent.fire();
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                
                var jobList =component.set("v.jobApplicationList",storeResponse);
                console.log(component.get("v.jobApplicationList"));
                
                var getSelectedJob = component.find('select').get('v.value');
                // alert('JOB'+getSelectedJob); 
                
                if(getSelectedJob){
                    var jobApp = component.get("v.jobApplication");
                    console.log(component.get("v.jobApplication"));
                    var cand = component.get("v.jobApplicationList") ;
                    console.log(component.get("v.jobApplicationList"));
                    jobApp.push(cand[0].Candidate_Profile__c);
                    
                    jobApp.push(getSelectedJob);
                    
                    component.set("v.jobApplication",jobApp);
                    console.log(component.get("v.jobApplication"));
                }
                else{
                    //url redirect
                    window.location.replace("https://kasetti-dev-evironmet-dev-ed.lightning.force.com/lightning/n/Home_Page");
                }
                
                var job = component.get("v.jobApplication"); 
                
                var jobPostAction = component.get("c.saveJobApplication");
                
                jobPostAction.setParams({ 
                    
                    "job": job
                    
                });
                jobPostAction.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === 'SUCCESS'){
                        
                        if(response.getReturnValue()){
                            console.log(response.getReturnValue());
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "The Job Application has been saved successfully."
                            });
                            toastEvent.fire();
                        }
                        //$A.get('e.force:refreshView').fire();
                        //url redirect
                        component.set("v.showSpinner",true);
                        window.location.replace("https://kasetti-dev-evironmet-dev-ed.lightning.force.com/lightning/n/Home_Page");
                        
                        
                        
                    }
                    else if(state === 'ERROR'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Error Occured in Creating Job Application."
                        });
                        toastEvent.fire();
                    }
                })
                $A.enqueueAction(jobPostAction);
                
                //url redirect
                // window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error Occured in creating Profile."
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
        
        
    },
    // saveDetailsHelper: function(component,event,helper){
    //     var profile = component.get("v.candidateProfile");
    //     //alert('saveSkillAndExp>>'+JSON.stringify(component.get('v.candidateProfile')));
    
    //     var skillandexp = component.get("v.selectedUserRecordClone");
    
    //     var skillobj = component.get("v.skillAndExp");
    
    //     this.locationHelper(component,event,helper);
    
    //     var action = component.get("c.saveSkillAndExp");
    //     action.setParams({ 
    //         "profile": profile,
    //         "skillexp": JSON.stringify(skillobj),
    
    
    //     });
    //     action.setCallback(this, function(response) {
    //         var state = response.getState();
    
    //         if(state === 'SUCCESS'){
    //             //alert("success");
    //             var storeResponse = response.getReturnValue();
    //             component.get("v.jobApplicationList");
    //             console.log( component.get("v.jobApplicationList"));
    //             component.set("v.jobApplicationList",storeResponse);
    //             var candiProfile = component.get("v.jobApplicationList");
    //             console.log(candiProfile);
    //             var getSelectedJob = component.find('select').get('v.value');
    //             alert('JOB'+getSelectedJob); 
    //             var jobApp = component.get("v.jobApplication");
    //             console.log(component.get("v.jobApplication"));
    //             jobApp.push(candiProfile[0].Candidate_Profile__c);
    
    //             jobApp.push(getSelectedJob);
    
    //             component.set("v.jobApplication",jobApp);
    //             console.log(component.get("v.jobApplication"));
    
    
    //             var job = component.get("v.jobApplication"); 
    
    //             var jobPostAction = component.get("c.saveJobApplication");
    
    //             jobPostAction.setParams({ 
    
    //                 "job": job
    
    
    //             });
    //             jobPostAction.setCallback(this, function(response) {
    //                 var state = response.getState();
    //                 if(state === 'SUCCESS'){
    
    //                     if(response.getReturnValue()){
    //                         var toastEvent = $A.get("e.force:showToast");
    //                         toastEvent.setParams({
    //                             "title": "Success!",
    //                             "message": "The Job Application has been saved successfully."
    //                         });
    //                         toastEvent.fire();
    //                     }
    //                     //$A.get('e.force:refreshView').fire();
    //                     ////url redirect
    //                     window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
    
    //                 }
    //                 else if(state === 'ERROR'){
    //                     var toastEvent = $A.get("e.force:showToast");
    //                     toastEvent.setParams({
    //                         "title": "Error!",
    //                         "message": "Error Occured."
    //                     });
    //                     toastEvent.fire();
    //                 }
    //             })
    //             $A.enqueueAction(jobPostAction);
    //             // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
    //         }
    //         else if(state === 'ERROR'){
    //             var toastEvent = $A.get("e.force:showToast");
    //             toastEvent.setParams({
    //                 "title": "Error!",
    //                 "message": "Error Occured."
    //             });
    //             toastEvent.fire();
    //         }
    //     })
    //     $A.enqueueAction(action);
    
    
    // },
    
    /*locationHelper: function(component,event,helper){
        
        var location = component.get("v.selectedLocationRecord");
        
        var locationArray='';
        
        for(var i =0; i<location.length; i++)
        {
            
            locationArray=locationArray+location[i].Name+', ';
        }                  
        component.set("v.candidateProfile.Preferred_Location__c",locationArray);          
        console.log(JSON.stringify(component.get("v.candidateProfile")));
        
    },*/
    
    searchRollsAndResponsibilitiesHelper : function(component,event,getInputkeyWord) {
        
        //alert('selectedparentList>>>>'+JSON.stringify(component.get("v.selectedType")));
        var action = component.get("c.fetchRollsResponsibilitiesList");
        action.setParams({
            'enteredValue': getInputkeyWord ,
            'type' : component.get("v.selectedType"),
            
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfRollsAndResponsibilitiesRecords", storeResponse);
                console.log(JSON.stringify(component.get("v.listOfRollsAndResponsibilitiesRecords")));
            }
            
        });
        $A.enqueueAction(action);        
    },
    
    handleOnSubmitHelper: function(component, event, helper, fields){
        
        var skillsList = component.get("v.skillsList");
        console.log(skillsList);
        var rolesAndRespo = component.get("v.rolesandRespoList");
        console.log(rolesAndRespo);
        var action = component.get("c.saveCandidateProfile");
        action.setParams({
            "candFields": fields,
            "skills": skillsList,
            "rolesAndResp": rolesAndRespo
        });
        action.setCallback(this, function(response) {
            //get response status 
            var state = response.getState();
            if (state === "SUCCESS") { 
                //set empty account list
                //component.set("v.skillsList", []);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Candidate Profile Created.",
                     type: "success"
                });
                toastEvent.fire();
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                
                var jobList =component.set("v.jobApplicationList",storeResponse);
                console.log(component.get("v.jobApplicationList"));
                var getSelectedJob = component.find('select').get('v.value');
                //alert('getSelectedJob>>'+getSelectedJob);
                if(getSelectedJob){
                    var jobApp = component.get("v.jobApplication");
                    console.log(component.get("v.jobApplication"));
                    var cand = component.get("v.jobApplicationList") ;
                    console.log(component.get("v.jobApplicationList"));
                    jobApp.push(cand[0].Candidate_Profile__c);
                    
                    jobApp.push(getSelectedJob);
                    
                    component.set("v.jobApplication",jobApp);
                    console.log(component.get("v.jobApplication"));
                }
                else{
                    var urlString = window.location.href;
                            var CommunityBaseURL = urlString.substring(0,urlString.indexOf("/one/"));
                            window.location.replace(CommunityBaseURL+"/lightning/n/Home_Page");
                }
                var job = component.get("v.jobApplication"); 
                
                var jobPostAction = component.get("c.saveJobApplication");
                
                jobPostAction.setParams({ 
                    
                    "job": job
                    
                });
                jobPostAction.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === 'SUCCESS'){
                        
                        if(response.getReturnValue()){
                            console.log(response.getReturnValue());
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "Job Application has been saved successfully.",
                                type: "success"
                            });
                            toastEvent.fire();
                            var urlString = window.location.href;
                            var CommunityBaseURL = urlString.substring(0,urlString.indexOf("/one/"));
                            window.location.replace(CommunityBaseURL+"/lightning/n/Home_Page");
                            }
                    }
                        //$A.get('e.force:refreshView').fire();
                        //url redirect
                        
                    else if(state === 'ERROR'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Error Occured in Creating Job Application.",
                            type: "error"
                        });
                        toastEvent.fire();
                    }
                })
                $A.enqueueAction(jobPostAction);
                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error Occured in creating Profile.",
                    type: "error"
                });
                toastEvent.fire();
            }
        }); 
        $A.enqueueAction(action);
    }
})