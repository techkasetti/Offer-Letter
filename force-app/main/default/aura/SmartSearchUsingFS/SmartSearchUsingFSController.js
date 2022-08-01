({
    doInit: function (component, event, helper) {
        //console.log(component.get('v.sectionObjects'))
        
        helper.onInit(component, event, helper);
        helper.onSelectChange(component, event, helper);
        // helper.getSkillSets(component, event, helper);
        helper.getDepartmentTypes(component, event, helper);
        helper.onFieldSetChange(component, event, helper, 'Basic_Information_FieldSet');

        //to get Client Account picklist values
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
                    console.log(JSON.stringify(component.get("v.candidateProfile")));
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

    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        //alert('Modalll');
        component.set("v.showModal", true);
        //To get the selected picklist value
        var candProfile = event.getSource().get("v.value");
        console.log(candProfile);
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
        //alert('getSelectedJob>>>'+getSelectedJob);
       // var candSkills = component.get("v.candidateProfile");
        //console.log(candSkills);
        var candId = component.get("v.jobApplication");
        console.log(candId);
        var action = component.get("c.getJobPostingValues");
        
        //var mapValue = component.get("v.candidateSkills");   
   
        action.setParams({
            'jobId': getSelectedJob,
            'candSkills': candId[1]
            
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if(state === 'SUCCESS'){

                //Show that the job posting is in pause state if we get an empty value STARTS
               // alert('response>>'+response.getReturnValue());
                if(response.getReturnValue()){
                   
                    var candId = component.get("v.jobApplication");
                    console.log(candId);
                    candId.push(getSelectedJob);
                     component.set("v.jobApplication",candId);
                    console.log(candId);
                    helper.saveDetailsHelper(component, event, helper);
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

    //Getting Preview link of document 
    viewDocument: function(component, event, helper) {
        
        var candId = event.getSource().get("v.value");
        console.log(candId);
        var action = component.get("c.getCandidateResume");
        action.setParams({
            candId: candId
           });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //alert(state);
            if(state === 'SUCCESS'){
                var res= response.getReturnValue();
                 console.log(res);
                console.log(res.Resume__r.PreviewLink__c);
                //Redirecting to Google drive Resume with the returned link
                window.open(res.Resume__r.PreviewLink__c);
                        
            }
            else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error Occured in Opening the Document."
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action); 
    },

    editProfile: function(component, event, helper) {
        var candId = event.getSource().get("v.value");
        console.log(candId);
        alert('candId>>>'+candId);

        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:SaveSkillSet",
            componentAttributes: {
                candIdEdit: candId
            }
        });
        evt.fire();
    }
    


})