public with sharing class MyDashboardController {
    
     
    @AuraEnabled
    public static List<User> fetchLookupRecruiterdataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <User> lstOfValues = [Select Name from User where Name like : searchKey LIMIT 10];
        system.debug('User:'+lstOfValues);
        return lstOfValues;
    }
    
    @AuraEnabled
    public static recruiterWrap getRecruiterData(String selectedValue){ 
        String selectedName = UserInfo.getName();
        system.debug('selectedName>>'+selectedName);
        // if(String.isBlank(selectedValue))
        // {
        //     // Boolean isBlank = true;
        //     // User fetchdata=[Select Name,KTDO1__Requirements__c,KTDO1__Selections__c,KTDO1__Submissions__c,KTDO1__Openings__c,KTDO1__Onboardings__c,KTDO1__PO__c,KTDO1__Onboarded_PO__c,KTDO1__Onboarded_Margin__c,KTDO1__Offers__c,KTDO1__Margin__c,KTDO1__Interviews__c from User WHERE Name = 'Vinod Kumar' LIMIT 1];        
        //     // system.debug('fetchdata :'+fetchdata);
        //     // return fetchdata;
        // }
        // else{
        //     // User fetchdata=[Select Name,KTDO1__Requirements__c,KTDO1__Selections__c,KTDO1__Submissions__c,KTDO1__Openings__c,KTDO1__Onboardings__c,KTDO1__PO__c,KTDO1__Onboarded_PO__c,KTDO1__Onboarded_Margin__c,KTDO1__Offers__c,KTDO1__Margin__c,KTDO1__Interviews__c from User WHERE Name =:selectedValue  LIMIT 1];        
        //     // system.debug('fetchdata :'+fetchdata);
        //     // return fetchdata;
        // }
        recruiterWrap recData = new recruiterWrap();
        if(selectedValue==selectedName){
             AggregateResult con = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where KTDO1__Profile_Status__c ='Onboard'];
        system.debug('KTDO1__Job_Application__c>>'+con);
        
        AggregateResult con1 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where KTDO1__Profile_Status__c ='Internal Submit'];
        system.debug('KTDO1__Job_Application__c>>'+con1);
       
        AggregateResult con2 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where KTDO1__Profile_Status__c ='On Interview Process'];
        system.debug('KTDO1__Job_Application__c>>'+con2);

        AggregateResult con3 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where KTDO1__Profile_Status__c ='Interview Cleared'];
        system.debug('KTDO1__Job_Application__c>>'+con3);

        AggregateResult con4 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where KTDO1__Profile_Status__c ='Offer Letter'];
        system.debug('KTDO1__Job_Application__c>>'+con4);

        
        recData.onBoard = String.valueOf(con.get('expr0'));
        recData.internalSubmit = String.valueOf(con1.get('expr0'));
        recData.onInterview = String.valueOf(con2.get('expr0'));
        recData.interviewCleared = String.valueOf(con3.get('expr0'));
        recData.offerLetter = String.valueOf(con4.get('expr0'));
        recData.selectName=selectedName;
        } 
        return recData;
    }
    
    @AuraEnabled
    public static recruiterWrap getRecruiterDataDateWise(String selectedValue){ 
        String selectedName = UserInfo.getName();
        system.debug('selectedName>>'+selectedName);
        system.debug('selectedValue>>'+selectedValue);
       
        recruiterWrap recData = new recruiterWrap();
        if(selectedValue=='Today'){
            AggregateResult con = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Onboard' AND LastModifiedDate = TODAY)];
            system.debug('KTDO1__Job_Application__c>>'+con);
            
            AggregateResult con1 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Internal Submit' AND LastModifiedDate = TODAY)];
            system.debug('KTDO1__Job_Application__c>>'+con1);
           
            AggregateResult con2 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='On Interview Process' AND LastModifiedDate = TODAY)];
            system.debug('KTDO1__Job_Application__c>>'+con2);
    
            AggregateResult con3 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Interview Cleared' AND LastModifiedDate = TODAY)];
            system.debug('KTDO1__Job_Application__c>>'+con3);
    
            AggregateResult con4 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Offer Letter' AND LastModifiedDate = TODAY)];
            system.debug('KTDO1__Job_Application__c>>'+con4);
           
            recData.onBoard = String.valueOf(con.get('expr0'));
            recData.internalSubmit = String.valueOf(con1.get('expr0'));
            recData.onInterview = String.valueOf(con2.get('expr0'));
            recData.interviewCleared = String.valueOf(con3.get('expr0'));
            recData.offerLetter = String.valueOf(con4.get('expr0'));
            recData.selectName=selectedName;
           
                 
        }else if(selectedValue=='This Week'){
            AggregateResult con = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Onboard' AND LastModifiedDate = LAST_N_DAYS:7)];
            system.debug('KTDO1__Job_Application__c>>'+con);
            
            AggregateResult con1 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Internal Submit' AND LastModifiedDate = LAST_N_DAYS:7)];
            system.debug('KTDO1__Job_Application__c>>'+con1);
           
            AggregateResult con2 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='On Interview Process' AND LastModifiedDate = LAST_N_DAYS:7)];
            system.debug('KTDO1__Job_Application__c>>'+con2);
    
            AggregateResult con3 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Interview Cleared' AND LastModifiedDate = LAST_N_DAYS:7)];
            system.debug('KTDO1__Job_Application__c>>'+con3);
    
            AggregateResult con4 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Offer Letter' AND LastModifiedDate = LAST_N_DAYS:7)];
            system.debug('KTDO1__Job_Application__c>>'+con4);
           
            recData.onBoard = String.valueOf(con.get('expr0'));
            recData.internalSubmit = String.valueOf(con1.get('expr0'));
            recData.onInterview = String.valueOf(con2.get('expr0'));
            recData.interviewCleared = String.valueOf(con3.get('expr0'));
            recData.offerLetter = String.valueOf(con4.get('expr0'));
            recData.selectName=selectedName;
        }
        else if(selectedValue=='This Month'){
            AggregateResult con = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Onboard' AND LastModifiedDate = LAST_N_DAYS:30)];
            system.debug('KTDO1__Job_Application__c>>'+con);
            
            AggregateResult con1 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Internal Submit' AND LastModifiedDate = LAST_N_DAYS:30)];
            system.debug('KTDO1__Job_Application__c>>'+con1);
           
            AggregateResult con2 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='On Interview Process' AND LastModifiedDate = LAST_N_DAYS:30)];
            system.debug('KTDO1__Job_Application__c>>'+con2);
    
            AggregateResult con3 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Interview Cleared' AND LastModifiedDate = LAST_N_DAYS:30)];
            system.debug('KTDO1__Job_Application__c>>'+con3);
    
            AggregateResult con4 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Offer Letter' AND LastModifiedDate = LAST_N_DAYS:30)];
            system.debug('KTDO1__Job_Application__c>>'+con4);
           
            recData.onBoard = String.valueOf(con.get('expr0'));
            recData.internalSubmit = String.valueOf(con1.get('expr0'));
            recData.onInterview = String.valueOf(con2.get('expr0'));
            recData.interviewCleared = String.valueOf(con3.get('expr0'));
            recData.offerLetter = String.valueOf(con4.get('expr0'));
            recData.selectName=selectedName;
        }
        else if(selectedValue=='This Year'){
            AggregateResult con = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Onboard' AND LastModifiedDate = LAST_N_DAYS:365)];
            system.debug('KTDO1__Job_Application__c>>'+con);
            
            AggregateResult con1 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Internal Submit' AND LastModifiedDate = LAST_N_DAYS:365)];
            system.debug('KTDO1__Job_Application__c>>'+con1);
           
            AggregateResult con2 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='On Interview Process' AND LastModifiedDate = LAST_N_DAYS:365)];
            system.debug('KTDO1__Job_Application__c>>'+con2);
    
            AggregateResult con3 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Interview Cleared' AND LastModifiedDate = LAST_N_DAYS:365)];
            system.debug('KTDO1__Job_Application__c>>'+con3);
    
            AggregateResult con4 = [SELECT COUNT(Id)  FROM KTDO1__Job_Application__c where (KTDO1__Profile_Status__c ='Offer Letter' AND LastModifiedDate = LAST_N_DAYS:365)];
            system.debug('KTDO1__Job_Application__c>>'+con4);
           
            recData.onBoard = String.valueOf(con.get('expr0'));
            recData.internalSubmit = String.valueOf(con1.get('expr0'));
            recData.onInterview = String.valueOf(con2.get('expr0'));
            recData.interviewCleared = String.valueOf(con3.get('expr0'));
            recData.offerLetter = String.valueOf(con4.get('expr0'));
            recData.selectName=selectedName;
        }
        return recData;
        
    }

    public class recruiterWrap{
        @AuraEnabled
        public String onBoard;
        @AuraEnabled
        public String internalSubmit;
        @AuraEnabled
        public String onInterview; 
        @AuraEnabled
        public String interviewCleared; 
        @AuraEnabled
        public String offerLetter; 
        @AuraEnabled
        public String selectName; 
    }
    
    @AuraEnabled
    public static User searchRecruiterData(String enteredValue){
        String searchKey = '%' + enteredValue + '%';
        User fetchRecruiterData=[Select Name from User where Name like : searchKey  LIMIT 1];        
        system.debug('fetchRecruiterData :'+fetchRecruiterData);
        return fetchRecruiterData;
    }

    @AuraEnabled
           public static List<Contact> getContact(){
            KTDO1__Job_Posting__c con = [SELECT Id,Name,KTDO1__Account__c  FROM KTDO1__Job_Posting__c where Name ='Job - Delloite' LIMIT 1];
            system.debug('con'+con);
            Account a = [Select Id, Name,(Select Id,Name,Phone,Email,KTDO1__Venue_Details__c,KTDO1__SkypeId__c from Contacts) from Account where Id=:con.KTDO1__Account__c];
            system.debug('a'+a);
            return a.Contacts;
            
        }
    

        @AuraEnabled
           public static void getContactDetails(){
            List <KTDO1__Job_Application__c> lstOfValues = [Select Id,KTDO1__Status__c,KTDO1__Profile_Status__c from KTDO1__Job_Application__c ];
            system.debug('KTDO1__Job_Application__c:'+lstOfValues);
            KTDO1__Job_Application__c p =new KTDO1__Job_Application__c();
            p.KTDO1__Profile_Status__c='On Interview Process';
            update p;
        }
     
}