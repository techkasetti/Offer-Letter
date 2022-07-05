({
    doInit : function(component, event,helper,page) 
    {   
        // var action = component.get("c.getAccessToken");
        // action.setCallback(this, function (response) {
        //     var status = response.getState();
        //     if (status === "SUCCESS") {
        //         var accessToken = response.getReturnValue();
        //         alert('accessToken>>>'+accessToken);
        //         component.set("v.accessToken", accessToken);
        //     }
        // });
        // $A.enqueueAction(action);
        
        component.set("v.jobPostRecordId",'a038Z00000XIxjhQAD');
        
        if(component.get("v.jobPostRecordId")){
            helper.getJobPostForEdit(component,event,helper);
        }
        
        
        var action = component.get("c.getDepartmentPickListValues");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                
                var departmentList = component.set("v.departmentList", response.getReturnValue());
                //alert('departmentList>>>'+JSON.stringify(component.get("v.departmentList")));    
            }
            else if (state === 'ERROR') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": "Error Occured in getDepartmentPickListValues"
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
        
        //helper.getSkillsetHelper(component,event,helper);       
        
        var action = component.get("c.getJoiningInPickListValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test =component.set("v.listOfJoiningIn",response.getReturnValue());
                //alert('picklist>>'+JSON.stringify(component.get('v.listOfJoiningIn')));                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in getJoiningInPickListValues."
                });
                toastEvent.fire();  
            }
        })
        $A.enqueueAction(action);
        
        //teams
        var action = component.get("c.getTeams");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test = component.set("v.teamOptions",response.getReturnValue());
                //alert('list of team values>>'+JSON.stringify(component.get('v.teamOptions')));                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in getTeams."
                });
                toastEvent.fire();  
            }
        })
        $A.enqueueAction(action);
        
        //get 
        var action = component.get("c.getJobReqTypePicklist");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var test = component.set("v.jobTypeList",response.getReturnValue());
                //alert('picklist>>'+JSON.stringify(component.get('v.jobTypeList')));                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in getJobReqTypePicklist."
                });
                toastEvent.fire();  
            }
        })
        $A.enqueueAction(action);
        
    },
    
    backToHP : function(component, event, helper) {
        var urlString = window.location.href;
        var CommunityBaseURL = urlString.substring(0,urlString.indexOf("/one/"));
        window.location.replace(CommunityBaseURL+"/lightning/n/Home_Page");
    },
    
    getJobTypeOnChange: function (component,event,helper) {
        //alert(component.find('jobReqType').get('v.value'));
        component.set("v.jobReqType",component.find('jobReqType').get('v.value'));
    },
    
    removeSkillRecord: function (component,event,helper) {
        //Get the Skill list
        var skillsList = component.get("v.skillsList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from Skill list
        skillsList.splice(index, 1);
        //Set modified Skill list
        component.set("v.skillsList", skillsList);
    },
    
    removeDocRecord: function (component,event,helper) {
        //Get the Document list
        var docMasterList = component.get("v.docMasterList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from Document list
        docMasterList.splice(index, 1);
        //Set modified Document list
        component.set("v.docMasterList", docMasterList);
    },
    
    removeDocEditRecord: function (component,event,helper) {
        //Get the Document list
        var docMasterList = component.get("v.jobPostDocRecordId");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from Document list
        docMasterList.splice(index, 1);
        //Set modified Document list
        component.set("v.jobPostDocRecordId", docMasterList);
    },
    
    removeSkillEditRecord: function (component,event,helper) {
        //Get the Document list
        var docMasterList = component.get("v.jobPostSkillRecordId");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from Document list
        docMasterList.splice(index, 1);
        //Set modified Document list
        component.set("v.jobPostSkillRecordId", docMasterList);
    },
    
    removeUserRecord: function (component,event,helper) {
        //Get the User list
        var userList = component.get("v.userList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from User list
        userList.splice(index, 1);
        //Set modified User list
        component.set("v.userList", userList);
    },
    
    
    onPicklistChange : function(component, event, helper)
    {
        //var fieldName = event.getSource().get("v.fieldName") ; 
        var client =  event.getSource().get("v.value") ; 
        component.set("v.client", client);
    }, 
    
    
    addAnotherJob : function(component,event,helper){
        
        //var a = component.get('c.postJob');
        //$A.enqueueAction(a);
        //window.location.reload();
        //url redirect
        //window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
        
        var spinner = component.find('spinner');
        window.setTimeout(
            $A.getCallback(function() {
                $A.util.toggleClass(spinner, "slds-is-open");
            }), 5000
        );
        
        var client = component.get("v.client");
        var designation = component.find('designation').get('v.value');
        var noOfPositions = component.find('positions').get('v.value');
        var location = component.find('location').get('v.value');
        var skillobj = component.get("v.selectedSkillRecordClone");
        var minCTC = component.find('salary1').get('v.value');
        var maxCTC = component.find('salary2').get('v.value');
        var documents = JSON.stringify(component.get("v.selectedDocumentRecord"));
        var dueDateValue = component.get("v.selectedDate");
        var selectedTeam = component.get("v.teamName");
        var jobReqType = component.get("v.selectedJobType")
        var expSubPerDay = component.find('expSubPerDay').get('v.value');
        var referralAmt = component.find('referralAmt').get('v.value');
        
        
        //alert('dateValue>>'+dateValue);
        //alert('documents>>'+documents);
        //alert('minCTC>>'+minCTC+'<<<maxCTC>>'+maxCTC);
        // alert('skillobj'+JSON.stringify(skillobj));
        // alert('client>>'+client+'<<designation>>'+designation+'<<noOfPositions>>'+noOfPositions+'<<location>>'+location);
        //alert('selectedTeam>>'+selectedTeam);
        //alert('client>>'+client);
        //alert('jobReqType>>'+jobReqType);
        //alert('expSubPerDay>>'+expSubPerDay);
        
        if(!client)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "The Client Must Be Specified",
                type: "warning"
            });
            toastEvent.fire();
            return;
        }
        
        //Salary
        if((minCTC) && (maxCTC))
        {
            if(minCTC > maxCTC)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Warning",
                    message: "Salary Should Be In Correct Range",
                    type: "warning"
                });
                toastEvent.fire();
                return;
            }
        }
        else
        {
            minCTC = 0;
            maxCTC = 0;
        }
        
        if(!noOfPositions){
            noOfPositions = 0;
        }
        if(!designation){
            designation = null;
        }
        if(!location){
            location = null;
        }
        if(!expSubPerDay){
            expSubPerDay = 0;
        }
        if(!referralAmt){
            referralAmt = 0;
        }
        if(!jobReqType){
            jobReqType = "--None--";
        }
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(dueDateValue){
            if(dueDateValue < today){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Entered Date should be Greater Than today Date",
                    type: "Error"
                });
                toastEvent.fire();
                return;
            }
        }
        
        if(!selectedTeam){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                message: "The Team cannot be null",
                type: "Error"
            });
            toastEvent.fire();
            return;
        }
        
        
        
        
        var action = component.get("c.postingJob");
        action.setParams({
            'client': client ,
            'designation':  designation ,
            'noOfPositions': noOfPositions ,
            'location': location,
            'skillexp' : JSON.stringify(skillobj),
            'minCTC' :minCTC,
            'maxCTC' : maxCTC,
            'documents' : documents,
            'dueDate' : dueDateValue,
            'selectedTeam' : selectedTeam,
            'jobReqType' : jobReqType,
            'expSubPerDay' : expSubPerDay,
            'referralAmt' : referralAmt
        });
        //'userIds' : 
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Job Posting Created Successfully."
                });
                toastEvent.fire();
                
                helper.getSkillsetFromHelper(component,event,helper);
                
                //url redirect
                window.location.reload();
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Job Posting Insertion Failed."
                });
                toastEvent.fire();   
                $A.util.toggleClass(spinner, "slds-hide");
            }
        })
        $A.enqueueAction(action);
        
        $A.util.toggleClass(spinner, "slds-hide");
        
    },
    
    postJob : function(component,event,helper){
        var spinner = component.find('spinner');
        window.setTimeout(
            $A.getCallback(function() {
                $A.util.toggleClass(spinner, "slds-is-open");
            }), 5000
        );
        
        var client = component.get("v.client");
        var designation = component.find('designation').get('v.value');
        var noOfPositions = component.find('positions').get('v.value');
        var location = component.find('location').get('v.value');
        var skillobj = component.get("v.selectedSkillRecordClone");
        var minCTC = component.find('salary1').get('v.value');
        var maxCTC = component.find('salary2').get('v.value');
        var documents = JSON.stringify(component.get("v.selectedDocumentRecord"));
        var dueDateValue = component.get("v.selectedDate");
        var selectedTeam = component.get("v.teamName");
        var jobReqType = component.get("v.selectedJobType");
        var expSubPerDay = component.find('expSubPerDay').get('v.value');
        var referralAmt = component.find('referralAmt').get('v.value');
        
        
        //alert('dateValue>>'+dateValue);
        //alert('documents>>'+documents);
        //alert('minCTC>>'+minCTC+'<<<maxCTC>>'+maxCTC);
        // alert('skillobj'+JSON.stringify(skillobj));
        // alert('client>>'+client+'<<designation>>'+designation+'<<noOfPositions>>'+noOfPositions+'<<location>>'+location);
        //alert('selectedTeam>>'+selectedTeam);
        //alert('client>>'+client);
        //alert('jobReqType>>'+jobReqType);
        //alert('expSubPerDay>>'+expSubPerDay);
        
        if(!client)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "The Client Must Be Specified",
                type: "warning"
            });
            toastEvent.fire();
            return;
        }
        
        //Salary
        if((minCTC) && (maxCTC))
        {
            if(minCTC > maxCTC)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Warning",
                    message: "Salary Should Be In Correct Range",
                    type: "warning"
                });
                toastEvent.fire();
                return;
            }
        }
        else
        {
            minCTC = 0;
            maxCTC = 0;
        }
        
        if(!noOfPositions){
            noOfPositions = 0;
        }
        if(!designation){
            designation = null;
        }
        if(!location){
            location = null;
        }
        if(!expSubPerDay){
            expSubPerDay = 0;
        }
        if(!referralAmt){
            referralAmt = 0;
        }
        if(!jobReqType){
            jobReqType = "--None--";
        }
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(dueDateValue){
            if(dueDateValue < today){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Entered Date should be Greater Than today Date",
                    type: "Error"
                });
                toastEvent.fire();
                return;
            }
        }
        
        if(!selectedTeam){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                message: "The Team cannot be null",
                type: "Error"
            });
            toastEvent.fire();
            return;
        }
        
        
        
        
        var action = component.get("c.postingJob");
        action.setParams({
            'client': client ,
            'designation':  designation ,
            'noOfPositions': noOfPositions ,
            'location': location,
            'skillexp' : JSON.stringify(skillobj),
            'minCTC' :minCTC,
            'maxCTC' : maxCTC,
            'documents' : documents,
            'dueDate' : dueDateValue,
            'selectedTeam' : selectedTeam,
            'jobReqType' : jobReqType,
            'expSubPerDay' : expSubPerDay,
            'referralAmt' : referralAmt
        });
        //'userIds' : 
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Job Posting Created Successfully."
                });
                toastEvent.fire();
                
                helper.getSkillsetFromHelper(component,event,helper);
                
                //url redirect
                window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Job Posting Insertion Failed."
                });
                toastEvent.fire();   
                $A.util.toggleClass(spinner, "slds-hide");
            }
        })
        $A.enqueueAction(action);
        
        $A.util.toggleClass(spinner, "slds-hide");
        
    },
    
    
    onblur1 : function(component,event,helper){      
        //var forclose = component.find("searchRes1");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfProfileUserSearchRecords", null );
        var forclose = component.find("searchProfileUser");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    keyPressUserController1 : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchProfileUserKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and
        // call the helper
        // else close the lookup result List part.  
        if( getInputkeyWord.length > 0 ){            
            var forOpen = component.find("searchProfileUser");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchPreLocationHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfProfileUserSearchRecords", null );
            var forclose = component.find("searchProfileUser");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    
    
    handleUserEvent : function(component, event, helper) {
        var selectedUserrecordByEvent = event.getParam("recordProfileUserByEvent");
        //alert('selectedUserrecordByEvent>>'+selectedUserrecordByEvent);
        if(selectedUserrecordByEvent != null && selectedUserrecordByEvent != ""){
            var pushToSelectdUser = component.get("v.selectedProfileUserRecord")
            pushToSelectdUser.push(selectedUserrecordByEvent);
            component.set("v.selectedProfileUserRecord" , pushToSelectdUser);
            
            var selectedUser = component.get("v.selectedProfileUserRecord");
            //alert('v.selectedProfileUserRecord>>>>'+JSON.stringify(selectedUser));
            var selstr = selectedUser[0];
            //alert('selstr>>>'+JSON.stringify(selstr));
            var deletedskill = [];
            deletedskill = JSON.stringify(selstr).split("-");
            //alert('deletedskill>>>'+deletedskill);
            
            var forclose = component.find("lookupUser-pill1");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchProfileUser");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            component.set("v.SearchProfileUserKeyWord",null);
        }
        
    },
    
    onblurSkillsSet: function (component, event, helper) {
        component.set("v.listOfSkillsSearchRecords", null);
        var forclose = component.find("searchSkills");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    handleSkillEvent: function (component, event, helper) {
        //alert('handleSkillEvent');
        var selectedUserrecordByEvent = event.getParam("recordSkillsByEvent");
        //alert('selectedUserrecordByEvent>>>'+JSON.stringify(selectedUserrecordByEvent));
        
        component.set("v.experience",selectedUserrecordByEvent);
        var skill = component.get("v.experience");
        //alert('v.experience>>'+JSON.stringify(component.get("v.experience")));
        component.set("v.SearchSkillsKeyWord", skill.Name);
    },
    
    
    getskillOnChange: function (component, event, helper) {
        
        var exp = component.find('skillSelect').get('v.value');
        
        var skill = component.get("v.experience");
        var skillExp = skill.Name + '-' + exp;
        var selectedSkillRecordClone = component.get("v.selectedSkillRecordClone");
        //alert('selectedSkillRecordClone All>>'+JSON.stringify(selectedSkillRecordClone));
        selectedSkillRecordClone.push(skillExp);
        
        component.set("v.selectedSkillRecordClone", selectedSkillRecordClone);
        var forclose = component.find("lookupUser-pill");
        
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        
        
        var forclose = component.find("searchSkills");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var array = component.get("v.skillAndExp");
        //alert('skillExp'+skillExp);
        
        //alert(typeof(array));
        for (const key in skill) {
            if (Object.hasOwnProperty.call(skill, key)) {
                if (key == 'Name') {
                    const element = skill[key];
                    array.push(element);
                }
            }
        }
        array.push(exp);
        component.set("v.skillAndExp", array);
        
        component.set("v.SearchSkillsKeyWord",null);
        component.set("v.selectedSkillsetExp", null);
    },
    
    
    keyPressSkillController: function (component, event, helper) {
        var getInputkeyWord = component.get("v.SearchSkillsKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.  
        
        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchSkills");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchSkillHelper(component, event, getInputkeyWord);
        }
        else {
            component.set("v.listOfSkillsSearchRecords", null);
            var forclose = component.find("searchSkills");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    handleDocumentEvent : function(component, event, helper) {
        var selectedDocrecordByEvent = event.getParam("recordDocumentByEvent");
        //alert('selectedDocrecordByEvent>>'+selectedDocrecordByEvent);
        if(selectedDocrecordByEvent != null && selectedDocrecordByEvent != ""){
            var pushToSelectdUser = component.get("v.selectedDocumentRecord");
            pushToSelectdUser.push(selectedDocrecordByEvent);
            component.set("v.selectedDocumentRecord" , pushToSelectdUser);
            
            var selectedUser = component.get("v.selectedDocumentRecord");
            //alert('v.selectedDocumentRecord>>>>'+JSON.stringify(selectedUser));
            var selstr = selectedUser[0];
            //alert('selstr>>>'+JSON.stringify(selstr));
            var deletedskill = [];
            deletedskill = JSON.stringify(selstr).split("-");
            //alert('deletedskill>>>'+deletedskill);
            
            var forclose = component.find("lookupdoc-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchDocument");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            component.set("v.SearchDocumentKeyWord",null);
        }
        
    },
    
    
    keyPressDocumentController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchDocumentKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and
        // call the helper
        // else close the lookup result List part.  
        if( getInputkeyWord.length > 0 ){            
            var forOpen = component.find("searchDocument");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchDocumentHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfDocumentRecords", null );
            var forclose = component.find("searchDocument");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    onblurDocument : function(component,event,helper){      
        //var forclose = component.find("searchRes1");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfDocumentRecords", null );
        var forclose = component.find("searchDocument");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    addSkillRow: function(component, event, helper) {
        //get the skill List from component  
        var skillsList = component.get("v.skillsList");
        //Add New Skill Record
        skillsList.push({
            'sobjectType': 'Skill_Set_Experience__c',
            'Skill_Set__c': '',
            'Skill_Experience_Level__c': '',
        });
        component.set("v.skillsList", skillsList);
        // alert('skillsList>>>>'+skillsList);
    },
    
    addDocRow: function(component, event, helper) {
        //get the Document Master List from component  
        var docList = component.get("v.docMasterList");
        //Add New Document Master Record
        docList.push({
            'sobjectType': 'Job_Posting_Document__c',
            'Document_Master__c': ''
        });
        component.set("v.docMasterList", docList);
        //alert('docMasterList>>>'+JSON.stringify(component.get("v.docMasterList")));
    },
    
    addUserRow: function(component, event, helper) {
        //get the user list from component  
        var userList = component.get("v.userList");
        userList.push({
            'sobjectType': 'Job_Posting_Document__c',
            'CustomTeams__User__c': ''
        });
        component.set("v.userList", userList);
        //alert('userList>>>'+JSON.stringify(component.get("v.userList")));
    },
    
    
    postNewJob : function(component, event, helper) {
        
        var jobPostingfields = component.find('jobPostingFields').get('v.value');
        console.log('jobPostingfields>>'+JSON.stringify(jobPostingfields));
        var skillsList = component.get("v.skillsList");
        console.log('skillsList>>'+JSON.stringify(skillsList));
        var docMasterList = component.get("v.docMasterList");
        console.log('docMasterList>>'+JSON.stringify(docMasterList));
        console.log('docMasterList>>'+component.get("v.teamID"));
        
        jobPostingfields["Teams__c"]= component.get("v.teamID");
        component.find('jobPostingFields').set('v.value',jobPostingfields);
        
        var action = component.get("c.newJobPosting");
        action.setParams({
            "jobPostingfields" : jobPostingfields,
            "skillsList" : skillsList,
            "docMasterList" : docMasterList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Job Post Created Successfully.",
                    "variant": "Success"
                });
                toastEvent.fire();
                
                //url redirect
                var urlString = window.location.href;
                var CommunityBaseURL = urlString.substring(0,urlString.indexOf("/one/"));
                window.location.replace(CommunityBaseURL+"/lightning/n/Home_Page");
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in Job Post Format."
                });
                toastEvent.fire();  
            }
        })
        $A.enqueueAction(action);
    },
    
    //UPDATE JOB POSTING STARTS
    UpdateJob : function(component, event, helper) {
        var updateJobId = component.get("v.jobPostRecordId");
        
        var jobPostingfields = component.find('updateJobPostingFields').get('v.value');
        var skillsList = component.get("v.skillsList");
        var docMasterList = component.get("v.docMasterList");
        
         jobPostingfields["Teams__c"]= component.get("v.teamID");
         component.find('updateJobPostingFields').set('v.value',jobPostingfields);
        
        var action = component.get("c.updateJobPosting");
        action.setParams({
            "jobPostingfields" : jobPostingfields,
            "skillsList" : skillsList,
            "docMasterList" : docMasterList,
            "updateJobPosId" : updateJobId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Job Post Updated Successfully.",
                    "variant": "Success"
                });
                toastEvent.fire();
                
                //url redirect
                var urlString = window.location.href;
                var CommunityBaseURL = urlString.substring(0,urlString.indexOf("/one/"));
                //window.location.replace(CommunityBaseURL+"/lightning/n/Home_Page");
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in Job Post Format."
                });
                toastEvent.fire();   
                $A.util.toggleClass(spinner, "slds-hide");
            }
        })
        $A.enqueueAction(action);
    },
    //UPDATE JOB POSTING ENDS
    
    UploadGDriveFile: function (component, event, helper) {
        
        var uploadedDocId = event.getSource().get("v.name");
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles>>' + JSON.stringify(uploadedFiles));
        var attachmentId = uploadedFiles[0].documentId;
        
        var action = component.get("c.gdriveDocUpload");
        action.setParams({
            "attachmentId": attachmentId,
            "accessToken": component.get("v.accessToken"),
            "uploadedDocId": uploadedDocId
        });
        action.setCallback(this, function (response) {
            var status = response.getState();
            if (status === "SUCCESS") {
                var responseCode = response.getReturnValue();
                //alert('responseCode>>>'+responseCode);
                if (responseCode == '200') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "File Uploaded successfully."
                    });
                    toastEvent.fire();
                    //window.location.reload();
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There was some error in uploading."
                    });
                    toastEvent.fire();
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In gdriveDocUpload."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    handleAccountChange : function(component, event, helper) {        
        component.set("v.teamID", '');
        var lookupAccountId = event.getParam("value")[0];
        //alert('lookupAccountId>>'+lookupAccountId);
        
        var action = component.get("c.getTeamBasedOnAcc");
        action.setParams({   
            "account": lookupAccountId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.teamList",response.getReturnValue());
                //alert('teamMembersOptions>>'+JSON.stringify(response.getReturnValue()));                
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in getTeamBasedOnAcc."
                });
                toastEvent.fire();  
            }
        })
        $A.enqueueAction(action);
        
    },
    
    handleTeamChange : function(component, event, helper){
        //alert(event.getParam("value")[0]);
        //alert('SELECTED VALUE>>>'+component.find('select').get('v.value'));
        var teamMemlookupId = component.find('select').get('v.value');
        component.set("v.teamID",teamMemlookupId);
        
        var action = component.get("c.getTeamMembers");
        action.setParams({   
            "team": teamMemlookupId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
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
    
    
    
})