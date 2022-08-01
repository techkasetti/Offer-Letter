({
	/* onClick: function (cmp, evt, helper) {
        var allValid = cmp.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        if (allValid) {
            alert('All form entries look valid. Ready to submit!');
        } else {
            alert('Please update the invalid form entries and try again.');
        }
    } */
    
    backToHP : function(component, event, helper) {
        var urlString = window.location.href;
        var CommunityBaseURL = urlString.substring(0,urlString.indexOf("/one/"));
        window.location.replace(CommunityBaseURL+"/lightning/n/Home_Page");
    },

    sheduleZoom : function(component, event, helper) {
        var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:ZoomMeetingShedule",
            componentAttributes: {
                batchId: batchId
            }
        });
        evt.fire();
        // var action = component.get("c.scheduleMeeting");
        // action.setCallback(this, function (response) {
        //     var state = response.getState();
        //     if (state === 'SUCCESS') {

        //         //var test = component.set("v.parentList", response.getReturnValue());
        //         alert('sheduleZooomMeeting>>'+JSON.stringify(response.getReturnValue()));                
        //     }
        //     else if (state === 'ERROR') {

        //         var toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({
        //             "title": "ERROR!",
        //             "message": "Error Occured Shedule Zoom Meeting"
        //         });
        //         toastEvent.fire();
        //     }
        // })
        // $A.enqueueAction(action);
    },

    searchLinkedin: function (cmp, evt, helper) {
        var input1 = cmp.find('input1').get('v.value');
        var input2 = cmp.find('input2').get('v.value');
        var input3 = cmp.find('input3').get('v.value');
       // alert('input1>>'+input1 + '<<input2>>'+input2 + '<<input3>>'+input3);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
         // "url": 'https://www.google.com/search?q=' + input1 + '+' + input2 + '+' + input3
          "url": 'https://www.linkedin.com/search/results/all/?keywords=' + input1 + '+' + input2 + '+' + input3
        });
        cmp.set("v.ShowCandidateProfile",true);     
        urlEvent.fire();
        
    } ,

    updateOtherReason: function (component, event, helper) {
      //alert('updateOtherReason'+component.get("v.textvalue"));
        
    } ,

    handleProfile : function(component, event, helper) {
        var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:fileUpload",
            
            componentAttributes: {
                batchId : batchId
            }
            
        });
        evt.fire();
    },
    
    searchNaukri: function (component, evt, helper) {
        var naukri1 = component.find('naukri1').get('v.value');
        var naukri2 = component.find('naukri2').get('v.value');
        var naukri3 = component.find('naukri3').get('v.value');
        //alert('naukri1>>'+naukri1 + '<<naukri2>>'+naukri2 + '<<naukri3>>'+naukri3);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
         // "url": 'https://www.google.com/search?q=' + input1 + '+' + input2 + '+' + input3
          "url": 'https://www.naukri.com/mnjuser/homepage'
        });
        component.set("v.ShowCandidateProfile",true);     
        urlEvent.fire();
        
    } ,
    
    searchIndeed : function (component, evt, helper) {
        var Indeed1 = component.find('Indeed1').get('v.value');
        var Indeed2 = component.find('Indeed2').get('v.value');
        var Indeed3 = component.find('Indeed3').get('v.value');
        //alert('Indeed1>>'+Indeed1 + '<<Indeed2>>'+Indeed2 + '<<Indeed3>>'+Indeed3);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
         // "url": 'https://www.google.com/search?q=' + input1 + '+' + input2 + '+' + input3
          "url": 'https://in.indeed.com/'
        });
        component.set("v.ShowCandidateProfile",true);     
        urlEvent.fire();
        
    } ,


    
})