({
    doInit : function(component, event, helper) {
        component.set("v.noEmptyRecord",false);
        helper.initializeRetailer(component,helper);
        component.set("v.SearchKeyWord","");
        component.set("v.SearchUserKeyWord","");
        component.set("v.selectedUserRecord",[]);
        helper.getRetailerPickListValuesss(component, event, helper);
        //  helper.getCompPickListValues(component, event, helper);
    },
    
    //Custom Lookup Retailerdata Controllers     
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfUserSearchRecords", null );
        var forclose = component.find("searchUserRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    keyPressUserController : function(component, event, helper) {
        //alert('Inside>');
        var getInputkeyWord = component.get("v.SearchUserKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchUserRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchUserHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfUserSearchRecords", null ); 
            var forclose = component.find("searchUserRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    handleChange: function (component, event,helper) {
        //alert('inside');
        component.set("v.showSpinner",true);
        var selectedValue = ' ';
        helper.handleChangeResultHelper(component,event,selectedValue);
        
    },

    handleChangeResult: function (component, event,helper) {
        //alert('inside');
        component.set("v.showSpinner",true);
        var selectedValue = event.getSource().get('v.value');
        //alert(selectedValue);
        
        helper.handleChangeResultHelper(component,event,selectedValue);
      
    },
    
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        
        var selectedrecordByEvent = event.getParam("recordByEvent");
        
        // alert('selectedrecordByEvent'+selectedrecordByEvent.Name);        
        if(selectedrecordByEvent != null && selectedrecordByEvent != ""){            
            
            component.set("v.selectedRetailerRecord" , selectedrecordByEvent);
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchUserRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupUserField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
            helper.handleChangeHelper(component,event,selectedrecordByEvent.Name);
        }
        
        
    },
    // function to clear the selected recruiter
    clear :function(component,event,helper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupUserField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        //alert('Inside'); 
        component.set("v.SearchUserKeyWord",null);
        component.set("v.listOfUserSearchRecords", null );
        component.set("v.selectedRetailerRecord", {} );   
        component.set("v.recruiterData", null );
    },
})