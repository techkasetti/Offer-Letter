({
    doInit: function (component, event, helper) {
        //console.log(component.get('v.sectionObjects'))
        helper.onInit(component, event, helper);
        helper.onSelectChange(component, event, helper);
        // helper.getSkillSets(component, event, helper);
        helper.getDepartmentTypes(component, event, helper);
        helper.onFieldSetChange(component, event, helper, 'Basic_Information_FieldSet');
    },
    doSelectChange: function (component, event, helper) {
        helper.onSelectChange(component, event, helper);
    },
    doFieldSetChange: function (component, event, helper) {
        helper.onFieldSetChange(component, event, helper);
    },
    handlePress: function (component, event, helper) {
        var objectName = component.get('v.sObjectName');
        alert('handlePress>>' + JSON.stringify(objectName));
        helper.onUpserObject(component, event, helper);
    },
    onCheck: function (component, event, helper) {
        var fieldSetMember = event.getSource().get('v.value');
        alert('fieldSetMember >>>>>' + fieldSetMember);
        /* var fieldSetMemberlabel = event.getSource().get('v.label');
         alert('fieldSetMemberlabel ::::::'+fieldSetMemberlabel);*/
        var listOptions1 = [];
        var fieldSetmemberList1 = component.get("v.fieldSetmemberList1");
        if (JSON.stringify(fieldSetmemberList1).includes(fieldSetMember)) {
            console.log('sequence exist' + fieldSetmemberList1.length);
            for (let i = 0; i < fieldSetmemberList1.length; ++i) {
                // alert('fieldSetmemberList1 >>>> '+JSON.stringify(fieldSetmemberList1[i].value) +'    fieldSetMember >>>>>>'+fieldSetMember);
                if (JSON.stringify(fieldSetmemberList1[i].value) === "\"" + fieldSetMember + "\"") {
                    fieldSetmemberList1.splice(i, 1);
                }
            }
            // alert('fieldSetmemberList1 after filter :::::::'+JSON.stringify(fieldSetmemberList1));
            helper.onFieldSetChange(component, event, helper, fieldSetmemberList1);
        }
        else {

            fieldSetmemberList1.push({
                //label :fieldSetMemberlabel,
                value: fieldSetMember
            });
            //alert('fieldSetmemberList1 :::::::'+JSON.stringify(fieldSetmemberList1));
            helper.onFieldSetChange(component, event, helper, fieldSetmemberList1);
        }
    },
    handleMinRange: function (component, event, helper) {
        var minVals = event.getSource().get('v.value');
        alert('minVal >>>>>' + minVals);
        component.set('v.minval', minVals);
        alert('getminVal:::::' + component.get('v.minval'))
    },
    handleMaxRange: function (component, event, helper) {
        var maxVal = event.getSource().get('v.value');
        alert('maxVal >>>>>' + maxVal);
        var getMinVal = component.get('v.minval');
        alert('getMinVal ::::' + getMinVal);
        if (Number(maxVal) >= Number(getMinVal)) {
            component.set('v.maxval', maxVal);
            alert('getmaxVal:::::' + component.get('v.maxval'))
        }
        else {
            alert('Minimum Range is more than the maximum range');
        }
    },

    handleskillSetChange: function (component, event, helper) {
        alert(event.getParam('value'));
        component.set('v.SkillSetList', event.getParam('value'));
        //alert('getValue >>>>>>>'+component.get('v.SkillSetList'));
        var getSkillList = component.get('v.SkillSetList');
        // alert('getSkillList    >>>>>'+getSkillList);
        var getLogic = component.get('v.Name');
        var text = getSkillList[0];
        for (let i = 1; i < getSkillList.length; i++) {
            text += ' ' + getLogic + ' ' + getSkillList[i];
        }
        alert('text  ::::::' + text);
        component.set('v.text', text);
        helper.onUpserObject(component, event, helper, getSkillList);
    },
    ondepartChange1: function (component, event, helper) {
        var selectedDeparment = component.find('department1').get('v.value');
        //alert('selectedDeparment   >>>>>'+selectedDeparment);
        if (selectedDeparment != '') {
            helper.getSkillSets(component, event, helper, selectedDeparment);
            component.set('v.displaySkillSet', true);
        }
        else {
            component.set('v.displaySkillSet', false);
        }
    },
    handleClick: function (component, event, helper) {
        alert("You clicked: " + event.getSource().get("v.label"));
        var logicCondition = event.getSource().get("v.label");
        if (logicCondition == 'AND') {
            component.set('v.Name', 'OR');
        }
        else {
            component.set('v.Name', 'AND');
        }
        this.handleskillSetChange(component, event, helper);
    },
    addRow: function (component, event, helper) {
        //get the account List from component  
        var accountList = component.get("v.accountList");
        //Add New Account Record
        accountList.push({
            'sobjectType': 'Skill_Set_Experience__c',
            'Skill_Set__c': '',
            'Max_Experiance__c': '',
            'Min_Experiance__c': '',
            'Ratings__c': '',
            'Logic__c': '',
        });
        component.set("v.accountList", accountList);
    },

    removeRecord: function (component, event, helper) {
        //Get the account list
        var accountList = component.get("v.accountList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        accountList.splice(index, 1);
        //Set modified account list
        component.set("v.accountList", accountList);
    },

    saveAccounts: function (component, event, helper) {
        // alert('component.get("v.accountList") ::::'+JSON.stringify(component.get("v.accountList")));
        if (helper.validateAccountRecords(component, event)) {
            //Call Apex method and pass account list as a parameters
            //  alert('helper object>>'+JSON.stringify(component.get('v.sObjectName')));
            var action = component.get("c.searchProfiles");
            console.log('Data for search' + JSON.stringify(component.get('v.sObjectName')));
            console.log('Data for search>>>>>' + JSON.stringify(component.get('v.accountList')));
            action.setParams({
                "parentobjectData": JSON.stringify(component.get('v.sObjectName')),
                "objectData": JSON.stringify(component.get("v.accountList"))
            });
            action.setCallback(this, function (response) {
                //get response status 
                var state = response.getState();
                // alert('State ::::::'+state);
                if (state === "SUCCESS") {
                    //set empty account list
                    component.set("v.candidateProfile", response.getReturnValue());
                    alert('Profile search resulted successfully');
                }
            });
            $A.enqueueAction(action);
        }
    },
    basicSearch: function (component, event, helper) {
        helper.toggleAction(component, event, 'BasicSearch');
    },
    panelFour: function (component, event, helper) {
        helper.toggleAction(component, event, 'panelFour');
    },
})