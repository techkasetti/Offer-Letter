({
    doInit : function(component, event, helper) {
        
        
        //Trail
        var columns = [
            {
                type: 'text',
                fieldName: 'Name',
                label: 'Job Postings'
            },
            {
                type: 'number',
                fieldName: 'KTDO1__No_Of_Candidate_Selected__c',
                label: 'No. of Candidate Selected'
            },
            {
                type: 'date',
                fieldName: 'KTDO1__Posting_Due_Date__c',
                label: 'Due Date'
            },
            {
                type: 'text',
                fieldName: 'KTDO1__Job_OC_Status__c',
                label: 'Status'
            },
            
        ];
            component.set('v.gridColumns', columns);
            var action = component.get("c.getJobPosting");
            action.setCallback(this, function(response){
            var state = response.getState();
            if ( state === "SUCCESS" ) {
            var data = response.getReturnValue();
            console.log(JSON.stringify(data));
            for ( var i=0; i<data.length; i++ ) {
            data[i]._children = data[i]['Contacts'];
        delete data[i].Contacts; 
        
    }
    component.set('v.gridData', data);
}
 });
$A.enqueueAction(action);
//Trail End


var action = component.get("c.getJobPosting");

action.setCallback(this, function(response) {
    $A.util.removeClass(component.find("mySpinner"), "slds-show");
    var state = response.getState();
    //alert(state);
    if (state === "SUCCESS") { 
        var storeResponse = response.getReturnValue();   
        console.log('storeResponse ::: '+storeResponse);
        var array = [];
        var storeResponseList = [];
        storeResponseList = JSON.stringify(storeResponse);
        console.log('storeResponseList ::: '+storeResponseList);
        
        component.set("v.jobPostings", storeResponse);
        // alert(JSON.stringify(component.get("v.jobPostings")));
        
        
        
    }
    else{
        alert('there is no record to display');
    }
    
});
$A.enqueueAction(action);
},
    
    handleclick : function(component, event, helper) {
        var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:MyDashboard",
            componentAttributes: {
                batchId : batchId
            }
        });
        evt.fire();
    },
        
        handlechange : function(component, event, helper) {
            var batchId = event.getSource().get("v.name");
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:xRaySearch",
                componentAttributes: {
                    batchId : batchId
                }
            });
            evt.fire();
        },
            
            handlesearch : function(component, event, helper) {
                var batchId = event.getSource().get("v.name");
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:ProfileSearch",
                    componentAttributes: {
                        batchId : batchId
                    }
                });
                evt.fire();
            },
                
                handlePending : function(component, event, helper) {
                    var batchId = event.getSource().get("v.name");
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:JobProfiles",
                        componentAttributes: {
                            batchId : batchId
                        }
                    });
                    evt.fire();
                },
                    
                    handleAdd : function(component, event, helper) {
                        var batchId = event.getSource().get("v.name");
                        var evt = $A.get("e.force:navigateToComponent");
                        evt.setParams({
                            componentDef : "c:jobPosting",
                            componentAttributes: {
                                batchId : batchId
                            }
                        });
                        evt.fire();
                    },
                        
                        
                        
                        
                        
})