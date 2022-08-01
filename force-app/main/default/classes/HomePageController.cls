public class HomePageController {
    
    @AuraEnabled        
    public static List<Job_Posting__c> getJobPosting(String companyFilter, String postStatus) {
        String currentUser = UserInfo.getUserId();
        system.debug('fetchdata :'+UserInfo.getUserId());
        /*String currentUserName = UserInfo.getName();
system.debug('fetchdataName :'+UserInfo.getName());

List<CustomTeams__Team_Members__c> userTeam =  [Select CustomTeams__Team__r.Name from CustomTeams__Team_Members__c where CustomTeams__User__r.Name =: currentUserName];
system.debug('userTeam>>>'+userTeam);*/
        
        /*String qryJobPosting ='Select Teams__c,Name,Posting_Due_Date__c,No_Of_Candidate_Selected__c,Job_OC_Status__c from Job_Posting__c';
String qryjobPostingWhereClause = ' ' ;
system.debug('qryJobPosting'+qryJobPosting);

for(Integer i=0; i<userTeam.size(); i++){
qryjobPostingWhereClause+=' (Teams__r.Name =\''+userTeam[i]+'\')';
system.debug('qryjobPostingWhereClause'+qryjobPostingWhereClause);
}
qryJobPosting = qryJobPosting+ qryjobPostingWhereClause ;
system.debug('qryJobPosting'+qryJobPosting);

List<Job_Posting__c> listOfValues = Database.query(qryJobPosting);  

System.debug('listOfValues'+listOfValues);*/
        //   String companyFilter = 'Sony India';
        String querry = 'Select Account__r.Name, Teams__c,Name,Posting_Due_Date__c,No_Of_Candidate_Selected__c,Job_OC_Status__c from Job_Posting__c WHERE Id <> null ';
        if(String.isNotBlank(companyFilter)){
            querry+= ' AND Account__r.Name = :companyFilter';
        }
        if(String.isNotBlank(postStatus)){
            querry+= ' AND Job_OC_Status__c = :postStatus';
        }
        System.debug(LoggingLevel.DEBUG, querry+'####Querry final');
        List<Job_Posting__c> listOfValues = Database.query(querry);
        system.debug('listOfValues>>>'+listOfValues);
        //Added by Dharshan
        for(Job_Posting__c values : listOfValues){
            if(values.Posting_Due_Date__c != null){
                //Due Date
                DateTime dueDate = values.Posting_Due_Date__c;
                System.debug('Due Date>>'+dueDate);
                String dueDateStr1 = dueDate.format('yyyy-MM-dd');
                System.debug('Due Date>>'+dueDateStr1);
                //Today date
                DateTime todaysDate = System.today();
                String todaysDateStr = todaysDate.format('yyyy-MM-dd');
                System.debug('Today date>>'+todaysDateStr);
                
                if(todaysDateStr > dueDateStr1){
                    values.Job_OC_Status__c = 'Closed';
                }
                update values;
            }
        }
        //ENDED by Dharshan  
        
        List<Job_Posting__c> lstOfAddedList = new List<Job_Posting__c>();
        for(Job_Posting__c teamMember : listOfValues){
            List<CustomTeams__Team_Members__c> lstOfMember = [Select CustomTeams__User__c from CustomTeams__Team_Members__c where CustomTeams__Team__c =: teamMember.Teams__c];
            for(CustomTeams__Team_Members__c member : lstOfMember){
                system.debug('fetchdata :'+UserInfo.getUserId());
                system.debug('member.CustomTeams__User__c'+member.CustomTeams__User__c);
                if(member.CustomTeams__User__c == UserInfo.getUserId()){
                    lstOfAddedList.add(teamMember);
                    system.debug('lstOfAddedList>>'+lstOfAddedList);
                }
            }
        }
        system.debug('Job_Posting__c>>>'+listOfValues);
        return lstOfAddedList;
    }
    
    @AuraEnabled
    public static Map<String,String> getClientList(){
        
        Map<String,String> clientList = new Map<String,String>();
        List<Job_Posting__c> client = [SELECT Account__r.Name, Name FROM Job_Posting__c WHERE Account__r.Name <> null];
        for (Job_Posting__c data : client) {
            System.debug(data);
            System.debug(data.Account__r.Name);
            clientList.put(data.Account__r.Id, data.Account__r.Name);
            
        }
        System.debug((clientList));
        return clientList;
    }
    
    @AuraEnabled
    public static Map<String,String> getStatusList(){
        Schema.DescribeFieldResult statusfield = Job_Posting__c.Job_OC_Status__c.getDescribe();
        Map<String,String> statusList = getPickListValuesIntoMap(statusfield);
        return statusList;
    }
    
    public static Map<String,String> getPickListValuesIntoMap(Schema.DescribeFieldResult objval){
        Map<String,String> pickListValuesMap= new Map<String,String>();
        List<Schema.PicklistEntry> ple = objval.getPicklistValues();
        if(!(ple.isEmpty())){
            for (Schema.PicklistEntry var : ple) {
                pickListValuesMap.put((var.getValue()).toUpperCase(), (var.getLabel()).toUpperCase());
            }
        }
        return pickListValuesMap;
    }
    
    @AuraEnabled
    public static  List<JobPostingsWrap> togetJobPostings(String companyFilter, String postStatus,String buttonType, String buttonTypeId){
        //System.debug('items>>.'+items);
        System.debug('companyFilter>>'+companyFilter);
        System.debug('postStatus>>'+postStatus);
        System.debug('buttonType>>'+buttonType);
        System.debug('buttonTypeId>>'+buttonTypeId);
        String currenUser = UserInfo.getUserId();
        system.debug('currenUser>>>'+currenUser);
        List<CustomTeams__Team_Members__c> teammember = [Select Name,CustomTeams__Team__c from CustomTeams__Team_Members__c where CustomTeams__User__c =:currenUser  ];
        system.debug('teammember>>'+teammember);
        Set<Id> teamMemberId = new Set<Id>();
        for(Integer i =0; i<teammember.size(); i++){
            teamMemberId.add(teammember[i].CustomTeams__Team__c);
            system.debug('teamMemberId>>>'+teamMemberId);
        }
        system.debug('teamMemberId>>>'+teamMemberId);
        
        
    //     List<Account> userAccnts = new List<Account>();
    //    // userAccnts = [Select Name from Account where CreatedById =: currenUser];
    //    userAccnts = [Select Name from Account ];
    //     system.debug('userAccnts>>'+userAccnts);
        
        
        Schema.sObjectField dependentField = Job_Application__c.Status__c;
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
                        system.debug('controllerValue>>'+controllerValue);
                        
                        dependentPicklistValues.put(controllerValue, new List<String>());
                        
                    }
                    dependentPicklistValues.get(controllerValue).add(entry.getLabel());
                    system.debug('controllerValue>>'+entry.getLabel());
                }
            }
        }
        system.debug('dependentPicklistValues ::'+dependentPicklistValues);
        List<JobPostingsWrap> JobPostingsWrapList = new List<JobPostingsWrap>();
        
        
        if(buttonType != '' && buttonTypeId != ''){
            Job_Application__c lstOfValues = [Select Name,Job_Posting__c,Candidate_Profile__r.Designation__c,Candidate_Profile__r.Experience__c,Candidate_Profile__r.Skills__c,Candidate_Profile__r.Current_Location__c,Candidate_Profile__r.Notice_Period__c,Profile_Status__c,Status__c from Job_Application__c where Id =:buttonTypeId ];
            system.debug('Job_Application__c:'+lstOfValues);
            
            lstOfValues.Profile_Status__c = buttonType; 
            update lstOfValues;
            List<JobApplicationWrap> JobApplicantsWrapList1 = new List<JobApplicationWrap>();
            JobPostingsWrap JobPostingsWrapVal = new JobPostingsWrap();
            JobApplicationWrap JobApplicantsWrapVal = new JobApplicationWrap();
            JobApplicantsWrapVal.JobApplication = lstOfValues;
            system.debug('dependentPicklistValues.get(lstOfValues.Profile_Status__c)   :::'+dependentPicklistValues.get(lstOfValues.Profile_Status__c));
            JobApplicantsWrapVal.StatusButtons = dependentPicklistValues.get(lstOfValues.Profile_Status__c);
            JobApplicantsWrapList1.add(JobApplicantsWrapVal);
            JobPostingsWrapVal.JobApplicationWrapList = JobApplicantsWrapList1;
            system.debug('JobPostingsWrapVal>>'+JobPostingsWrapVal);
            JobPostingsWrapList.add(JobPostingsWrapVal);
            system.debug('JobPostingsWrapList>>'+JobPostingsWrapList);
            system.debug('JobPostingsWrapList>>>>>'+JobPostingsWrapList[0].JobApplicationWrapList);
            //return JobPostingsWrapList[0].JobApplicationWrapList[0];
            return JobPostingsWrapList; 
        }
        else{
           /* List<Job_Posting__c> jobPostings = [Select Id,Name,Account__r.Name,Posting_Due_Date__c,Teams__c  ,No_Of_Candidate_Selected__c,Job_OC_Status__c,
                                                (Select Name,Candidate_Profile__r.Designation__c,Candidate_Profile__r.Experience__c,Candidate_Profile__r.Skills__c,
                                                Candidate_Profile__r.Current_Location__c,Candidate_Profile__r.Notice_Period__c,Profile_Status__c,Status__c from Job_Applications__r) 
                                                from Job_Posting__c where   Teams__c  IN :teamMemberId  ];
            system.debug('jobPostings>>'+jobPostings);*/
            
        String querry = 'Select Id,Name,Account__r.Name,Posting_Due_Date__c,Teams__c  ,No_Of_Candidate_Selected__c,Job_OC_Status__c,(Select Name,Candidate_Profile__r.Designation__c,Candidate_Profile__r.Experience__c,Candidate_Profile__r.Skills__c,Candidate_Profile__r.Current_Location__c,Candidate_Profile__r.Notice_Period__c,Profile_Status__c,Status__c from Job_Applications__r) from Job_Posting__c where   Teams__c  IN :teamMemberId ';
        if(String.isNotBlank(companyFilter)){
            querry+= ' AND Account__r.Name = :companyFilter';
        }
        if(String.isNotBlank(postStatus)){
            querry+= ' AND Job_OC_Status__c = :postStatus';
        }
        System.debug(LoggingLevel.DEBUG, querry+'####Querry final');
        List<Job_Posting__c> listOfValues = Database.query(querry);
        system.debug('listOfValues>>>'+listOfValues);
            
            for(Job_Posting__c jobPostingValues : listOfValues)
            {
                JobPostingsWrap JobPostingsWrapVal = new JobPostingsWrap();
                JobPostingsWrapVal.JobPosting = jobPostingValues;
                
                List<JobApplicationWrap> JobApplicationWrapList1 = new List<JobApplicationWrap>() ;
                system.debug('jobPostingValues>>'+jobPostingValues);
                system.debug('jobPostingValues.Job_Applications__r>>'+jobPostingValues.Job_Applications__r);
                for(Job_Application__c jobApplication : jobPostingValues.Job_Applications__r){
                    JobApplicationWrap JobApplicationWrapVal = new JobApplicationWrap();
                    JobApplicationWrapVal.JobApplication = jobApplication;
                    JobApplicationWrapVal.StatusButtons = dependentPicklistValues.get(jobApplication.Profile_Status__c);
                    // String allstring = string.join(dependentPicklistValues.get(values.Profile_Status__c),',');
                    system.debug('dependentPicklistValues.get(jobApplication.Profile_Status__c)   :::'+dependentPicklistValues.get(jobApplication.Profile_Status__c));
                    //JobApplicationWrapList1.add(JobApplicantsWrapVal);
                    
                    JobApplicationWrapList1.add(JobApplicationWrapVal);
                    system.debug('JobApplicationWrapList1 Inside>>'+JobApplicationWrapList1);
                }
                JobPostingsWrapVal.JobApplicationWrapList = JobApplicationWrapList1;
                system.debug('JobPostingsWrapVal>>'+JobPostingsWrapVal);
                
                JobPostingsWrapList.add(JobPostingsWrapVal);
                system.debug('JobPostingsWrapList>>'+JobPostingsWrapList);
                // JobPostingsWrapVal.JobApplicationWrapList = JobPostingsWrapList;
                // system.debug('JobPostingsWrapList>>'+JobPostingsWrapList);
            }
        }
        system.debug('JobPostingsWrapList>>'+JobPostingsWrapList);
        return JobPostingsWrapList;
        
    }
    
    
    
    public class JobPostingsWrap
    {
        
        @AuraEnabled public Job_Posting__c JobPosting = new Job_Posting__c();
        @AuraEnabled public List<JobApplicationWrap> JobApplicationWrapList = new List<JobApplicationWrap>() ;
    }
    public class JobApplicationWrap
    {
        @AuraEnabled public List<string> StatusButtons ;
        @AuraEnabled public Job_Application__c JobApplication = new Job_Application__c();
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
    public static List<Contact> getContact(String jobId){
        system.debug('jobId>>>'+jobId);
        Job_Posting__c con = [SELECT Id,Name,Account__c  FROM Job_Posting__c where Id =: jobId LIMIT 1];
        system.debug('con'+con);
        Account a = [Select Id, Name,(Select Id,Name,Phone,Email,Venue_Details__c,SkypeId__c from Contacts) from Account where Id=:con.Account__c];
        system.debug('a'+a);
        return a.Contacts;
        
    }
    
    @AuraEnabled
    public static String scheduleMeeting(String timeDate,String hostEmail,String candEmail){

        system.debug('timeDate>>>>'+timeDate);
        system.debug('hostEmail>>>'+hostEmail);
        system.debug('candEmail>>>>'+candEmail);
        
        String endpointURL = 'callout:Zoom_Offer_letter'; // Named Credential
        HttpRequest request = new HttpRequest(); 
        request.setMethod('POST');
        request.setEndpoint('callout:Zoom_Offer_letter/');
        request.setHeader('Content-type', 'application/json');    
        request.setBody(jsonGenerator(timeDate));
        System.debug('jsonGenerator(timeDate)>>'+jsonGenerator(timeDate));
        Http http = new Http();
      	HTTPResponse res = http.send(request);
        System.debug('Request Sent');
        system.debug('Body'+res.getBody());
        System.debug('response1 ==>>'+res.getHeaderKeys());
        System.debug('response1 ==>>'+res.getStatus());
        System.debug('response1 ==>>'+res.getStatusCode());
        JSONParser parser = JSON.createParser(res.getBody());
        JSONParser parser1 = JSON.createParser(res.getBody());
        String hostURL='';
        String join_url='';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'start_url')) {
                    // Get the value.
                    parser.nextToken();
                    
                    // Compute the grand total price for all invoices.
                    hostURL += parser.getText();
                }
        }
        while (parser1.nextToken() != null) {
            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser1.getText() == 'join_url')) {
                    // Get the value.
                    parser1.nextToken();
                    
                    // Compute the grand total price for all invoices.
                    join_url += parser1.getText();
                }
        }
        system.debug('hostURL>>>>'+hostURL);
        system.debug('join_url>>>'+join_url);

        //SEND MAIL TO ADDRESS STARTS
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
        toAddresses.add(hostEmail);
        toAddresses.add(candEmail);
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Zoom Meeting');
        mail.setSubject('Zoom Meeting Shedule');
        mail.setPlainTextBody('Hello,\n\n Join the meeting ahead of schedule using a laptop/desktop and reliable internet connection using this link : \n'+hostURL+'\n\n Kindly acknowledge this mail by your acceptance  \n\n Warm Regards \n Admin');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        //SEND MAIL TO ADDRESS ENDS

        return 'response';
        
    }
    
    public static string jsonGenerator(String timeDate){
        System.debug('timeDate>>'+timeDate);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('agenda','Meeting Agenda Introduction');
        gen.writeObjectField('default_password','false');
        gen.writeObjectField('duration','60');
        gen.writeObjectField('password','123456');
       
        // gen.writeObjectField('schedule_for','sdkulkarni15@gmail.com'); //  
        gen.writeFieldName('settings');
        gen.writeStartObject();
        gen.writeObjectField('host_video',false);
        gen.writeObjectField('allow_multiple_devices',false);
        gen.writeObjectField('participant_video',false);
        gen.writeObjectField('join_before_host',false);
        gen.writeObjectField('mute_upon_entry',true);
        gen.writeObjectField('use_pmi',false);
        gen.writeObjectField('approval_type',0);
        gen.writeEndObject();
        gen.writeObjectField('start_time','2022-06-01T18:30:00Z'); // '2022-06-01T18:30:00Z'= 2022-07-06T13:30:00.000Z
        
        gen.writeObjectField('timezone','Asia/Calcutta'); // Time Zone
        gen.writeObjectField('topic','Intrview with Sony');
        gen.writeObjectField('type','2');
        gen.writeEndObject();
        string payload=gen.getAsString();
        System.debug('payload body'+payload);
        return payload;
    }

    @AuraEnabled
    public static String getCandEmail(String candidateID) {
        system.debug('candidateID>>>'+candidateID);
        Candidate_Profile__c email = [Select Email__c from Candidate_Profile__c  where Id=:candidateID];
        system.debug('email.Email__c>>>'+email.Email__c);
        return email.Email__c;
    }

    @AuraEnabled
    public static String getHostEmail(String hostID) {
        system.debug('hostID>>>'+hostID);
        Contact email = [Select Email from Contact where Id=: hostID];
        system.debug('email>>>'+email.Email);
        return email.Email;
    }
    
    @AuraEnabled
    public static List<Comment__c> saveComment(Id appId, String comment){
        system.debug('appId>>>'+appId);
        system.debug('comment>>>'+comment);
        String userName = UserInfo.getName();
        system.debug('userName>>>'+userName);
                
        Comment__c commentValue = new Comment__c(Job_Application__c=appId,Remarks__c=comment,User__c=userName);
        insert commentValue;
        List<Comment__c> updatedComments = getComments(appId);
        system.debug('updatedComments>>>'+updatedComments);
        return updatedComments;
    }
    
    @AuraEnabled
    public static List<Comment__c> getComments(Id appId){
        system.debug('appId>>>'+appId);
        List<Comment__c> comments = [Select Job_Application__c,Remarks__c,User__c from Comment__c where Job_Application__c =:appId ];
        system.debug('comments>>>'+comments);
        return comments;  
    }
}