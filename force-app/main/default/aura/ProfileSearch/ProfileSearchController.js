({
    doInit: function (component, event, helper, page) {

        component.set("v.SearchUserKeyWord", "");

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
                    "title": "ERROR!",
                    "message": "Error Occured"
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);

        helper.getSkillset(component, event, helper);

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

        console.log(component.get("v.selectedUserRecordClone"));
        var selectedPill = component.get("v.selectedUserRecordClone");


        var array = component.get("v.skillAndExp");
        console.log(component.get("v.skillAndExp"));

        var selstr = selectedPill[0];

        var deletedskill = [];
        deletedskill = selstr.split("-");
        console.log(deletedskill);

        component.set("v.skillAndExp", deletedskill);
        var action = component.get("c.getCandidateProfile");
        console.log(component.get("c.getCandidateProfile"));

        action.setParams({

            "skillexp": JSON.stringify(deletedskill)


        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // alert("success");     
                var test = component.set("v.candidateProfile", response.getReturnValue());
                component.set("v.ShowCandidateProfile", true);
                console.log(component.get("v.candidateProfile"));
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

    handleComponentEvent: function (component, event, helper) {
        var selectedrecordByEvent = event.getParam("recordByEvent");

        var selectedUserrecordByEvent = event.getParam("recordUserByEvent");
        //alert('selectedUserrecordByEvent' +selectedUserrecordByEvent);

        component.set("v.experience", selectedUserrecordByEvent);
        var skill = component.get("v.experience");
        console.log(JSON.stringify(component.get("v.experience")));
        component.set("v.SearchUserKeyWord", skill.Name);
    },

    getSkillsetOnChange: function (component, event, helper) {
        var exp = component.find('mySelect').get('v.value');
        //alert('exp'+exp);

        var skill = component.get("v.experience");
        console.log(component.get("v.experience"));
        var skillExp = skill.Name + '-' + exp;

        // alert('skillExp'+skillExp);

        var selectedUserRecordClone = component.get("v.selectedUserRecordClone");
        //alert('selectedUserRecordClone All>>'+JSON.stringify(selectedUserRecordClone));
        console.log(component.get("v.selectedUserRecordClone"));
        selectedUserRecordClone.push(skillExp);

        component.set("v.selectedUserRecordClone", selectedUserRecordClone);
        console.log('Selected user clone' + component.get("v.selectedUserRecordClone"));
        var forclose = component.find("lookupUser-pill");

        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');



        var forclose = component.find("searchUserRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.SearchUserKeyWord", '');
        component.set("v.selectedSkillsetExp", '');
        component.set("v.selectedparentList", '');
        
        var array = component.get("v.skillAndExp");
        //console.log(array);

        //alert('skillExp'+skillExp);

        console.log(component.get("v.skillAndExp"));
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
        //alert('skil'+JSON.stringify(skill));
    },

    searchProfile: function(component, event, helper) {
        //component.set("v.showSpinner", true);
        var checkBox = event.getSource().get("v.value");
        //alert(event.getSource().get("v.value"));
        if (checkBox == true) {
            component.set("v.showSpinner", true);
        }

        var skillAndexp = component.get("v.skillAndExp");
        // alert(JSON.stringify(skillAndexp));
        console.log(component.get("v.skillAndExp"));

        var action = component.get("c.getCandidateProfile");
       // console.log(component.get("c.getCandidateProfile"));

        action.setParams({

            "skillexp": JSON.stringify(skillAndexp),
            "buttonSelected": checkBox


        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                if (response.getReturnValue().length != 0) {

                    component.set("v.showSpinner", false);
                    var test = component.set("v.candidateProfile", response.getReturnValue());
                    component.set("v.ShowCandidateProfile", true);
                    console.log(component.get("v.candidateProfile"));
                    component.set("v.ShowRadioButton", true);
                }
                else {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": "No Records Found."
                    });
                    toastEvent.fire();
                    component.set("v.ShowCandidateProfile", false);
                    component.set("v.showSpinner", false);
                }
            }
            else if (state === 'ERROR') {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": "Error Occured."
                });
                toastEvent.fire();
                component.set("v.showSpinner", false);
            }
        })
        $A.enqueueAction(action);

    },
})