({
    
    doInit : function(component, event,helper,page) 
    {    
        var items = component.get("v.JobList"); 
        console.log(JSON.stringify(component.get("v.JobList")));
        var action = component.get("c.toGetJobApplicants");
        action.setParams({"buttonType":'',
                          "buttonTypeId":''});
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
                
                console.log(response[2].JobAppication.KTDO1__Job_Posting__r.Name);
                
                //alert('items ::'+JSON.stringify(items));
                //console.log(typeof(items));
                
                      for(var j=0;j<response.length;j++){
                            if(response[j].JobAppication.KTDO1__Job_Posting__r.Name===items.Name){
                            
                            console.log(response[j]);
                            array.push(response[j]);
                            console.log(array);
                            component.set("v.CandidateProfiles",array);
                            console.log(component.get("v.CandidateProfiles"));
                        }
                    
                }
                
            }
            
        });
        $A.enqueueAction(action);
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
})