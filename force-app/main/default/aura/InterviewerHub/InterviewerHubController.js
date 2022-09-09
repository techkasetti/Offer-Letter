({
    doInit : function(component, event, helper) {

        var action = component.get("c.getJobAppForInterviewer");
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

    
})
