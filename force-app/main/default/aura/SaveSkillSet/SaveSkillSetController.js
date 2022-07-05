({
    
    doInit : function(component, event,helper,page) 
    {   
        
        component.set("v.SearchUserKeyWord","");
        //component.set("v.selectedUserRecord",[]);
        
        component.set("v.SearchUserKeyWord1","");
        component.set("v.selectedLocationRecord",[]);
        
        component.set("v.SearchUserKeyWord2","");
        
        var action = component.get("c.getNoticePerPickListValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfNoticePeriod",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        
        var action = component.get("c.getDepartmentPickListValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.parentList",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        //helper.getSkillset(component,event,helper);
        
        var action = component.get("c.getIndustryPicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfIndustries",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        var action = component.get("c.getFunctionalAreaPicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfFunctionalAreas",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        var action = component.get("c.getDesignationPicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfDesignation",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        var action = component.get("c.getStreamPicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfStreams",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        var action = component.get("c.getPGStreamPicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfPGStreams",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        
        
        var action = component.get("c.getSkillSetRatingPickList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                //alert("Success");
                component.set("v.listOfRatings",response.getReturnValue());
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
        
        //To get client Picklist values
        var action = component.get("c.getClientPicklistValues");
        var clients = component.get("v.clientList");
        //component.set("v.jobPostingList",null);
        console.log(JSON.stringify(component.get("v.clientList")));
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result= response.getReturnValue();
            console.log(result);
            if(state === 'SUCCESS'){
                for(let i=0; i<result.length;i++){
                    clients.push({"value":result[i].Account__r.Id, "label":result[i].Account__r.Name});
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
        
        //To get Rolls And Responsibilities Picklist
        /*var action = component.get("c.getTypePicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfType",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        $A.enqueueAction(action);*/
        
        //To get Education Type Picklist Values
        var action = component.get("c.getEdTypePicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfEdTypes",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
        
        
        //To get PG Education Type Picklist Values
        var action = component.get("c.getPGEdTypePicklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfPGEdTypes",response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
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
    
    
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true       
        component.set("v.showModal", true);
        
        //To get the selected picklist value
        var candProfile = event.getSource().get("v.value");
        //var candprofile = component.get("v.candidateProfile");
        var candprofile = component.get("v.candiProfile")
        // alert('candprofile'+candprofile);
        var jobApp = component.get("v.jobApplication");
        jobApp.push(candprofile.Name);
        component.set("v.jobApplication",jobApp);
        console.log(component.get("v.jobApplication"));  

        var skillsList = component.get("v.skillsList");
        console.log(skillsList);
        var action = component.get("c.getSkillName");      
        
        action.setParams({
          
            'skillsList': skillsList
            
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                var skills = component.get("v.skillsListName");
                /*for(var i =0; i<storeResponse.size();i++){
                    skills.push(storeResponse[i]);
                    console.log(skills);
                }*/
                component.set("v.skillsListName",storeResponse);
                var skillsName = component.get("v.skillsListName");
                console.log(skillsName);
                }
                else if(state === 'ERROR'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error Occured!!"
                    });
                    toastEvent.fire();
                    
                }
            })
            $A.enqueueAction(action);  
    },
    
    hideModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showModal", false);
    },
    
    search : function(component, event, helper) {
        
        
        var expAnnualSalary1 = component.find('input7').get('v.value');
        var expAnnualSalary2 = component.find('input9').get('v.value');
        if(expAnnualSalary1 > expAnnualSalary2)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "Expected Annual Salary Should Be In Correct Range",
                type: "warning"
            });
            toastEvent.fire();
            return;
        }   
        var exp = expAnnualSalary1 +  ',' + expAnnualSalary2 ;  
        
        //experience
        var minExperience = component.find('input4').get('v.value');
        var maxExperience = component.find('input5').get('v.value');
        if(minExperience > maxExperience)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "Maximum Experience should be greater than Minimum Experience",
                type: "warning"
            });
            toastEvent.fire();
            return;
        }   
        
        //currentLocation
        var curLocation = component.find('input11').get('v.value');
        
        //notice period
        if((component.get("v.selectedNoticePeriod") =='NULL') || (component.get("v.selectedNoticePeriod") ==''))
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "Select the Notice Period",
                type: "warning"
            });
            toastEvent.fire();
            return;
        }   
        
        
        
        
        //preferred Location
        var preLocation = component.get("v.selectedLocationRecord");
        //alert('preLocation>>'+JSON.stringify(preLocation));
        
        
        
        var action = component.get("c.getCustomerProfile");
        action.setParams({
            'curLocation': curLocation ,
            'expCTC':  exp ,
            'minExperience': minExperience ,
            'maxExperience': maxExperience ,
            'noticePer': component.get("v.selectedNoticePeriod") ,
            'skills': userList ,
            'preLocation': preLocation
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var profile =JSON.stringify(response.getReturnValue());
                var test =component.set("v.candidateProfile",response.getReturnValue());
                component.set("v.ShowCandidateProfile",true);  
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Insertion Failed."
                });
                toastEvent.fire();
                
            }
        })
        $A.enqueueAction(action);
        
    },
    
    
    
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfUserSearchRecords", null );
        var forclose = component.find("searchUserRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    
    keyPressUserController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchUserKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.  
        
        if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchUserRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchSkillHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfUserSearchRecords", null ); 
            var forclose = component.find("searchUserRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    clearUser :function(component,event,heplper){
        var pillTarget = event.getSource().get('v.label');
        ///alert("pillTarget"+pillTarget);
        
        var getSelectdUserList = component.get("v.selectedUserRecordClone");
        //alert('getSelectdUserList'+getSelectdUserList);
        for(var i = 0; i < getSelectdUserList.length; i++){
            if(getSelectdUserList[i] == pillTarget){
                getSelectdUserList.splice(i, 1);
                
                component.set("v.selectedUserRecordClone", getSelectdUserList);
            }  
        }
        component.set("v.SearchUserKeyWord",null);
        component.set("v.listOfUserSearchRecords", null );
        component.set("v.selectedSkillsetExp",null);
        component.set("v.selectedRating",null);
    },
    
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 
        
        //if(helper.experience(component))
        
        var selectedrecordByEvent = event.getParam("recordByEvent");
        
        var selectedUserrecordByEvent = event.getParam("recordUserByEvent");
        //alert('selectedUserrecordByEvent' +selectedUserrecordByEvent);
        //var sillexp = event.getParam("selectedexp");
        
        component.set("v.experience",selectedUserrecordByEvent);
        
        
        helper.searchSkillset(component,event,selectedUserrecordByEvent);
        
        var skill = component.get("v.experience");
        console.log(JSON.stringify(component.get("v.experience")));        
        component.set("v.SearchUserKeyWord",skill.Name);
    }, 
    
    
    onblur1 : function(component,event,helper){       
        component.set("v.listOfSearchRecords1", null );
        var forclose = component.find("searchRes1");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfLocationSearchRecords", null );
        var forclose = component.find("searchLocationRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    
    keyPressUserController1 : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchUserKeyWord1");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchLocationRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            
            helper.searchPreLocationHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfLocationSearchRecords", null ); 
            var forclose = component.find("searchLocationRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    clearUser1 :function(component,event,heplper){
        
        var userName = event.getSource().get("v.label");    
        //alert(userName);
        var getSelectdUserList = component.get("v.selectedLocationRecord");
        //console.log("getSelectdUserList:"+getSelectdUserList);
        //var newUserList = [];
        for(var i = 0; i < getSelectdUserList.length; i++){
            if(getSelectdUserList[i] == userName){
                getSelectdUserList.splice(i, 1);
                component.set("v.selectedLocationRecord", getSelectdUserList);
            }  
        }
        component.set("v.SearchUserKeyWord1",null);
        component.set("v.listOfLocationSearchRecords", null );  
        
        
    },
    
    handleComponentEvent1 : function(component, event, helper) {
        
        var selectedUserrecordByEvent = event.getParam("recordLocationByEvent");
        //alert('selectedUserrecordByEvent'+selectedUserrecordByEvent);
        if(selectedUserrecordByEvent != null && selectedUserrecordByEvent != ""){
            var pushToSelectdUser = component.get("v.selectedLocationRecord")
            pushToSelectdUser.push(selectedUserrecordByEvent);
            component.set("v.selectedLocationRecord" , pushToSelectdUser);
            var forclose = component.find("lookupUser-pill1");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchLocationRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            component.set("v.SearchUserKeyWord1" , '');
        }
        
    },
    
    onGroup: function(cmp, evt) {
        var selected = evt.getSource().get("v.label");
        //alert('selected>>'+selected);
        
    },
    
    setSkillandExp : function(component,event,helper){
        
        var exp= component.find('mySelect').get('v.value');
        console.log(exp);
        //alert('exp'+exp);
        
        var rating = component.find('selectRating').get('v.value');
        // alert(rating);
        
        var skill = component.get("v.experience");
        console.log(JSON.stringify(component.get("v.experience")));
        
        //skill.push(exp);
        //console.log(JSON.stringify(component.get("v.experience")));
        var skillExp = skill.Name+'-' + exp+'-' +rating;
        
        // alert('skillExp'+skillExp);
        
        var selectedUserRecordClone = component.get("v.selectedUserRecordClone" );
        //alert('selectedUserRecordClone All>>'+JSON.stringify(selectedUserRecordClone));
        selectedUserRecordClone.push(skillExp);
        component.set("v.selectedUserRecordClone" , selectedUserRecordClone);
        //console.log(component.get("v.selectedUserRecordClone"));
        var forclose = component.find("lookupUser-pill");
        
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        
        
        var forclose = component.find("searchUserRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var array = component.get("v.skillAndExp");
        //console.log(array);
        
        //alert('skillExp'+skillExp);
        
        console.log(component.get("v.skillAndExp"));
        //alert(typeof(array));
        for (const key in skill) {
            if (Object.hasOwnProperty.call(skill, key)) {
                if(key=='Name' || key=='Id'){
                    const element = skill[key];
                    array.push(element);
                } 
            }
        }
        array.push(exp);
        array.push(rating);
        component.set("v.skillAndExp", array);
        console.log(component.get("v.skillAndExp"));
        
        var skillsList = component.get("v.candidateSkills");
        skillsList[skill.Name] = exp;
        component.set("v.candidateSkills",skillsList);
        console.log(JSON.stringify(component.get("v.candidateSkills")));
        component.set("v.selectedRating",'');
        component.set("v.selectedSkillsetExp",'');
        component.set("v.selectedparentList",'');
        component.set("v.SearchUserKeyWord",'');
    },
    
    handleChange: function(component,event,helper){
 
        var getSelectedJob = component.find('select').get('v.value');
        console.log(getSelectedJob);
        //var mapValue = component.get("v.skillsList");
        var candSkills = component.get("v.skillsListName");
        console.log(JSON.stringify(candSkills));

        var loc = component.find("locationForm").get("v.value");
        console.log(JSON.stringify(loc));

        var fields = component.find("candiForm").get("v.value");
        console.log(JSON.stringify(fields));
        alert(JSON.stringify(fields));
        
        fields["Billing_Location__c"]= JSON.stringify(loc);
        component.find('candiForm').set('v.value',fields);
        console.log(JSON.stringify(fields));

        var action = component.get("c.getJobPostingValues");
        
        //var mapValue = component.get("v.candidateSkills");   
   
        action.setParams({
            'jobId': getSelectedJob,
            'candSkills': JSON.stringify(candSkills)
            
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){

                //Show that the job posting is in pause state if we get an empty value STARTS
               // alert('response>>'+response.getReturnValue());
                if(response.getReturnValue()){
                   
                    helper.handleOnSubmitHelper(component, event, helper, fields);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Skills did not match with Job Posting",
                        type: "error"
                    });
                    toastEvent.fire();
                }
                    //alert('Inside for>>'+Object.keys(mapValue).includes(storeResponse[i].Name));
                    //alert('Inside for>>'+Object.values(mapValue).includes(storeResponse[i].SkillSet_Experience__c));
                    
                    /*if(Object.keys(mapValue).includes(storeResponse[i].Name) && Object.values(mapValue).includes(storeResponse[i].Skill_Experience_Level__c))
                    {
                        skillMatch = true;     
                    }
                    else{
                        skillMatch = false;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Skills did not match"
                        });
                        toastEvent.fire();
                        
                        break;
                    }*/
                    
                    // alert('Skill Exp>>'+storeResponse[i].SkillSet_Experience__c);
                    
                
                
                /*if ( component.find("fuploader").get("v.files").length > 0) {
                    //alert('File Found ');
                    if(skillMatch){
                        helper.uploadHelper(component, event,helper);
                        
                    }
                } else {
                    alert('Please Select a Valid File');
                }    
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Insertion Failed."
                });
                toastEvent.fire();
                
            }*/
                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Job Posting is in Pause State.",
                    type: "error"
                });
                toastEvent.fire();
            }

            //Show that the job posting is in pause state if we get an empty value ENDS

        

        })
        $A.enqueueAction(action);
        
    },
    
    saveSkillandExp: function(component,event,helper)
    {
        if (component.find("fuploader").get("v.files").length > 0) {
            alert('File Found ');
            helper.uploadHelper(component, event,helper);
        } else {
            alert('Please Select a Valid File');
        }
        
        
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    saveDetails: function(component, event, helper) {
        //To get the selected picklist value
        helper.saveDetailsHelper(component,event,helper);
        
        
    },
    
    
    datachange :function(component)
    {
        var value = component.get("v.candidateProfile");
        // alert("Inside"+value.Name);
        
    },
    
    preferredNoticePeriod :function(component){
        
        var action = component.get("v.selectedNoticePeriod");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.Notice_Period__c");
        
        component.set("v.candidateProfile.Notice_Period__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    preferredIndustry :function(component){
        
        var action = component.get("v.selectedIndustry");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.Industry__c");
        
        component.set("v.candidateProfile.Industry__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredRole :function(component){
        
        var action = component.get("v.selectedFunctionalArea");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.Functional_Area__c");
        
        component.set("v.candidateProfile.Functional_Area__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredDesignation :function(component){
        
        var action = component.get("v.selectedDesignation");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.Designation__c");
        
        component.set("v.candidateProfile.Designation__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredStream :function(component){
        
        var action = component.get("v.selectedStream");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.UG_Stream__c");
        
        component.set("v.candidateProfile.UG_Stream__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredPGStream :function(component){
        
        var action = component.get("v.selectedPGStream");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.PG_Stream__c");
        
        component.set("v.candidateProfile.PG_Stream__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    clientSelected : function(component, event, helper){
        var clientId= component.find('selectClient').get('v.value');
        //alert(clientId);
        component.set("v.jobPostingList",'');
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
    
    onblur2 : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfUserSearchRecords", null );
        var forclose = component.find("searchUserRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    
    keyPressUserController2 : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchUserKeyWord3");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.  
        
        if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchRollsAndRespRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchRollsAndResponsibilitiesHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfRollsAndResponsibilitiesRecords", null ); 
            var forclose = component.find("searchRollsAndRespRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    handleRollsComponentEvent: function(component, event, helper) {
        
        var selectedUserrecordByEvent = event.getParam("recordRollsAndRespByEvent");
        console.log(JSON.stringify(selectedUserrecordByEvent));
        if(selectedUserrecordByEvent != null && selectedUserrecordByEvent != ""){
            var pushToSelectdUser = component.get("v.selectedRollsAndRespRecord")
            pushToSelectdUser.push(selectedUserrecordByEvent);
            console.log(JSON.stringify(pushToSelectdUser));
            component.set("v.selectedRollsAndRespRecord" , pushToSelectdUser);
            var forclose = component.find("lookupUser-pill2");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchRollsAndRespRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            console.log(component.get("v.selectedRollsAndRespRecord"));
            var res = component.get("v.selectedRollsAndRespRecord")
            for(var i =0; i<res.length; i++){
                console.log(res[i].Type__c);
                component.set("v.SearchUserKeyWord3",res[i].Name);   
            }
            
        }
        component.set("v.SearchUserKeyWord3",'');   
        
    },
    
    preferredEdType :function(component){
        
        var action = component.get("v.selectedEdType");
        //alert('action'+action);
        
        var Type = component.get("v.candidateProfile.UG_Education_Type__c");
        
        component.set("v.candidateProfile.UG_Education_Type__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredPGEdType :function(component){ 
        
        var action = component.get("v.selectedPGEdType");
        //alert('action'+action);
        
        var Type = component.get("v.candidateProfile.PG_Education_Type__c");
        
        component.set("v.candidateProfile.PG_Education_Type__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    handleOnSubmit : function(component, event, helper) {
        
        var loc = component.find("locationForm").get("v.value");
        console.log(JSON.stringify(loc));

        var fields = component.find('accForm1').get('v.value');
        
        console.log(JSON.stringify(fields));
        fields["Billing_Location__c"]= JSON.stringify(loc);
        component.find('accForm1').set('v.value',fields);
        console.log(JSON.stringify(fields));

        
        
       
             helper.handleOnSubmitHelper(component, event, helper,fields);
             
        //event.preventDefault();
        
        
    },
    
    /*handleOnSuccess : function(component, event, helper) {
        /*var resp = event.getParam().response;
       console.log(resp.Id);*/
    /*var record = event.getParam("response");
        //alert('record' +JSON.stringify(record));
        //alert(record.Id);
        component.find("notificationsLibrary").showToast({
            "title": "Success",
            "message": "Candidate Profile Created",
            "variant": "Success"
            
        });
    },*/
    
    addRow: function(component, event, helper) {
        //get the account List from component  
        var skillsList = component.get("v.skillsList");
        //Add New Account Record
        skillsList.push({
            'sobjectType': 'Skill_Set_Experience__c',
            'Skill_Set__c': '',
            'Skill_Experience_Level__c': '',
            'Ratings__c': '',
            
        });
        component.set("v.skillsList", skillsList);
        // alert('accountList   :::::'+accountList);
    },
    
    removeRecord: function(component, event, helper) {
        //Get the account list
        var skillsList = component.get("v.skillsList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        skillsList.splice(index, 1);
        //Set modified account list
        component.set("v.skillsList", skillsList);
    },
    
    addRowForRoles: function(component, event, helper) {
        //get the account List from component  
        var rolesAndRespo = component.get("v.rolesandRespoList");
        //Add New Account Record
        rolesAndRespo.push({
            'sobjectType': 'Roll_and_Responsibilities__c',
            'Type__c': '',
            'Rolls_and_Responsibilities_Master__c': '',
            
            
        });
        component.set("v.rolesandRespoList", rolesAndRespo);
        // alert('accountList   :::::'+accountList);
    },
    
    removeRolesRecord: function(component, event, helper) {
        //Get the account list
        var rolesAndRespo = component.get("v.rolesandRespoList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        rolesAndRespo.splice(index, 1);
        //Set modified account list
        component.set("v.rolesandRespoList", rolesAndRespo);
    },
})