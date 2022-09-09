({

    doInit: function (component, event, helper, page) {

        

        var myPageRef = component.get("v.pageReference");
        var recordId = myPageRef.state.c__candDocParserId;
        if(recordId){
            component.set("v.candRecordId", recordId);
            console.log(component.get("v.candEditId"));
        }else {
            var candIdEdit = component.get("v.candIdEdit");
            //alert('candIdEdit>>>'+candIdEdit);
            console.log(candIdEdit);
            component.set("v.candRecordId", candIdEdit);
        }
         //---
         var recId = component.get("v.candRecordId");
         console.log("rec id"+recId);
         if(component.get("v.candRecordId")){
            console.log("recid in");

           // alert('recID');
             helper.getSkillForEdit(component,event,helper);
         }
       
        //---
        
       

        component.set("v.SearchUserKeyWord", "");
        //component.set("v.selectedUserRecord",[]);
        

        component.set("v.SearchUserKeyWord1", "");
        component.set("v.selectedLocationRecord", []);

        component.set("v.SearchUserKeyWord2", "");

        var action = component.get("c.getNoticePerPickListValues");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfNoticePeriod", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {

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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.parentList", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfIndustries", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfFunctionalAreas", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfDesignation", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfStreams", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfPGStreams", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                //alert("Success");
                component.set("v.listOfRatings", response.getReturnValue());
                console.log(response.getReturnValue());
                //alert('picklist>>'+component.get('v.skillSetList'));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log(result);
            if (state === 'SUCCESS') {
                for (let i = 0; i < result.length; i++) {
                    clients.push({ "value": result[i].Id, "label": result[i].Name });
                }
                component.set("v.clientList", clients);

                console.log(component.get("v.clientList"));

            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfEdTypes", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var test = component.set("v.listOfPGEdTypes", response.getReturnValue());
                // alert('picklist>>'+JSON.stringify(component.get('v.listOfNoticePeriod')));                
            }
            else if (state === 'ERROR') {
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



    openModel: function (component, event, helper) {
        // Set isModalOpen attribute to true    
        component.set("v.showSpinner", true);
        component.set("v.showModal", true);
        component.set("v.showSpinner", false);

        //To get the selected picklist value
        var candProfile = event.getSource().get("v.value");
        //var candprofile = component.get("v.candidateProfile");
        var candprofile = component.get("v.candiProfile")
        // alert('candprofile'+candprofile);
        var jobApp = component.get("v.jobApplication");
        jobApp.push(candprofile.Name);
        component.set("v.jobApplication", jobApp);
        console.log(component.get("v.jobApplication"));

        var skillsList = component.get("v.skillsList");
        console.log(skillsList);
        var action = component.get("c.getSkillName");

        action.setParams({

            'skillsList': skillsList

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                var skills = component.get("v.skillsListName");
                /*for(var i =0; i<storeResponse.size();i++){
                    skills.push(storeResponse[i]);
                    console.log(skills);
                }*/
                component.set("v.skillsListName", storeResponse);
                var skillsName = component.get("v.skillsListName");
                console.log(skillsName);
            }
            else if (state === 'ERROR') {
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

    hideModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showModal", false);
    },

    search: function (component, event, helper) {


        var expAnnualSalary1 = component.find('input7').get('v.value');
        var expAnnualSalary2 = component.find('input9').get('v.value');
        if (expAnnualSalary1 > expAnnualSalary2) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "Expected Annual Salary Should Be In Correct Range",
                type: "warning"
            });
            toastEvent.fire();
            return;
        }
        var exp = expAnnualSalary1 + ',' + expAnnualSalary2;

        //experience
        var minExperience = component.find('input4').get('v.value');
        var maxExperience = component.find('input5').get('v.value');
        if (minExperience > maxExperience) {
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
        if ((component.get("v.selectedNoticePeriod") == 'NULL') || (component.get("v.selectedNoticePeriod") == '')) {
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
            'curLocation': curLocation,
            'expCTC': exp,
            'minExperience': minExperience,
            'maxExperience': maxExperience,
            'noticePer': component.get("v.selectedNoticePeriod"),
            'skills': userList,
            'preLocation': preLocation
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var profile = JSON.stringify(response.getReturnValue());
                var test = component.set("v.candidateProfile", response.getReturnValue());
                component.set("v.ShowCandidateProfile", true);
            }
            else if (state === 'ERROR') {
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



    onblur: function (component, event, helper) {
        component.set("v.listOfSearchRecords", null);
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfUserSearchRecords", null);
        var forclose = component.find("searchUserRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

    },

    keyPressUserController: function (component, event, helper) {
        var getInputkeyWord = component.get("v.SearchUserKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.  

        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchUserRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchSkillHelper(component, event, getInputkeyWord);
        }
        else {
            component.set("v.listOfUserSearchRecords", null);
            var forclose = component.find("searchUserRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },

    clearUser: function (component, event, heplper) {
        var pillTarget = event.getSource().get('v.label');
        ///alert("pillTarget"+pillTarget);

        var getSelectdUserList = component.get("v.selectedUserRecordClone");
        //alert('getSelectdUserList'+getSelectdUserList);
        for (var i = 0; i < getSelectdUserList.length; i++) {
            if (getSelectdUserList[i] == pillTarget) {
                getSelectdUserList.splice(i, 1);

                component.set("v.selectedUserRecordClone", getSelectdUserList);
            }
        }
        component.set("v.SearchUserKeyWord", null);
        component.set("v.listOfUserSearchRecords", null);
        component.set("v.selectedSkillsetExp", null);
        component.set("v.selectedRating", null);
    },

    handleComponentEvent: function (component, event, helper) {
        // get the selected Account record from the COMPONETN event 

        //if(helper.experience(component))

        var selectedrecordByEvent = event.getParam("recordByEvent");

        var selectedUserrecordByEvent = event.getParam("recordUserByEvent");
        //alert('selectedUserrecordByEvent' +selectedUserrecordByEvent);
        //var sillexp = event.getParam("selectedexp");

        component.set("v.experience", selectedUserrecordByEvent);


        helper.searchSkillset(component, event, selectedUserrecordByEvent);

        var skill = component.get("v.experience");
        console.log(JSON.stringify(component.get("v.experience")));
        component.set("v.SearchUserKeyWord", skill.Name);
    },


    onblur1: function (component, event, helper) {
        component.set("v.listOfSearchRecords1", null);
        var forclose = component.find("searchRes1");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfLocationSearchRecords", null);
        var forclose = component.find("searchLocationRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

    },

    keyPressUserController1: function (component, event, helper) {
        var getInputkeyWord = component.get("v.SearchUserKeyWord1");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchLocationRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');

            helper.searchPreLocationHelper(component, event, getInputkeyWord);
        }
        else {
            component.set("v.listOfLocationSearchRecords", null);
            var forclose = component.find("searchLocationRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },

    clearUser1: function (component, event, heplper) {

        var userName = event.getSource().get("v.label");
        //alert(userName);
        var getSelectdUserList = component.get("v.selectedLocationRecord");
        //console.log("getSelectdUserList:"+getSelectdUserList);
        //var newUserList = [];
        for (var i = 0; i < getSelectdUserList.length; i++) {
            if (getSelectdUserList[i] == userName) {
                getSelectdUserList.splice(i, 1);
                component.set("v.selectedLocationRecord", getSelectdUserList);
            }
        }
        component.set("v.SearchUserKeyWord1", null);
        component.set("v.listOfLocationSearchRecords", null);


    },

    handleComponentEvent1: function (component, event, helper) {

        var selectedUserrecordByEvent = event.getParam("recordLocationByEvent");
        //alert('selectedUserrecordByEvent'+selectedUserrecordByEvent);
        if (selectedUserrecordByEvent != null && selectedUserrecordByEvent != "") {
            var pushToSelectdUser = component.get("v.selectedLocationRecord")
            pushToSelectdUser.push(selectedUserrecordByEvent);
            component.set("v.selectedLocationRecord", pushToSelectdUser);
            var forclose = component.find("lookupUser-pill1");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');

            var forclose = component.find("searchLocationRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            component.set("v.SearchUserKeyWord1", '');
        }

    },

    onGroup: function (cmp, evt) {
        var selected = evt.getSource().get("v.label");
        //alert('selected>>'+selected);

    },

    setSkillandExp: function (component, event, helper) {

        var exp = component.find('mySelect').get('v.value');
        console.log(exp);
        //alert('exp'+exp);

        var rating = component.find('selectRating').get('v.value');
        // alert(rating);

        var skill = component.get("v.experience");
        console.log(JSON.stringify(component.get("v.experience")));

        //skill.push(exp);
        //console.log(JSON.stringify(component.get("v.experience")));
        var skillExp = skill.Name + '-' + exp + '-' + rating;

        // alert('skillExp'+skillExp);

        var selectedUserRecordClone = component.get("v.selectedUserRecordClone");
        //alert('selectedUserRecordClone All>>'+JSON.stringify(selectedUserRecordClone));
        selectedUserRecordClone.push(skillExp);
        component.set("v.selectedUserRecordClone", selectedUserRecordClone);
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
                if (key == 'Name' || key == 'Id') {
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
        component.set("v.candidateSkills", skillsList);
        console.log(JSON.stringify(component.get("v.candidateSkills")));
        component.set("v.selectedRating", '');
        component.set("v.selectedSkillsetExp", '');
        component.set("v.selectedparentList", '');
        component.set("v.SearchUserKeyWord", '');
    },

    handleChange: function (component, event, helper) {

        var getSelectedJob = component.find('select').get('v.value');
        console.log(getSelectedJob);
        //var mapValue = component.get("v.skillsList");
        var candSkills = component.get("v.skillsListName");
        console.log(JSON.stringify(candSkills));

        /*var loc = component.find("locationForm").get("v.value");
        console.log(JSON.stringify(loc));*/

        var fields = component.find("candiForm").get("v.value");
        console.log(JSON.stringify(fields));
        //alert(JSON.stringify(fields));

        // fields["Billing_Location__c"]= JSON.stringify(loc);
        // component.find('candiForm').set('v.value',fields);
        // console.log(JSON.stringify(fields));

        var action = component.get("c.getJobPostingValues");

        //var mapValue = component.get("v.candidateSkills");   

        action.setParams({
            'jobId': getSelectedJob,
            'candSkills': JSON.stringify(candSkills)

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {

                //Show that the job posting is in pause state if we get an empty value STARTS
                // alert('response>>'+response.getReturnValue());
                if (response.getReturnValue()) {

                    helper.handleOnSubmitHelper(component, event, helper, fields);
                }
                else {
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
            else if (state === 'ERROR') {
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

    saveSkillandExp: function (component, event, helper) {
        if (component.find("fuploader").get("v.files").length > 0) {
            alert('File Found ');
            helper.uploadHelper(component, event, helper);
        } else {
            alert('Please Select a Valid File');
        }


    },

    handleFilesChange: function (component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },

    saveDetails: function (component, event, helper) {
        //To get the selected picklist value
        helper.saveDetailsHelper(component, event, helper);


    },


    datachange: function (component) {
        var value = component.get("v.candidateProfile");
        // alert("Inside"+value.Name);

    },

    preferredNoticePeriod: function (component) {

        var action = component.get("v.selectedNoticePeriod");
        //alert('action'+action);

        var notice = component.get("v.candidateProfile.Notice_Period__c");

        component.set("v.candidateProfile.Notice_Period__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    handleFilesChange: function (component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },

    preferredIndustry: function (component) {

        var action = component.get("v.selectedIndustry");
        //alert('action'+action);

        var notice = component.get("v.candidateProfile.Industry__c");

        component.set("v.candidateProfile.Industry__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    preferredRole: function (component) {

        var action = component.get("v.selectedFunctionalArea");
        //alert('action'+action);

        var notice = component.get("v.candidateProfile.Functional_Area__c");

        component.set("v.candidateProfile.Functional_Area__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    preferredDesignation: function (component) {

        var action = component.get("v.selectedDesignation");
        //alert('action'+action);

        var notice = component.get("v.candidateProfile.Designation__c");

        component.set("v.candidateProfile.Designation__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    preferredStream: function (component) {

        var action = component.get("v.selectedStream");
        //alert('action'+action);

        var notice = component.get("v.candidateProfile.UG_Stream__c");

        component.set("v.candidateProfile.UG_Stream__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    preferredPGStream: function (component) {

        var action = component.get("v.selectedPGStream");
        //alert('action'+action);

        var notice = component.get("v.candidateProfile.PG_Stream__c");

        component.set("v.candidateProfile.PG_Stream__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    clientSelected: function (component, event, helper) {
        var clientId = component.find('selectClient').get('v.value');
        //alert(clientId);
        component.set("v.jobPostingList", '');
        var array = component.get("v.jobPostingList");

        console.log(component.get("v.jobPostingList"));

        var action = component.get("c.getJobPostingPickListValues");

        action.setParams({
            clientId: clientId


        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var res = response.getReturnValue();

            if (state === 'SUCCESS') {

                for (let i = 0; i < res.length; i++) {
                    array.push({ "value": res[i].Id, "label": res[i].Name });
                }

                component.set("v.jobPostingList", array);

                //console.log(component.get("v.jobPostingList"));       
            }
            else if (state === 'ERROR') {
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

    onblur2: function (component, event, helper) {
        component.set("v.listOfSearchRecords", null);
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfUserSearchRecords", null);
        var forclose = component.find("searchUserRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

    },
    openSingleFile: function (cmp, event, helper) {
        $A.get('e.lightning:openFiles').fire({
            recordIds: ['0688Z00000QX10xQAD']
        });
    },

    keyPressUserController2: function (component, event, helper) {
        var getInputkeyWord = component.get("v.SearchUserKeyWord3");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.  

        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchRollsAndRespRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchRollsAndResponsibilitiesHelper(component, event, getInputkeyWord);
        }
        else {
            component.set("v.listOfRollsAndResponsibilitiesRecords", null);
            var forclose = component.find("searchRollsAndRespRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },

    handleRollsComponentEvent: function (component, event, helper) {

        var selectedUserrecordByEvent = event.getParam("recordRollsAndRespByEvent");
        console.log(JSON.stringify(selectedUserrecordByEvent));
        if (selectedUserrecordByEvent != null && selectedUserrecordByEvent != "") {
            var pushToSelectdUser = component.get("v.selectedRollsAndRespRecord")
            pushToSelectdUser.push(selectedUserrecordByEvent);
            console.log(JSON.stringify(pushToSelectdUser));
            component.set("v.selectedRollsAndRespRecord", pushToSelectdUser);
            var forclose = component.find("lookupUser-pill2");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');

            var forclose = component.find("searchRollsAndRespRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            console.log(component.get("v.selectedRollsAndRespRecord"));
            var res = component.get("v.selectedRollsAndRespRecord")
            for (var i = 0; i < res.length; i++) {
                console.log(res[i].Type__c);
                component.set("v.SearchUserKeyWord3", res[i].Name);
            }

        }
        component.set("v.SearchUserKeyWord3", '');

    },

    preferredEdType: function (component) {

        var action = component.get("v.selectedEdType");
        //alert('action'+action);

        var Type = component.get("v.candidateProfile.UG_Education_Type__c");

        component.set("v.candidateProfile.UG_Education_Type__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    preferredPGEdType: function (component) {

        var action = component.get("v.selectedPGEdType");
        //alert('action'+action);

        var Type = component.get("v.candidateProfile.PG_Education_Type__c");

        component.set("v.candidateProfile.PG_Education_Type__c", action);
        //console.log(JSON.stringify(component.get("v.candidateProfile")));
    },

    handleOnSubmit: function (component, event, helper) {
///---------

//helper.ValidateName(component, event, helper);


 
   
///---------
        /* var loc = component.find("locationForm").get("v.value");
         console.log(JSON.stringify(loc));*/
        // alert(component.get("v.candDocParserId"));
         var candidateId = component.get("v.candDocParserId");

        var fields = component.find('accForm1').get('v.value');

        console.log(JSON.stringify(fields));
        //console.log(JSON.stringify(fields.Id));
        if(candidateId){
            fields["Id"]= candidateId;
            component.find('accForm1').set('v.value',fields);
            console.log(JSON.stringify(fields));
    
        }
        //  fields["Billing_Location__c"]= JSON.stringify(loc);
        // component.find('accForm1').set('v.value',fields);
        // console.log(JSON.stringify(fields));
//----------
var emailval =component.find('emailValidation');
var value = emailval.get("v.value");
var emailRegex=/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
var validatedata = true;
console.log('email2');

if(value==null){
    console.log('email if');
    validatedata = false;
    var toastEvent=$A.get("e.force:showToast");
    toastEvent.setParams({
        title:'ERROR!',
        message:'Email is Empty',
        type:'error',
        mode:'pester'

    });
    toastEvent.fire();

}
else if (!value.match(emailRegex))
{
    validatedata=false;

    console.log('email else if');
    var toastEvent=$A.get("e.force:showToast");
    toastEvent.setParams({
        title:'ERROR!',
        message:'Enter Valid Email',
        type:'error',
        mode:'pester'

    });
    toastEvent.fire();


}

else{
    console.log('email else');
}
    //Validation for Name
   
    var nameValidation = component.find('nameValidation');
    var value = nameValidation.get("v.value");
    var rexName = /^[a-zA-Z\s]*$/;  
    console.log(' name');
    
 if( value ==null){
    validatedata=false;

    console.log('inside if name');
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
    title: "ERROR!",
    message: " Candidate Name is Empty .",
    duration:' 5000',
    type: "error",
    mode: 'pester'
});
    toastEvent.fire();
}
     else if (!value.match(rexName)) {
        validatedata=false;

         console.log('inside if name');
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
          title: "ERROR!",
          message: " Candidate Name Should be alphabetic characters .",
          duration:' 5000',
          type: "error",
          mode: 'pester'
});
          toastEvent.fire();
//component.set("v.errors",[{message:"Invalid Phone No: " + value}]);
    }
   


   // Validation for Phone Number
  //validatePhoneNo : function(component, event, helper) {
    console.log('Hello phone');
    var phoneValidation = component.find('phoneValidation');
    var value1 = phoneValidation.get("v.value");
    console.log(value);
  //  alert(value);
          if (isNaN(value1)) {
            validatedata=false;

            console.log('inside if phone');
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
             title: "ERROR!",
             message: " Invalid Phone number.",
             duration:' 5000',
             type: "error",
             mode: 'pester'
    });
    toastEvent.fire();
   // component.set("v.errors",[{message:"Invalid Phone No: " + value}]);
        }
        else if ( value1.length !=10){ 
            validatedata=false;

            console.log('else if phone');
            var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
             title: "ERROR!",
             message: " Invalid Phone number pattern.",
             duration:' 5000',
             type: "error",
             mode: 'pester'
    });
    toastEvent.fire();
         } else {
              console.log('inside else phone');
             // phoneValidation.set("v.errors",null);
              console.log('inside else after phone');
             }
 //Current Location
         var currLocValidation = component.find('currLocValidation');
         var value =currLocValidation.get("v.value");
         var regexcurr =/^[a-zA-Z]+$/;
         if(value == null){
            validatedata = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title:"ERROR!",
                message:"Current Location is Empty",
                type:"error",
                duration:"5000",
                mode:"pester"
            });
            toastEvent.fire();
         }
         else if(!value.match(regexcurr)){
            validatedata = false;
            var toastEvent =$A.get("e.force:showToast");
            toastEvent.setParams({
                title:"ERROR!",
                message:"Current Location Should be alphabetic characters .",
                type:"error",
                duration:"5000",
                mode:"pester"
            });
            toastEvent.fire();

         }
         else{
            console.log('current Location');
         }
// Validation for Adhaar Number
         var adhaarValidation = component.find('adhaarValidation');
         var value = adhaarValidation.get("v.value"); 
         if (isNaN(value)) {
            validatedata=false;

            console.log('inside if adhaar');
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
             title: "ERROR!",
             message: " Invalid Adhaar number.",
             duration:' 5000',
             type: "error",
             mode: 'pester'
    });
    toastEvent.fire();
   // component.set("v.errors",[{message:"Invalid Phone No: " + value}]);
        }  else if ( value.length !=12){ 
            validatedata=false;

            var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
             title: "ERROR!",
             message: " Adhaar Number should be 12 digits.",
             duration:' 5000',
             type: "error",
             mode: 'pester'
    });
    toastEvent.fire();
         } else {
            console.log('inside else');
           // adhaarValidation.set("v.errors",null);
            console.log('inside else after adhaar');
           } 
// Validation for PanNumber
        var panValidation = component.find('panValidation');
        var value = panValidation.get("v.value"); 
        var panPattern = /[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
        
        console.log('pan entered :-'+value);
        if(value==null){
            validatedata=false;
            console.log('inside if Pan');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title: "ERROR!",
            message: " Invalid Pan number empty.",
            duration:' 5000',
            type: "error",
            mode: 'pester'
   });
            toastEvent.fire();

        }
         else  if (!value.match(panPattern)) {
            validatedata=false;
              console.log('inside if Pan');
               var toastEvent = $A.get("e.force:showToast");
               toastEvent.setParams({
               title: "ERROR!",
               message: " Invalid Pan number.",
               duration:' 5000',
               type: "error",
               mode: 'pester'
      });
                   toastEvent.fire();
          } 
          else{
            console.log(' inside else');
          }
     //Pteferred Location
         console.log('outside pre');
         var preLocValidation = component.find('preLocValidation') ;
         var value =preLocValidation.get("v.value");
         if(value == null){
            console.log('loc if');
            validatedata = false;
            var toastEvent =$A.get("e.force:showToast");
            toastEvent.setParams({
                title:"ERROR!",
                message:"Minimum one Preferred Location is Required",
                type:"error",
                duration:'5000',
                mode:"pester"
            });
            toastEvent.fire();

         }
         else{
            console.log('location selected');
         }
     //resumeValidation
        //  var resumeValidation =component.find('resumeValidation');
        //  var value = resumeValidation.get("v.value");
        // // var uploadvalidate =component.get("v.uploadValidate")
        //  console.log('resumr value '+value);
        //  if(value == null)
           
        //  {   console.log('file');
        // // validatedata=false;
        //         var toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({
        //         title:"ERROR!",
        //         message:"File is mandaroary to upload",
        //         duration:'5000',
        //         type:"error",
        //         mode:'pester'

        //     });
        //     toastEvent.fire();
        //  } 
        //  else{
        //     console.log('file upload');
        //  }  

         //UG
        //  var streamValidation = component.find('tabs');
        //  var value = streamValidation.get("v.value");
        //  console.log('stream');
        //  if(value == null){
        //     console.log('if strean');
        //     // validatedata=false;
            
        //     var toastEvent = $A.get("e.force:showToast");
           
        //     toastEvent.setParams({
        //         title:"Info",
        //         message:"UG Qualification is required",
        //         type:"Info",
        //         mode:"dismissible"
        //     });
        
        //     console.log('strean fire')
        //     toastEvent.fire();
        //  }
        //  else{
        //     console.log('true');
        //  }
   // Stream      
         var streamValidation = component.find('streamValidation');
         var value = streamValidation.get("v.value");
         console.log('stream');
         if(value == null){
            console.log('if strean');
             validatedata=false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title:"ERROR!",
                message:"UG Stream is required",
                type:"error",
                mode:"pester"
            });
            console.log('strean fire')
            toastEvent.fire();
         }
         else{
            console.log('true');
         }
         var InstituteNameValidation =component.find('InstituteNameValidation');
         var value = InstituteNameValidation.get("v.value");
         if(value == null){
             validatedata=false;
            var toastEvent=$A.get("e.force:showToast");
            toastEvent.setParams({
                title:"ERROR!",
                message:" UG Institute Name is required",
                type:"error",
                mode:"pester"
            });
            toastEvent.fire();
            
         }

    //Education Type    
         var educationValidation = component.find('educationValidation');
         var value = educationValidation.get("v.value");
         if(value == null){
             validatedata=false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title:"ERROR!",
            message:"UG Education Type is Required",
            type:"error",
            mode:"pester"

            });
            console.log('fire type')

            toastEvent.fire();
         }
//Year of Graduation
         var FromYearValidation = component.find('FromYearValidation');
         var value = FromYearValidation.get("v.value");
         console.log('to');
         if(value == null){

            console.log('if year');

             validatedata=false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title:"ERROR!",
            message:" Graduation starting Year is Required",
            type:"error",
            mode:"pester"

            });
            console.log('fire to');


            toastEvent.fire();
         }
         else{
            console.log('else to');
         }

         var ToYearValidation = component.find('ToYearValidation');
         var value = ToYearValidation.get("v.value");
         console.log('from');
         if(value == null){

            console.log('if frm');

             validatedata=false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title:"ERROR!",
            message:"Graduation Completion Year is Required",
            type:"error",
            mode:"pester"

            });
            console.log('fire from');


            toastEvent.fire();
         }
         else{
            console.log('else from');
         }

         
         if(component.get("v.viewButton")){
            validatedata = true;
            console.log('Resume Uploaded');
        }else{
            validatedata = false;
            console.log('Resume Not Uploaded else block');
            var msg = "Please Upload the Resume !";
            helper.errorToastMessage(component, event, helper,msg);
         }



//----------


if(validatedata==true){
    console.log('handler');

        helper.handleOnSubmitHelper(component, event, helper, fields);
}

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

    addRow: function (component, event, helper) {
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

    removeRecord: function (component, event, helper) {
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

    addRowForRoles: function (component, event, helper) {
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

    removeRolesRecord: function (component, event, helper) {
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
    //----------
    // handleEmail : function(component, event, handler){
    //     console.log('email');

       

    // },
    ///---------

    //Upload File to Google Drive
    UploadGDriveFile: function (component, event, helper) {

        // helper.getAccessToken(component, event, helper);
        //Get Access Token
        
        var uploadedDocId = event.getSource().get("v.name");
        console.log('uploadedFiles>>' + JSON.stringify(uploadedDocId));
        var uploadedFiles = event.getParam("files");       
        var attachmentId = uploadedFiles[0].documentId;
        
        console.log('on iupload finish');
        var action = component.get("c.gdriveDocUpload");
        action.setParams({
            "candidateName":'Resume',
            "attachmentId": attachmentId,
            "uploadedDocId": uploadedDocId,
        });
        console.log('Param set');
        action.setCallback(this, function (response) {
            var status = response.getState();
            console.log('Return response');
            console.log(status);
            if (status === "SUCCESS") {
                var responseCode = response.getReturnValue();
                console.log(response.getReturnValue());
                var res = responseCode.split("#");
                console.log(res);
                helper.getPreviewLink(component, event, helper,res[1]);
                component.set("v.viewButtonActive", false);
               // component.get("v.uploadValidate")
                // alert('responseCode>>>' + responseCode);
                if (res[0] == '200') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "File Uploaded successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.lightning:openFiles').fire({
                        recordIds: [documentId]
                        });
                   // window.location.reload();
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There was some error in uploading file to Google Drive."
                    });
                    toastEvent.fire();
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in file Upload."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

        component.set("v.isModalOpen", true);

    },

    viewButton :  function (component, event, helper,resumeId) {
        console.log('viewbotton');
           // helper.getPreviewLink(component, event, helper, resumeId);
           var action =component.get("c.getPreviewLink");
           console.log('inside get preview link2');
          
           window.open(component.get("v.uploadedFileLink"));
          
           
    },
    //---
    UpdateJob : function(component,event,helper){
        
        helper.dltSkillForEdit(component,event);

        console.log(component.get("v.candRecordId"));
        var candidateId = component.get("v.candRecordId");
        //alert('id >>>'+candidateId);

        var fields = component.find('updatePro').get('v.value');

        console.log('fields'+JSON.stringify(fields));
        //console.log(JSON.stringify(fields.Id));
        if(candidateId){
           fields["Id"]= candidateId;
           component.find('updatePro').set('v.value',fields);
           console.log('fields>'+JSON.stringify(fields));
   
       }
    var skillsList = component.get("v.skillsList");
    console.log(skillsList);
    //alert('skillsList>>'+skillsList);
   // alert('skillsList>>'+JSON.stringify(skillsList));


    var rolesAndRespo = component.get("v.rolesandRespoList");
    console.log(rolesAndRespo);
    //alert('rolesAndRespo>>'+rolesAndRespo);

    var action = component.get("c.updateCandidateProfile");
    console.log('before action');

    action.setParams({
        "candFields": fields,
        "skills": skillsList,
        "rolesAndResp": rolesAndRespo,
        "updateCandiDateId":candidateId
    });
    console.log('after action');
    action.setCallback(this, function (response) {
        //get response status 
        var state = response.getState();
        console.log(' action'+state);
        if (state === "SUCCESS") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success",
                "message": "Profile updated.",
                "type":'success'
            });
            toastEvent.fire(); 
             //url redirect
             var urlString = window.location.href;
             var CommunityBaseURL = urlString.substring(0,urlString.indexOf("/one/"));
             window.location.replace(CommunityBaseURL+"/lightning/n/Home_Page");

        }
        else if (state ==='ERROR'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Error in update."
            });
            toastEvent.fire(); 
        }
           
            });
            $A.enqueueAction(action);

            
              
                       

    },
    removeEditRecord : function(component,event,helper){
        //helper.dltSkillForEdit(component,event);

         //Get the Document list
         var skillList = component.get("v.SkillEditRecordId");
         console.log('skillList>>>'+skillList);
         //Get the target object
         var selectedItem = event.currentTarget;
         console.log('selectedItem>>>'+selectedItem);
        // alert('selectedItem>>>'+selectedItem);


         //Get the selected item index
         var index = selectedItem.dataset.record;
         console.log('index>>>'+index);
         //Remove single record from Document list
        var delSkill = component.get("v.deleteSkill");
        console.log( 'deleteSkill>>'+delSkill);
        console.log('sli'+skillList[index]); 
        delSkill.push(skillList[index]) ;
        
        component.set("v.deleteSkill",delSkill);
        console.log('get>'+component.get("v.deleteSkill"))
         skillList.splice(index,1);
         console.log('After Splice skillList>>>'+skillList);

         //Set modified Document list
         component.set("v.SkillEditRecordId", skillList);

         var AfterSkillList = component.get("v.SkillEditRecordId");
         console.log('AfterSkillList>>>'+AfterSkillList);

    },
    removeRolesAndResRecord: function (component,event,helper) {
        //alert('in');
        helper.dlteditRoll(component,event);
        //Get the Document list
        var rolesndRes = component.get("v.roleAndResRecordId");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from Document list
        rolesndRes.splice(index, 1);
        //Set modified Document list
        component.set("v.roleAndResRecordId", rolesndRes);
        //alert('dlt');
    },
    //---

   
       
  /*     
 validatePhoneNo : function(component, event, helper) {
        console.log('Hello');
        var phoneValidation = component.find('phoneValidation');
        var value = phoneValidation.get("v.value");
       console.log(value);
      //  alert(value);
              if (  isNaN(value) ) {
                console.log('inside if');
                component.set("v.errors",[{message:"Invalid Phone No: " + value}]);
            } else {
                  console.log('inside else');
                  component.set("v.errors",null);
                  console.log('inside else after');
                
               
              }
       },


        ValidateAdhaar : function(component, event, helper) {
        console.log('Hello');
        var inputCmp = component.find('adhaarValidation');
        var value = inputCmp.get("v.value");
        console.log('Step 2');
              if ( value.length >12|| isNaN(value) ) {
                console.log('inside if');
                component.set("v.errors", [{message:"Invalid Adhaar No: " + value}]);
            } else {
                  console.log('inside else');
                  component.set("v.errors", null);
                  console.log('inside else after');
                
               
              }
       },

        ValidatePan : function(component, event, helper) {
        console.log('Hello');
        var inputCmp = component.find('PanValidation');
        var value = inputCmp.get("v.value");
        var patt = /[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
        console.log('Step 2');
              if ( !value.match(patt)) {
                //--------
                 inputCmp.setCustomValidity("Enter valid Pan number");
            inputCmp.reportValidity();
            //------
                console.log('inside if');
                component.set("v.errors", [{message:"Invalid Pan No: " + value}]);
            } else {
                  console.log('inside else');
                  component.set("v.errors", null);
                  console.log('inside else after');
                
               
              }
       },
      
        
       ValidatePan : function(component, event, helper) {
        console.log('Hello');
        var inputCmp = component.find('panValidation');
        var value = inputCmp.get("v.value");
        var patt = /[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
        console.log('Step 2');
              if ( !value.match(patt)) {
               
            //------
                console.log('inside if');
                component.set("v.errors", [{message:"Invalid Pan No: " + value}]);
            } else {
                  console.log('inside else');
                  component.set("v.errors", null);
                  console.log('inside else after');
                
               
              }
       },
       */
      
})