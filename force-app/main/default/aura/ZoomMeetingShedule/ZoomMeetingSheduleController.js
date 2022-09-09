({
    doInit: function (component, event, helper) {
        component.set("v.isModalOpen",true);

        //SET CANDIDATE EMAIL STARTS
        //alert('batchid>>>'+component.get("v.batchId"));
        var action = component.get("c.getCandEmail");
            action.setParams({
                "candAppID" : component.get("v.batchId")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                        if(state === 'SUCCESS'){
                            //alert('getCandEmail>>>'+response.getReturnValue());
                            component.set("v.candEmail",response.getReturnValue());
                        }
                        else if(state === 'ERROR'){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Error in getCandEmail."
                            });
                            toastEvent.fire();  
                        }
                })
                $A.enqueueAction(action);
            //SET CANDIDATE EMAIL ENDS

            //SET HOST EMAIL STARTS
            var action = component.get("c.getHostEmail");
            action.setParams({
                "hostID" : component.get("v.batchId")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                        if(state === 'SUCCESS'){
                            //alert('getHostEmail>>>'+response.getReturnValue());
                            component.set("v.contactList",response.getReturnValue());
                            //component.set("v.hostEmail",response.getReturnValue());
                        }
                        else if(state === 'ERROR'){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Error in getHostEmail."
                            });
                            toastEvent.fire();  
                        }
                })
                $A.enqueueAction(action);
                //SET HOST EMAIL ENDS
    },

    zoomShedule : function(component, event, helper) {
        var timeDate = component.get("v.startDatetime");
        var hostEmail = component.get("v.hostEmail");
        var candEmail = component.get("v.candEmail");

        //alert('timeDate>>'+JSON.stringify(timeDate));
        //alert('hostEmail>>'+JSON.stringify(hostEmail));
        //alert('candEmail>>'+JSON.stringify(candEmail));

        var action = component.get("c.scheduleMeeting");
            action.setParams({
                "timeDate" : timeDate,
                "hostEmail" : hostEmail,
                "candEmail" : candEmail
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                        if(state === 'SUCCESS'){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "SUCCESS!",
                                "message": "Zoom Meeting Sheduled Successfully.",
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
                                "message": "Error in Zoom Meeting Shedule Format."
                            });
                            toastEvent.fire();
                        }
                })
                $A.enqueueAction(action);

    },
    
    onChange: function(component, event, helper) {
        var contactName = event.getSource().get("v.value");
        //alert(recName);

        var record = component.get("v.contactList");
        //console.log(JSON.stringify(component.get("v.contactList")));
        var contactSelected;
        record.forEach(element => {
            if (contactName == element.Name) {
                contactSelected = element;
                component.set("v.contactSelected", contactSelected);
            }
        });
        
    }
})