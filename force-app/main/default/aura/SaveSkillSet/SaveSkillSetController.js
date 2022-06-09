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
        
        helper.getSkillset(component,event,helper);
        
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
        
        //To get Rolls And Responsibilities Picklist
        var action = component.get("c.getTypePicklistValues");
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
        $A.enqueueAction(action);
        
        
        
    },
    
    
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.showModal", true);
        //To get the selected picklist value
        var candProfile = event.getSource().get("v.value");
        var candprofile = component.get("v.candidateProfile");
        //alert('Name'+candprofile.Name);
        var jobApp = component.get("v.jobApplication");
        jobApp.push(candprofile.Name);
        component.set("v.jobApplication",jobApp);
        console.log(component.get("v.jobApplication"));
        
        
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
        
    },
    
    handleChange: function(component,event,helper){
        var getSelectedJob = component.find('select').get('v.value');
        console.log(getSelectedJob);
        var action = component.get("c.getJobPostingValues");
        
        var mapValue = component.get("v.candidateSkills");   
        console.log(JSON.stringify(mapValue));
        
        action.setParams({
            'jobId': getSelectedJob,
            'candSkills': JSON.stringify(mapValue)
            
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                var mapValue = new Map();
                mapValue = component.get("v.candidateSkills");
                
                console.log(JSON.stringify(mapValue));
                var skillMatch = false;
                for(var i=0; i<storeResponse.length;i++){
                    
                    //alert('Inside for>>'+Object.keys(mapValue).includes(storeResponse[i].Name));
                    //alert('Inside for>>'+Object.values(mapValue).includes(storeResponse[i].KTDO1__SkillSet_Experience__c));
                    
                    if(Object.keys(mapValue).includes(storeResponse[i].Name) && Object.values(mapValue).includes(storeResponse[i].KTDO1__SkillSet_Experience__c))
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
                    }
                    
                    // alert('Skill Exp>>'+storeResponse[i].KTDO1__SkillSet_Experience__c);
                    
                }
                
                if ( component.find("fuploader").get("v.files").length > 0) {
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
                
            }
        })
        $A.enqueueAction(action);
        
    },
    
    saveSkillandExp: function(component,event,helper)
    {
        if (component.find("fuploader").get("v.files").length > 0) {
            //alert('File Found ');
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
        
        var notice = component.get("v.candidateProfile.KTDO1__Notice_Period__c");
        
        component.set("v.candidateProfile.KTDO1__Notice_Period__c",action);
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
        
        var notice = component.get("v.candidateProfile.KTDO1__Industry__c");
        
        component.set("v.candidateProfile.KTDO1__Industry__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredRole :function(component){
        
        var action = component.get("v.selectedFunctionalArea");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.KTDO1__Functional_Area__c");
        
        component.set("v.candidateProfile.KTDO1__Functional_Area__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredDesignation :function(component){
        
        var action = component.get("v.selectedDesignation");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.KTDO1__Designation__c");
        
        component.set("v.candidateProfile.KTDO1__Designation__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredStream :function(component){
        
        var action = component.get("v.selectedStream");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.KTDO1__UG_Stream__c");
        
        component.set("v.candidateProfile.KTDO1__UG_Stream__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },
    
    preferredPGStream :function(component){
        
        var action = component.get("v.selectedPGStream");
        //alert('action'+action);
        
        var notice = component.get("v.candidateProfile.KTDO1__PG_Stream__c");
        
        component.set("v.candidateProfile.KTDO1__PG_Stream__c",action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
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
                console.log(res[i].KTDO1__Type__c);
                component.set("v.SearchUserKeyWord3",res[i].Name);   
            }
            
        }
        
    },
    
})