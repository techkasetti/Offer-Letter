({
    doInit: function (component, event, helper) {
        helper.getRecords(component, event, helper);
        helper.setFilterbyStatusList(component, event, helper);
        helper.setFilterbyCompanyList(component, event, helper);
    },

    /*handleclick: function (component, event, helper) {
        //var batchId = event.getSource().get("v.name");
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



})