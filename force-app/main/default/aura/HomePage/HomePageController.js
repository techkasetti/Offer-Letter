({
    doInit: function (component, event, helper) {
        
        helper.getRecords(component, event, helper);
        helper.setFilterbyStatusList(component, event, helper);
        helper.setFilterbyCompanyList(component, event, helper);
    },

    /*handleclick: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:MyDashboard",
            componentAttributes: {
                batchId: batchId
            }
        });
        evt.fire();
    },*/
    
    handleclick: function (component, event, helper) {
        //var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToURL");
        evt.setParams({
            "url": "https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/r/Dashboard/01Z4x000000phvvEAA/view?queryScope=userFolders"
            
        });
        evt.fire();
    },

    handlechange: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:xRaySearch",
            componentAttributes: {
                batchId: batchId
            }
        });
        evt.fire();
    },

    handlesearch: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:SmartSearchUsingFS",
            componentAttributes: {
                batchId: batchId
            }
        });
        evt.fire();
    },

    handlePending: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:JobProfiles",
            componentAttributes: {
                batchId: batchId
            }
        });
        evt.fire();
    },

    handleAdd: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:jobPosting",
            componentAttributes: {
                batchId: batchId
            }
        });
        evt.fire();
    },

    statusFilterChange: function (component, event, helper) {
        // alert('change detected');
        var filterSelected = component.find("poststatus").get("v.value");
        component.set("v.selectedStatus", filterSelected);
        alert(filterSelected);
        helper.getRecords(component, event, helper);
    },

    companyFilterChange: function (component, event, helper) {
        // alert('change detected');
        var filterSelected = component.find("clientfilter").get("v.value");
        component.set("v.selectedClient", filterSelected);
        // alert(filterSelected);
        helper.getRecords(component, event, helper);
    },
    
    toggle: function(component, event, helper) {
        //alert('toggle');
        var items = component.get("v.jobPostings"); 
        //alert('items ::'+JSON.stringify(items));
       
        console.log(JSON.stringify(component.get("v.jobPostings")));
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
        component.set("v.jobPostings",items); 
        
        console.log(JSON.stringify(component.get("v.jobPostings")));
    },



})