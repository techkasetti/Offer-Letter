public class JobProfileCntrl {
    @AuraEnabled
    public static List<JobApplicantsWrap> toGetJobApplicants(String buttonType, String buttonTypeId)
    {
        system.debug('buttonType :>>>>>'+buttonType);
        system.debug('buttonTypeId :>>>>>'+buttonTypeId);
        
        //Added by Dharshan
        //if onboard,increment KTDO1__No_Of_Candidate_Selected__c
        if(buttonType == 'Onboard'){
            KTDO1__Job_Application__c opp = [SELECT KTDO1__Job_Posting__r.Id FROM KTDO1__Job_Application__c where Id =: buttonTypeId];
            KTDO1__Job_Posting__c opp1 = [SELECT KTDO1__No_Of_Candidate_Selected__c,KTDO1__No_Of_Positions__c,KTDO1__Posting_Due_Date__c,KTDO1__Job_OC_Status__c FROM KTDO1__Job_Posting__c where Id =: opp.KTDO1__Job_Posting__r.Id];
            
            //Today date
            DateTime todaysDate = System.today();
            String todaysDateStr = todaysDate.format('yyyy-MM-dd');
            System.debug('Today date>>'+todaysDateStr);
            
            //Due Date
            DateTime dueDate = opp1.KTDO1__Posting_Due_Date__c;
            String dueDateStr1 = dueDate.format('yyyy-MM-dd');
            Double count = opp1.KTDO1__No_Of_Candidate_Selected__c + 1;
            
            System.debug('Due Date>>'+dueDateStr1);
            System.debug('opp1.KTDO1__No_Of_Positions__c>>'+opp1.KTDO1__No_Of_Positions__c);
            System.debug('opp1.KTDO1__No_Of_Candidate_Selected__c+1>>'+count);
            
            if(todaysDateStr > dueDateStr1 || opp1.KTDO1__No_Of_Positions__c >= count){
                opp1.KTDO1__Job_OC_Status__c = 'Closed';
                if(opp1.KTDO1__No_Of_Positions__c == count){
                    opp1.KTDO1__No_Of_Candidate_Selected__c = opp1.KTDO1__No_Of_Candidate_Selected__c + 1;
                }
            }
            else {
                opp1.KTDO1__No_Of_Candidate_Selected__c = opp1.KTDO1__No_Of_Candidate_Selected__c + 1;
            }
            update opp1;
        }
        //Ended by Dharshan
        
        
        List<JobApplicantsWrap> JobApplicantsWrapList = new List<JobApplicantsWrap>();
        Schema.sObjectField dependentField = KTDO1__Job_Application__c.KTDO1__Status__c;
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        //Get dependent field result
        Schema.DescribeFieldResult dependentFieldResult = dependentField.getDescribe();
        //Get dependent field controlling field 
        Schema.sObjectField controllerField = dependentFieldResult.getController();
        //Check controlling field is not null
        if(controllerField == null){
            // return null;
        } 
        //Get controlling field result
        Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
        //Get controlling field picklist values if controlling field is not a checkbox
        List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());
        
        //It is used to decode the characters of the validFor fields. 
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        
        for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
            if (entry.isActive()){
                //The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
                List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer i = 0; i < controllerValues.size(); i++){
                    Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
                    Integer bitIndex = i / 6;
                    Integer bitShift = 5 - Math.mod(i, 6 );
                    if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
                        continue;
                    } 
                    if (!dependentPicklistValues.containsKey(controllerValue)){
                        dependentPicklistValues.put(controllerValue, new List<String>());
                    }
                    dependentPicklistValues.get(controllerValue).add(entry.getLabel());
                }
            }
        }
        system.debug('dependentPicklistValues ::'+dependentPicklistValues);
        
        if(buttonType != '' && buttonTypeId != ''){
            KTDO1__Job_Application__c lstOfValues = [Select id ,Name,KTDO1__Candidate_Profile__c ,KTDO1__Candidate_Profile__r.Name, KTDO1__Candidate_Profile__r.KTDO1__Current_Location__c , KTDO1__Candidate_Profile__r.KTDO1__Designation__c, KTDO1__Candidate_Profile__r.KTDO1__Experience__c , KTDO1__Candidate_Profile__r.KTDO1__Skills__c , KTDO1__Candidate_Profile__r.KTDO1__Notice_Period__c , KTDO1__Profile_Status__c,KTDO1__Job_Posting__r.Name,KTDO1__Job_Posting__r.KTDO1__Posting_Due_Date__c,KTDO1__Job_Posting__r.KTDO1__Job_OC_Status__c  From KTDO1__Job_Application__c where Id =:buttonTypeId];
            system.debug('KTDO1__Job_Application__c:'+lstOfValues);
            lstOfValues.KTDO1__Profile_Status__c = buttonType; 
            update lstOfValues;
            JobApplicantsWrap JobApplicantsWrapVal = new JobApplicantsWrap();
            JobApplicantsWrapVal.JobAppication = lstOfValues;
            system.debug('dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c)   :::'+dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c));
            JobApplicantsWrapVal.StatusButtons = dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c);
            JobApplicantsWrapList.add(JobApplicantsWrapVal);
            return JobApplicantsWrapList;
        }
        else{
            List <KTDO1__Job_Application__c> lstOfValues = [Select id ,Name,KTDO1__Candidate_Profile__c ,KTDO1__Candidate_Profile__r.Name, KTDO1__Candidate_Profile__r.KTDO1__Current_Location__c , KTDO1__Candidate_Profile__r.KTDO1__Designation__c, KTDO1__Candidate_Profile__r.KTDO1__Experience__c , KTDO1__Candidate_Profile__r.KTDO1__Skills__c ,KTDO1__Candidate_Profile__r.KTDO1__Notice_Period__c , KTDO1__Profile_Status__c,KTDO1__Job_Posting__r.Name  From KTDO1__Job_Application__c];
            system.debug('KTDO1__Job_Application__c:'+lstOfValues);
            for(KTDO1__Job_Application__c values : lstOfValues){
                JobApplicantsWrap JobApplicantsWrapVal = new JobApplicantsWrap();
                system.debug('values ::'+values);
                JobApplicantsWrapVal.JobAppication = values;
                JobApplicantsWrapVal.StatusButtons = dependentPicklistValues.get(values.KTDO1__Profile_Status__c);
                // String allstring = string.join(dependentPicklistValues.get(values.KTDO1__Profile_Status__c),',');
                system.debug('dependentPicklistValues.get(values.KTDO1__Profile_Status__c)   :::'+dependentPicklistValues.get(values.KTDO1__Profile_Status__c));
                JobApplicantsWrapList.add(JobApplicantsWrapVal);
                system.debug('JobApplicantsWrapList  Inside>>>'+JobApplicantsWrapList);
                
            }
            system.debug('JobApplicantsWrapList >>>'+JobApplicantsWrapList);
            return JobApplicantsWrapList;
        }
        
    }
    
    public class JobApplicantsWrap
    {
        @AuraEnabled public List<string> StatusButtons ;
        @AuraEnabled public KTDO1__Job_Application__c JobAppication = new KTDO1__Job_Application__c();
    }
    
    /* @AuraEnabled
public static String updateJobCandSelectedStatus(String buttonTypeId){
KTDO1__Job_Application__c opp = [SELECT Id FROM KTDO1__Job_Application__c );
opp.KTDO1__Job_Posting__c.
}  */
    
    @AuraEnabled
    public static List<Contact> getContact(String jobId){
        system.debug('jobId>>>'+jobId);
        KTDO1__Job_Posting__c con = [SELECT Id,Name,KTDO1__Account__c  FROM KTDO1__Job_Posting__c where Id =: jobId LIMIT 1];
        system.debug('con'+con);
        Account a = [Select Id, Name,(Select Id,Name,Phone,Email,KTDO1__Venue_Details__c,KTDO1__SkypeId__c from Contacts) from Account where Id=:con.KTDO1__Account__c];
        system.debug('a'+a);
        return a.Contacts;
        
    }
    
    @AuraEnabled
    public static void setL1InterviewScheduled(String jobAppId){
        system.debug('jobAppId>>>'+jobAppId);
        List <KTDO1__Job_Application__c> lstOfValues = [Select Id,Name,KTDO1__Profile_Status__c from KTDO1__Job_Application__c where Id=: jobAppId ];
        system.debug('KTDO1__Job_Application__c:'+lstOfValues);
        //KTDO1__Job_Application__c p =new KTDO1__Job_Application__c();
        lstOfValues[0].KTDO1__Profile_Status__c='L1 Interview Scheduled';
        update lstOfValues;
    }
    
    @AuraEnabled
    public static Boolean hideProfileStatus(){
        String userId = UserInfo.getUserId();
        system.debug('userId>>>'+userId);
        User userProfile = [Select ProfileId from User where Id=: userId];
        system.debug('userProfile>>>'+userProfile);
        Profile profileName = [Select Name from Profile where Id=:userProfile.ProfileId];
        system.debug('profileName>>>'+profileName);
        if(profileName.Name =='System Administrator'){
            return true;
        }
        else{
            return false;
        }
    }
    
    @AuraEnabled
    public static List<KTDO1__Comments__c> saveComment(Id appId, String comment){
        system.debug('appId>>>'+appId);
        system.debug('comment>>>'+comment);
        String userName = UserInfo.getName();
        system.debug('userName>>>'+userName);
                
        KTDO1__Comments__c commentValue = new KTDO1__Comments__c(KTDO1__Job_Application__c=appId,KTDO1__Remarks__c=comment,KTDO1__User__c=userName);
        insert commentValue;
        List<KTDO1__Comments__c> updatedComments = getComments(appId);
        system.debug('updatedComments>>>'+updatedComments);
        return updatedComments;
    }
    
    @AuraEnabled
    public static List<KTDO1__Comments__c> getComments(Id appId){
        system.debug('appId>>>'+appId);
        List<KTDO1__Comments__c> comments = [Select KTDO1__Job_Application__c,KTDO1__Remarks__c,KTDO1__User__c from KTDO1__Comments__c where KTDO1__Job_Application__c =:appId ];
        system.debug('comments>>>'+comments);
        return comments;  
    }
    
    
   /* @AuraEnabled
    public static Boolean saveResubmitProfile(String candId,String fileName,String base64Data,String contentType,String fileId){
        system.debug('candId>>>'+candId);
        system.debug('fileName>>>'+fileName);
        system.debug('base64Data>>>'+base64Data);
        system.debug('contentType>>>'+contentType);
        system.debug('fileId>>>'+fileId);
        
        String userId = UserInfo.getUserId();
        system.debug('userId>>>'+userId);
        User userProfile = [Select ProfileId from User where Id=: userId];
        system.debug('userProfile>>>'+userProfile);
        Profile profileName = [Select Name from Profile where Id=:userProfile.ProfileId];
        system.debug('profileName>>>'+profileName);
        if(profileName.Name =='System Administrator'){
            List<ContentDocumentLink> attList = [SELECT ContentDocumentId  FROM ContentDocumentLink  
                                                 WHERE LinkedEntityId  =:candId ];  
            system.debug('attList ::'+attList);
            delete attList;
            if (fileId == '') {
                
                
                base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
                conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = fileName; // Display name of the files
                conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
                insert conVer;
                
                // First get the content document Id from ContentVersion
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : conVer.Id].ContentDocumentId;
                
                //Create ContentDocumentLink
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = conDoc;
                cDe.LinkedEntityId = candId; // you can use objectId,GroupId,ParentId etc
                cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                cDe.Visibility = 'InternalUsers';
                insert cDe;
                
                          
            }
            return true;  
        }
        else{
            return false;
        }
        
    }*/
    
   
}