({
    doInit: function (component, event, helper, page) {
        var jobPost = component.get("v.jobApplication");
        console.log(jobPost);
        var action = component.get("v.JobAppdetails");
        console.log(component.get("v.JobAppdetails"));


        var action = component.get("c.hideProfileStatus");

        action.setCallback(this, function (response) {
            var state = response.getState();
            //alert(state);
            if (state === 'SUCCESS') {
                var list = response.getReturnValue();
                //component.set("v.contactList", list);
                //alert(JSON.stringify(component.get("v.contactList")));
                //alert(list);
                if (list) {
                    component.set("v.ShowStatusAction", true);
                } else {
                    component.set("v.ShowStatusAction", true);

                    component.set("v.disableButton", true);

                }
            }
            else if (state === 'ERROR') {
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                alert('Error Occured');
            }
        })
        $A.enqueueAction(action);
    },

    toggle: function (component, event, helper) {
       // alert('toggle');

        var items = component.get("v.jobApplication"); 
        //alert('items ::'+JSON.stringify(items));
        console.log(JSON.stringify(items));
        var chevronright = component.find('chevronright');
        var chevrondown = component.find('chevrondown');

        $A.util.toggleClass(chevronright, 'slds-hide');
        $A.util.toggleClass(chevrondown, 'slds-hide');
        var getAttributeValue = component.get("v.checkThis");
        if (getAttributeValue == true) {
            //alert('true');


            component.set("v.checkThis", false);
            component.set('v.expanded', true);
            items.expanded = true;
            component.set("v.tablesize", true);

        }
        else {
            //alert('else');
            component.set("v.checkThis", true);
            component.set('v.expanded', false);
            items.expanded = false;
            component.set("v.tablesize", false);
        }
        component.set("v.jobApplication", items);
       // alert(JSON.stringify(component.get('v.jobApplication')));
    },
    handleClick: function (component, event, helper) {
        var buttonType = event.getSource().get("v.label");
        //alert('buttonType ::'+buttonType);
        if (buttonType == 'Interview Cleared') {
            component.set("v.ShowUploadDocuments", true);


        } else if (buttonType == 'On Interview Process') {
            var items = component.get("v.jobApplication");
            console.log(JSON.stringify(component.get("v.jobApplication")));
            var jobposting = JSON.stringify(component.get("v.jobApplication"));
            //alert(jobposting);

            var obj = JSON.parse(jobposting);
            console.log(obj);
            console.log(obj.JobAppication.Job_Posting__c);
            component.set("v.ShowInterviewScheduled", true);
            var pickvar = component.get("c.getContact");
            pickvar.setParams({
                'jobId': obj.JobAppication.Job_Posting__c


            });
            pickvar.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var list = response.getReturnValue();
                    component.set("v.contactList", list);
                    //alert(JSON.stringify(component.get("v.contactList")));
                }
                else if (state === 'ERROR') {
                    //var list = response.getReturnValue();
                    //component.set("v.picvalue", list);
                    alert('ERROR OCCURED.');
                }
            })
            $A.enqueueAction(pickvar);
        }
        else if (buttonType == 'Lead Approved') {

            component.set("v.ShowResubmissionButton", true);
        }
        else if (buttonType == 'Offer Letter') {
            component.set("v.ShowConfirmationMessage", true);

        }

        var buttonTypeId = event.getSource().get("v.value");
        // alert('buttonTypeId ::'+buttonTypeId);
        helper.handleClickHelper(component, event, helper, buttonType, buttonTypeId);
    },
    handleViewDocuments: function (component, event, helper) {

        var recType = event.getSource().get("v.value");
        component.set("v.recordId", recType);
        component.set("v.viewDocument", true);
    },
    hideModel: function (component, event, helper) {
        component.set("v.viewDocument", false);
    },
    handleChangemin: function (cmp, event) {
        alert(event.getSource().get("v.value"));
    },
    handleChangemax: function (cmp, event) {
        alert(event.getSource().get("v.value"));
    },
    handleUpload: function (component, event, helper) {
        var batchId = event.getSource().get("v.value");
        //alert('batchId>>'+JSON.stringify(batchId));
        console.log(JSON.stringify(batchId));
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:DocumentUpload",

            componentAttributes: {
                batchId: JSON.stringify(batchId)
            }

        });
        evt.fire();
    },

    hideModel1: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.ShowInterviewScheduled", false);
    },

    hideModelOfferLetter: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.ShowConfirmationMessage", false);
    },

    handleSchedule: function (component, event, helper) {
        var items = component.get("v.POList");
        console.log(JSON.stringify(component.get("v.POList")));
        var jobposting = JSON.stringify(component.get("v.POList"));
        //alert(jobposting);

        var obj = JSON.parse(jobposting);
        console.log(obj);
        console.log(obj.JobAppication.Id);
        var save_action = component.get("c.setL1InterviewScheduled");
        save_action.setParams({
            'jobAppId': obj.JobAppication.Id


        });
        save_action.setCallback(this, function (response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();

                // set searchResult list with return value from server.
                //component.set("v.candidateProfile", storeResponse);
                //alert('storeResponse>>>'+JSON.stringify(component.get("v.candidateProfile")));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: "Interview Scheduled Successfully!!!",
                    type: "Success"
                });
                toastEvent.fire();
                //url redirect
                window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
            }
            else if (state === 'ERROR') {
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Interview Schedule Failed!!!",
                    type: "Error"
                });
                toastEvent.fire();

            }

        });
        $A.enqueueAction(save_action);
    },

    onChange: function (component, event) {
        var recName = event.getSource().get("v.value");
        //alert(recName);

        var record = component.get("v.contactList");
        //console.log(JSON.stringify(component.get("v.contactList")));
        var contactSelected;
        record.forEach(element => {
            if (recName == element.Name) {
                contactSelected = element;
                component.set("v.contactSelected", contactSelected);
            }
        });
    },

    /*handleComments: function(component,event){
        component.set("v.addComments", true);
    },*/

    hideModel2: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.ShowResumissionModal", false);
    },

    /*saveComments: function(component, event, helper) {
        var candName = event.getSource().get("v.value");
        console.log(JSON.stringify(candName));
        //alert(candName.JobAppication.Id);
        var comment = component.get("v.comments");
        console.log(JSON.stringify(component.get("v.comments")));
        
        var action = component.get("c.saveComment");
    
        action.setParams({ 
            'appId':candName.JobAppication.Id,
            'comment':comment.Name
           
           
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
             //alert('state>>'+state);
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS!",
                    "message": "Comments Added."
                });
                toastEvent.fire();
                //url redirect
               // window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
           }
            else if(state === 'ERROR'){
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Error Occured",
                    type: "Error"
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);

    },*/

    saveComments: function (component, event, helper) {
        var applicationId = event.getSource().get("v.value");
        console.log(JSON.stringify(applicationId));

        helper.saveCommentsHelper(component, event, applicationId);

        component.set("v.viewComments", true);
    },

    hideModel3: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.viewComments", false);
    },

    handleSaveComment: function (component, event, helper) {
        //alert('Inside save');
        var applicationId = event.getSource().get("v.value");
        console.log(JSON.stringify(applicationId));

        //var appId = component.get("v.commentsList");
        //console.log(JSON.stringify(appId[0].Job_Application__c));
        //alert(candName.JobAppication.Id);
        var comment = component.get("v.comments");
        console.log(JSON.stringify(component.get("v.comments")));
        //alert(comment);
        if (comment.Name == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                message: "Empty Comments",
                type: "Error"
            });
            toastEvent.fire();
        }
        else {
            var action = component.get("c.saveComment");

            action.setParams({
                'appId': applicationId,
                'comment': comment.Name
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                //alert('state>>'+state);
                if (state === 'SUCCESS') {

                    console.log(response.getReturnValue());
                    component.set("v.commentsList", response.getReturnValue());
                    console.log(component.get("v.commentsList"));

                    component.set("v.viewComments", true);
                    component.set("v.comments", '');
                    //url redirect
                    // window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
                }
                else if (state === 'ERROR') {
                    //var list = response.getReturnValue();
                    //component.set("v.picvalue", list);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        message: "Error Occured",
                        type: "Error"
                    });
                    toastEvent.fire();

                }

            });
        }


        $A.enqueueAction(action);

    },

    handleResubmit: function (component, event, helper) {

        component.set("v.ShowResumissionModal", true);
    },

    handleFilesChange: function (component, event, helper) {

        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },

    saveFile: function (component, event, helper) {
        var candId = event.getSource().get("v.value");
        if (component.find("fuploader").get("v.files").length > 0) {
            //alert('File Found ');
            helper.uploadHelper(component, event, helper, candId);
        } else {
            alert('Please Select a Valid File');
        }
    },

    createOffer: function (component, event, helper) {
        var jobAppId = event.getSource().get("v.value");
        console.log('jobAppId' + jobAppId);

        window.open('/apex/SDOC__SDCreate1?Id=' + jobAppId);

        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "SDTemplateCSSComponent	",
            componentAttributes: {
                jobAppId : jobAppId
            }
        });
        evt.fire();*/

    }
})