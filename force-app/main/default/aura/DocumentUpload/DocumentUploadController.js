({

    doInit: function (component, event, helper) {
        component.set("v.isModalOpen", true);
        var action = component.get("c.getAccessToken");
        action.setCallback(this, function (response) {
            var status = response.getState();
            if (status === "SUCCESS") {
                var accessToken = response.getReturnValue();
                // alert('accessToken>>>' + accessToken);
                component.set("v.accessToken", accessToken);
            }
        });
        $A.enqueueAction(action);
        //v.batchId from JobProfileChild component
        var job = component.get("v.batchId");
        //alert(job);
        var jobApplication = JSON.parse(job);
        console.log(jobApplication);
        var action = component.get("c.fetchJobPostingDocList");
        console.log('I here 1');
        action.setParams({
            "JobApplicationId": jobApplication.Id,
            "JobPostingId": jobApplication.Job_Posting__c
        });

        // action.setParams({
        //     "JobApplicationId": "a088Z000013AelKQAS",
        //     "JobPostingId": "a038Z00000XJ98pQAD"
        // });
        console.log('param set');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                console.log('I here 2');
                component.set('v.fileName', Response);
                //alert('Response>>>'+JSON.stringify(Response));
                component.set('v.fileCount', Response.length);
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In fetchJobPostingDocList."
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);

        //Get documentStorage name from job posting object
        var action = component.get("c.fetchDocumentStorageName");
        action.setParams({
            "JobPostingId": jobApplication.Job_Posting__c
        });

        // action.setParams({
        //     "JobPostingId": "a038Z00000XJ98pQAD"
        // });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                component.set('v.tabName', Response);
                //alert('Response>>>'+JSON.stringify(component.get('v.tabName')));
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In fetchDocumentStorageName."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    onCheckGDrive: function (component, evt) {
        var checkbox = evt.getSource();
        var count = component.get("v.fileuploadCount");
        //alert(checkbox.get("v.value"));
        var value = checkbox.get("v.value");
        if (value == true) {
            count = count + 1;
        }
        else {
            count = count - 1;
        }
        //alert('count>>'+count);
        component.set("v.fileuploadCount", count);
        if (component.get('v.fileuploadCount') == component.get('v.fileCount')) {
            component.set("v.documentVerifiedCheckbox", false);
        }
        else {
            component.set("v.documentVerifiedCheckbox", true);
        }

    },


    /*  UploadDoc : function(component, event, helper) {
          component.set("v.isModalOpen",true);
          var Job = component.get("v.batchId");
          var jobApplication = JSON.parse(Job);
          console.log(jobApplication);
          console.log(jobApplication.JobAppication.Id);
          console.log(jobApplication.JobAppication.Job_Posting__c);
          var action = component.get("c.fetchJobPostingDocList");
          action.setParams({
              "JobApplicationId":jobApplication.JobAppication.Id,
              "JobPostingId" : jobApplication.JobAppication.Job_Posting__c
          });
          action.setCallback(this, function(response) {
              var state = response.getState();
              //alert('state>>>'+state);
              if (state === "SUCCESS") { 
                  var Response = response.getReturnValue();
                  component.set('v.fileName',Response);
                  //alert('Response>>>'+JSON.stringify(Response));
              }
              else {
                  alert('Error>>>'+Error);
              }
              
          });
          $A.enqueueAction(action); 
          
      },
      */

    UploadGDriveFile: function (component, event, helper) {
        var job = component.get("v.batchId");
        var jobApplication = JSON.parse(job);
        var uploadedDocId = event.getSource().get("v.name");
        console.log('uploadedFiles>>' + JSON.stringify(uploadedDocId));
        var uploadedFiles = event.getParam("files");
        var attachmentId = uploadedFiles[0].documentId;
        console.log('on iupload finish');
        var action = component.get("c.gdriveDocUpload");
        action.setParams({
            "attachmentId": attachmentId,
            "accessToken": component.get("v.accessToken"),
            "uploadedDocId": uploadedDocId,
            "jobApplication": jobApplication.Id,
            "jobPosting": jobApplication.Job_Posting__c
        });
        console.log('Param set');
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
                    window.location.reload();
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

        component.set("v.isModalOpen", true);

    },

    ModifyGDriveFile: function (component, event, helper) {
        var modifyDocId = event.getSource().get("v.name");
        //alert('modifyDocId>>'+modifyDocId);
        component.set("v.modifyId", modifyDocId);
        if (component.get("v.isModifyOpen") == false) {
            component.set("v.isModifyOpen", true);
        }
        else {
            component.set("v.isModifyOpen", false);
        }
    },

    DownloadGDriveFile: function (component, event, helper) {
        var downloadDocId = event.getSource().get("v.name");
        //alert('downloadDocId>>'+downloadDocId);

        var action = component.get("c.DownloadDoc");
        action.setParams({
            "downloadDocId": downloadDocId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                //alert('Response>>>'+JSON.stringify(Response));

                if (Response != null) {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": Response
                    });
                    urlEvent.fire();
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There is no file to Download."
                    });
                    toastEvent.fire();
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was some error in Downloading..."
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);

        component.set("v.isModalOpen", true);
    },

    ViewGDriveFile: function (component, event, helper) {
        window.setTimeout(
            $A.getCallback(function () {
                var spinner = component.find('spinner');
                $A.util.toggleClass(spinner, "slds-is-open");
            }), 5000
        );

        var viewDocId = event.getSource().get("v.name");
        //alert('viewDocId>>'+viewDocId);

        var action = component.get("c.ViewDoc");
        action.setParams({
            "viewDocId": viewDocId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                //alert('Response>>>'+JSON.stringify(Response));

                if (Response != null) {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": Response
                    });
                    urlEvent.fire();
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There is no file to View"
                    });
                    toastEvent.fire();

                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was some error in View File..."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, "slds-hide");
    },

    documentRejected: function (component, event, helper) {
        //component.set("v.isModalOpen",false);
        //v.batchId from JobProfileChild component
        var job = component.get("v.batchId");
        var jobApplication = JSON.parse(job);
        //alert('jobApplicationId>>'+jobApplication.JobAppication.Id);

        var action = component.get("c.changeJobAppProfileStatusToRejected");
        action.setParams({
            "jobApplicationId": jobApplication.Id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                //url redirect
                var urlString = window.location.href;
                var CommunityBaseURL = urlString.substring(0, urlString.indexOf("/one/"));
                window.location.replace(CommunityBaseURL + "/lightning/n/Home_Page");
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In changeJobAppProfileStatus"
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);

    },

    documentVerified: function (component, event, helper) {

        //v.batchId from JobProfileChild component
        var job = component.get("v.batchId");
        var jobApplication = JSON.parse(job);
        //alert('jobApplicationId>>'+jobApplication.Id);

        var action = component.get("c.changeJobAppProfileStatusToVerified");
        action.setParams({
            "jobApplicationId": jobApplication.Id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                //url redirect
                var urlString = window.location.href;
                var CommunityBaseURL = urlString.substring(0, urlString.indexOf("/one/"));
                window.location.replace(CommunityBaseURL + "/lightning/n/Home_Page");
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In changeJobAppProfileStatus"
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);

        //url redirect
        var urlString = window.location.href;
        var CommunityBaseURL = urlString.substring(0, urlString.indexOf("/one/"));
        window.location.replace(CommunityBaseURL + "/lightning/n/Home_Page");
    },

    close: function (component, event, helper) {
        var job = component.get("v.batchId");
        var jobApplication = JSON.parse(job);
        //alert('jobApplicationId>>'+jobApplication.JobAppication.Id);

        var action = component.get("c.cloaseDocumentUploadppup");
        action.setParams({
            "jobApplicationId": jobApplication.Id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var Response = response.getReturnValue();
                //url redirect
                var urlString = window.location.href;
                var CommunityBaseURL = urlString.substring(0, urlString.indexOf("/one/"));
                window.location.replace(CommunityBaseURL + "/lightning/n/Home_Page");
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In changeJobAppProfileStatus"
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);

        window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
    },

    handleSelect: function (component, event, helper) {
        //alert('event>>>'+event.getParam('id'));
    },

    UploadAzureFile: function (component, event, helper) {
        //alert('iNSIDE CONTOLLER');
        var job = component.get("v.batchId");
        var jobApplication = JSON.parse(job);
        var uploadedDocId = event.getSource().get("v.name");
        var uploadedFiles = event.getParam("files");
        var attachmentId = uploadedFiles[0].documentId;

        console.log(uploadedDocId + 'Document id object');
        console.log(uploadedFiles);
        console.log(attachmentId + ' Content Document File Id');
        var action = component.get("c.azureDocUpload");
        action.setParams({
            "attachmentId": attachmentId,
            "uploadedDocId": uploadedDocId,
            "jobApplication": jobApplication.Id,
            "jobPosting": jobApplication.Job_Posting__c
        });
        action.setCallback(this, function (response) {
            var status = response.getState();
            alert('status>>>' + status);
            if (status === "SUCCESS") {
                var responseCode = response.getReturnValue();
                alert('responseCode>>>' + responseCode);
                if (responseCode == 'Success') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "File Uploaded successfully."
                    });
                    toastEvent.fire();
                    window.location.reload();
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
                alert('fAILURE');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In azureDocUpload."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

        component.set("v.isModalOpen", true);

    },

    DownloadAzureFile: function (component, event, helper) {
        alert('iNSIDE CONTOLLER');
        var uploadedDocId = event.getSource().get("v.name");



        var action = component.get("c.azureFileDownload");
        action.setParams({
            "uploadedDocId": uploadedDocId
        });
        action.setCallback(this, function (response) {
            var status = response.getState();
            if (status === "SUCCESS") {
                var responseCode = response.getReturnValue();
                alert('responseCode>>>' + responseCode);
                window.open(responseCode, "_blank");
            }
        });
        $A.enqueueAction(action);



    },

})