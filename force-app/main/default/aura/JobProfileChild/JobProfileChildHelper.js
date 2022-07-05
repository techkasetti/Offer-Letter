({
    handleClickHelper : function(component, event, helper,buttonType,buttonTypeId) {
        var save_action = component.get("c.toGetJobApplicants");
        save_action.setParams({"buttonType":buttonType,
                               "buttonTypeId":buttonTypeId});
        save_action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") { 
                var storeResponse = response.getReturnValue();
                // $A.get('e.force:refreshView').fire();
                // set searchResult list with return value from server.
                console.log('storeResponse >>>>'+JSON.stringify(storeResponse[0]));
                component.set("v.jobApplication", storeResponse[0]);
                console.log('storeResponse>>>'+JSON.stringify(component.get("v.jobApplication")));
                
                
            }
            
        });
        $A.enqueueAction(save_action);
    },
    
    saveCommentsHelper : function(component, event,applicationId) {
        var action = component.get("c.getComments");
        //alert('applicationId>>'+applicationId);
        action.setParams({ 
            'appId' : applicationId
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('state>>'+state);
            if(state === 'SUCCESS'){
                console.log(response.getReturnValue());
                component.set("v.commentsList",response.getReturnValue());
                console.log(component.get("v.commentsList"));
  
            }
            else if(state === 'ERROR'){
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Error Occured",
                    type: "Error"
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
    },
    
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,   
    
    uploadHelper: function(component, event,helper,candId) {
        
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fuploader").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents,candId);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents,candId) {
        
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value
        
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.saveResubmitProfile(component, event, file, fileContents, startPosition, endPosition, '',candId);
    },
    
    saveResubmitProfile : function(component, event, file, fileContents, startPosition, endPosition, attachId,candId){
        
        var getchunk = fileContents.substring(startPosition, endPosition);      
        
        var action = component.get("c.saveResubmitProfile");
        
        action.setParams({ 
            "candId": candId,
            "fileName": file.name,
            "base64Data": encodeURIComponent(getchunk),
            "contentType": file.type,
            "fileId": attachId
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('state>>'+state);
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: "Profile Has Been Re-Submitted",
                    type: "success"
                });
                toastEvent.fire();
                //url redirect
                window.location.replace("https://techkasetti-dev-org-dev-ed.lightning.force.com/lightning/n/Home_Page");
            }
            else if(state === 'ERROR'){
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Error Occured",
                    type: "Error"
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
    }
    
})