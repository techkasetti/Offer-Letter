({
    
    doInit : function(component, event,helper,page) 
    {    
        var items = component.get("v.JobList"); 
        console.log(component.get("v.JobList"));
        //var jobPostings = JSON.parse(items);
        //console.log(jobPostings);

         
        /*List<Job_Posting__c> deserializeSkill = (List<Job_Posting__c>) System.JSON.deserialize(items, List<Job_Posting__c>.Class);
        
        system.debug('deserializeSkill>>'+deserializeSkill);*/
        var action = component.get("c.toGetJobApplicants");
        action.setParams({"buttonType":'',
                          "buttonTypeId":'',
                          "items":items});
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
                var response = JSON.parse(storeResponseList);
                //alert('response>>'+JSON.stringify(response));
                // var items = component.get("v.JobList"); 
                console.log(response);
                
                //console.log(response[2].JobAppication.Job_Posting__r.Name);
                //console.log(jobPostings[0].Name);
                //alert('items ::'+JSON.stringify(items));
                //console.log(typeof(items));
                
                      /*for(var j=0;j<response.length;j++){
                          for(var i =0;i<jobPostings.length;i++){
                            if(response[j].JobAppication.Job_Posting__r.Name===jobPostings[i].Name){
                            
                            console.log(response[j]);
                            array.push(response[j]);
                            console.log(array);
                            component.set("v.CandidateProfiles",array);
                            console.log(component.get("v.CandidateProfiles"));
                        }
                          }
                    
                }*/
                
            }
            
        });
        $A.enqueueAction(action);

        /*var action1 = component.get("c.togetJobPostings");
        action1.setParams({"items":items});
        action1.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") { 
                var storeResponse = response.getReturnValue();   
                console.log(storeResponse);
                component.set('v.CandidateProfiles',storeResponse);
                alert(JSON.stringify(component.get('v.CandidateProfiles')));
            }
        });
        $A.enqueueAction(action1);*/

    },
    
    toggle: function(component, event, helper) {
        //alert('toggle');
        var items = component.get("v.JobList"); 
        //alert('items ::'+JSON.stringify(items));
        console.log(JSON.stringify(component.get("v.JobList")));
        var chevronright = component.find('chevronright');
        var chevrondown = component.find('chevrondown');
        
        $A.util.toggleClass(chevronright, 'slds-hide');
        $A.util.toggleClass(chevrondown, 'slds-hide');
        var getAttributeValue = component.get("v.checkThis"); 
        console.log(getAttributeValue);
        if(getAttributeValue==true){
            //alert('true');
            component.set("v.checkThis", false);
            component.set('v.expanded',true);
            items.expanded=true;
            component.set("v.tablesize",true);
        }
        else{
            //alert('else');
            component.set("v.checkThis", true);
            component.set('v.expanded',false);
            items.expanded=false;
            component.set("v.tablesize",false);
        }
        component.set("v.JobList",items); 
        
        console.log(JSON.stringify(component.get("v.JobList")));
    },

    editJobPosting : function(component, event, helper) {
        //alert("You clicked>>>" + event.getSource().get("v.name"));
        var jobPostRecordId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:jobPosting",
            componentAttributes: {
                jobPostRecordId : jobPostRecordId
            }
        });
        evt.fire();
    },
})