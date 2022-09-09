public class smartSearchController {
    
    @AuraEnabled        
    public static boolean getDepartmentPickListValues1(List<Skill_Set__c> skills) {
        system.debug('skills1>>>'+skills);
        for (Skill_Set__c fetch : skills){
            system.debug('skills>>>'+fetch.Name);
        }
        return true;
    } 
    
    @AuraEnabled        
    public static List<String> getDepartmentPickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Skill_Set__c.Department__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }

    @AuraEnabled
    public static List<Candidate_Profile__c> getCustomerProfile(String curLocation,String expCTC,String minExperience,String maxExperience, String noticePer, List<Skill_Set__c> skills){
        system.debug('curLocation>>>'+curLocation);
        system.debug('expCTC>>>'+expCTC);
        system.debug('minExperience>>>'+minExperience);
        system.debug('maxExperience>>>'+maxExperience);
        system.debug('noticePer>>>'+noticePer);
        system.debug('skills>>>'+skills);
        
        String qryPbProDetails='select id,name,Current_Location__c,Expected_CTC__c, Experience__c, Notice_Period__c, Skills__c, Designation__c, Annual_CTC__c, Gmail__c, Phone__c from Candidate_Profile__c'; 
        String qryPbProWhereClause=' where Notice_Period__c =\''+noticePer+'\'';
        
        //expectedCTC
        if(!String.isBlank(expCTC) && expCTC != ',')
        {
            List<String> lstexpCTC = expCTC.split(',');
            System.debug('lstexpCTC>>'+lstexpCTC);
            Decimal minExpCTC  = decimal.valueOf(lstexpCTC[0]);
            Decimal maxExpCTC  = decimal.valueOf(lstexpCTC[1]);
            System.debug('minExpCTC>>'+minExpCTC+'<<maxExpCTC>>'+maxExpCTC);
            
            qryPbProWhereClause+=' AND Expected_CTC__c >='+minExpCTC+' AND Expected_CTC__c <='+maxExpCTC;
        }
        
        //currentLocation
        if(!String.isBlank(curLocation))
        {
            qryPbProWhereClause+=' AND Current_Location__c <=\''+curLocation+'\'';
        }
        
        //experience
        if(!String.isBlank(minExperience) && !String.isBlank(maxExperience))
        {
            qryPbProWhereClause+=' AND Experience__c >='+minExperience+' AND Experience__c <='+maxExperience;
        }
        
        
        //skills
        if(skills != null) {
            for (Skill_Set__c fetch : skills){
                system.debug('skills>>>'+fetch.Name);
                qryPbProWhereClause+=' AND Skills__c =\''+fetch.Name+'\'';
            }
        } 
        
        //preferred Location
        // if(preLocation != null) {
        //     for (Location_Set__c fetchLoc : preLocation){
        //         system.debug('preLocation>>>'+fetchLoc.Name);
        //         qryPbProWhereClause+=' AND Preferred_Location__c =\''+fetchLoc.Name+'\'';
        //     }
        // }
        qryPbProDetails=qryPbProDetails + qryPbProWhereClause;
        System.debug('qryPbProDetails>>'+qryPbProDetails);
        List<Candidate_Profile__c> listOfCandidates = (Database.query(qryPbProDetails));   
        return listOfCandidates;
    }


    @AuraEnabled        
    public static List<String> getNoticePerPickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.Notice_Period__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    //Method to fetch the Lookup Results of the Skills
    @AuraEnabled
    public static List<Skill_Set__c> fetchSkillsDataList(String enteredValue,String department) {
        
        String searchKey = enteredValue + '%';
        List <Skill_Set__c> lstOfValues = [Select Name,Department__c from Skill_Set__c where Department__c =: department AND Name like : searchKey LIMIT 10];
        system.debug('lstOfValues>>>'+lstOfValues);
        return lstOfValues;
    }
    
    //Method to fetch the Lookup Results of the Preferred Location
    @AuraEnabled
    public static List<Account> fetchPreLocationDataList(String enteredValue) {
        
        String searchKey = enteredValue + '%';
        List <Account> lstOfValues = [SELECT Name FROM Account where Name like : searchKey LIMIT 10];
        system.debug('Account>>>'+lstOfValues);
        return lstOfValues;
    }

    //Method to fetch the Document Master Record list
    @AuraEnabled
    public static List<Document_Master__c> fetchDocumentList(String enteredDocValue) {
        
        String searchKey = enteredDocValue + '%';
        List <Document_Master__c> lstOfDoc = [SELECT Name FROM Document_Master__c WHERE Job_Posting_Documents__c = null AND Name like : searchKey LIMIT 10];
        system.debug('lstOfDoc>>>'+lstOfDoc);
        return lstOfDoc;
    }
    
    
    @AuraEnabled        
    public static List<String> getJoiningInPickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Job_Posting__c.Notice_Period__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Notice_Period__c are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }

    @AuraEnabled        
    public static List<String> getJobReqTypePicklist() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Job_Posting__c.Job_Requirement_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Job_Requirement_Type__c are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }

    /* private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = : fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }


    @AuraEnabled
    public static List<ContentDocumentLink> fetchDocument (Id parentID)
    {
        String imageURL='';
        system.debug('ID ::'+parentID);
        List<ContentDocumentLink> attList = [SELECT ContentDocumentId  FROM ContentDocumentLink  
                                             WHERE LinkedEntityId  =:parentID ];  
        system.debug('attList ::'+attList);
        //    if(attList.size() > 0){
        //         imageURL='/servlet/servlet.FileDownload?file='+attList[0].id;
        //      system.debug('imageURL ::'+imageURL);
        //    }
        
        return attList;
    }
    */

    @AuraEnabled
    public static List<Candidate_Profile__c> fetchCandidateDataList(String enteredValue) {
        
        String searchKey = enteredValue + '%';
        List <Candidate_Profile__c> lstOfValues = [Select Name from Candidate_Profile__c where Name like : searchKey LIMIT 10];
        system.debug('Candidate_Profile__c>>>'+lstOfValues);
        return lstOfValues;
    }
    
    @AuraEnabled        
    public static List<String> getIndustryPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.Industry__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getFunctionalAreaPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.Functional_Area__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getDesignationPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.Designation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getStreamPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.UG_Stream__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getPGStreamPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.PG_Stream__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<Candidate_Profile__c> getCandidateProfile(List<String> skillexp, boolean buttonSelected) {
        system.debug('skillexp>>>'+skillexp);
        system.debug('SelectedButton>>>'+buttonSelected);
        String qryPbProDetails='select name,SkillSet_Experience__c,Candidate_Profile__c, Skill_Set_Experience__c.Candidate_Profile__r.Name, Skill_Set_Experience__c.Candidate_Profile__r.Email__c, Skill_Set_Experience__c.Candidate_Profile__r.Phone__c, Skill_Set_Experience__c.Candidate_Profile__r.Current_Location__c,Skill_Set_Experience__c.Candidate_Profile__r.Designation__c,Skill_Set_Experience__c.Candidate_Profile__r.Employers__c,Skill_Set_Experience__c.Candidate_Profile__r.Annual_CTC__c,Skill_Set_Experience__c.Candidate_Profile__r.Expected_CTC__c from Skill_Set_Experience__c where '; 
        
        String qryPbProWhereClause = ' ' ;
        system.debug('qryPbProDetails'+qryPbProDetails);
        
        for(Integer i=0; i<skillexp.size(); i+=2){
            system.debug('Skill>>'+skillexp[i]+skillexp[i+1]);
            qryPbProWhereClause+=' (Name =\''+skillexp[i]+'\'';
            qryPbProWhereClause+=' AND SkillSet_Experience__c =\''+skillexp[i+1]+'\')';
            system.debug('qryPbProWhereClause'+qryPbProWhereClause);
        }
        if(buttonSelected==true){
            system.debug('Inside');
            qryPbProWhereClause+=' AND LastModifiedDate = LAST_N_DAYS:15 ';
            system.debug('qryPbProWhereClause>>'+qryPbProWhereClause);
        }
        
        qryPbProDetails = qryPbProDetails+ qryPbProWhereClause ;
        system.debug('qryPbProDetails'+qryPbProDetails);
        
        List<Skill_Set_Experience__c> listOfCandidates = (Database.query(qryPbProDetails));  
        
        System.debug('listOfCandidates'+listOfCandidates);
        
        //For filtering Duplicate Candidate id's
        Set<String> skills = new Set<String>();
        for(Integer i =0;i<listOfCandidates.size();i++){
            //System.debug('listOfCandidates'+listOfCandidates[i].Candidate_Profile__c);
            if(listOfCandidates[i].Candidate_Profile__c!= null){
                if(skills.contains(listOfCandidates[i].Candidate_Profile__c)){
                    System.debug('Inside');
                }else{
                    skills.add(listOfCandidates[i].Candidate_Profile__c);
                    
                }
            } 
        }
        
        List<Candidate_Profile__c> candProfile = [select Name,Email__c,Phone__c,Current_Location__c,Designation__c,Employers__c,Expected_CTC__c,Annual_CTC__c,(select Name,SkillSet_Experience__c from Skill_Set_Experiences__r) from Candidate_Profile__c where Id  IN : skills];
        
        system.debug('candProfile>'+candProfile);
        
        
        
        return candProfile;
    }

    @AuraEnabled 
    public static List<String> getsObjects(){
        List<String> sObjectList = new List<String>();
        FOR(Schema.SObjectType sObj : Schema.getGlobalDescribe().values()){
            // Show only those objects which have atleast one Field Set
            Map<String, Schema.FieldSet> FieldSetMap = sObj.getDescribe().fieldSets.getMap();
            if(FieldSetMap!=null && FieldSetMap.keySet().size() > 0){
                sObjectList.add(sObj.getDescribe().getName() +'####'+sObj.getDescribe().getLabel());
            }
        }
        return sObjectList;
    }

    
    @AuraEnabled        
    public static List<Job_Posting__c> getJobPostingPickListValues(String clientId) {
        system.debug('clientId>>'+clientId);
        List <Job_Posting__c> lstOfValues = [Select Name from Job_Posting__c where Account__c =:clientId  LIMIT 10];
        system.debug('Job_Posting__c>>>'+lstOfValues);
        return lstOfValues;
    }    
    
    @AuraEnabled        
    public static boolean saveJobApplication(List<String> job) {
        system.debug('job>>'+job);
        
        Job_Application__c lstOfValues = new Job_Application__c(Name=job[0],Candidate_Profile__c=job[1],Job_Posting__c=job[2]);
        system.debug('Job_Application__c>>>'+lstOfValues);
        lstOfValues.Client_Approval_Process__c = 'Deloitte';
        lstOfValues.Profile_Status__c = 'Open';
        insert lstOfValues;
        
        List<Document_Master__c> docs = [select Id,Name,Job_Posting_Documents__c from Document_Master__c where Job_Posting_Documents__c =: job[2]];
        system.debug('docs>>'+docs);
        List<Job_Posting_Document__c> documentList = new  List<Job_Posting_Document__c>();
        if(docs != null){
            for(Document_Master__c doc : docs){
                Job_Posting_Document__c document = new Job_Posting_Document__c(Name = doc.Name,Document_Master__c=doc.Id,Job_Posting__c=job[2],Job_Application__c=lstOfValues.Id);
                documentList.add(document);
                system.debug('document>'+document);
            }
            insert documentList;
        }
        
        return true;
    }

    @AuraEnabled        
    public static List<CustomTeams__Teams__c> getTeams() {
        List <CustomTeams__Teams__c> lstOfTeam = [select Name from CustomTeams__Teams__c];
        system.debug('CustomTeams__Teams__c>>>'+lstOfTeam);
        return lstOfTeam;
    }
    
    @AuraEnabled        
    public static List<CustomTeams__Team_Members__c> getTeamMembers(String team) {
        system.debug('team>>>'+team);
        List <CustomTeams__Team_Members__c> lstOfTeamMembers = [Select CustomTeams__User__r.Name from CustomTeams__Team_Members__c where CustomTeams__Team__r.Id =: team];
        system.debug('CustomTeams__Team_Members__c>>>'+lstOfTeamMembers);
        return lstOfTeamMembers;
    }

    @AuraEnabled        
    public static List<CustomTeams__Teams__c> getTeamBasedOnAcc(String account) {
        system.debug('account>>>'+account);
        List <CustomTeams__Teams__c> lstOfTeam = [Select Id,Name from CustomTeams__Teams__c where Account__c =: account];
        system.debug('CustomTeams__Teams__c>>>'+lstOfTeam);
        return lstOfTeam;
    }


    @AuraEnabled        
    public static List<String> getSkillSetRatingPickList() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Skill_Set_Experience__c.Ratings__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }


    @AuraEnabled        
    public static Boolean getJobPostingValues(Id jobId, String candSkills) {
        system.debug('jobId>>>'+jobId);
        system.debug('candSkills>>>'+candSkills);

        //Querying skills from job posting
        List <Skill_Set_Experience__c> lstOfValues = new  List <Skill_Set_Experience__c>();
        List <Job_Posting__c> pauseCheck = [select Id from Job_Posting__c where Id =: jobId AND Job_OC_Status__c <> 'Pause'];

        if(pauseCheck.size() <> 0){
        lstOfValues = [select Name,Skill_Experience_Level__c from Skill_Set_Experience__c where Job_Posting__c =: jobId];
        system.debug('Skill_Set_Experience__c>>>'+lstOfValues);
        }

        //Deserializing JSON Response
        List<Skill_Set_Experience__c> deserializeSkill = (List<Skill_Set_Experience__c>) System.JSON.deserialize(candSkills, List<Skill_Set_Experience__c>.Class);
        
        system.debug('deserializeSkill>>'+deserializeSkill);

        //Assigning jobposting skill values to Map
        Map<String,String> jobSkillsMap = new Map<String,String>();
        for(Skill_Set_Experience__c skillsName : lstOfValues){
            jobSkillsMap.put(skillsName.Name, skillsName.Skill_Experience_Level__c);
            system.debug('jobSkillsMap>>>'+jobSkillsMap);
        }
        Boolean skillsValues = false;

        //Comparing Candidate Skills and Job Posting Skills
        for(Skill_Set_Experience__c skillsCompare : deserializeSkill){
            system.debug('skillsCompare>>'+skillsCompare);
            if(jobSkillsMap.containsKey(skillsCompare.Name) ){
                if(jobSkillsMap.get(skillsCompare.Name) == skillsCompare.Skill_Experience_Level__c){
                    skillsValues = true;
                }
                
            }

        }
        system.debug('skillsValues>>>'+skillsValues);
       
        return skillsValues;
   
    }
    
    @AuraEnabled        
    public static List<Account> getClientPicklistValues() {
        List <Job_Posting__c> lstOfValues = [Select Account__r.Name from Job_Posting__c ];
        system.debug('Job_Posting__c>>>'+lstOfValues);
        Set<Id> accountSetId = new Set<Id>();
        for(Integer i =0; i<lstOfValues.size(); i++){
            accountSetId.add(lstOfValues[i].Account__c);
           
            system.debug('accountSetId>>>'+accountSetId);
        }
       List<Account> accountName = [Select Name from Account where Id IN : accountSetId];
       system.debug('accountName>>>'+accountName);
        return accountName;
    }  

    @AuraEnabled        
    public static List<String> getJobTypePickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Job_Posting__c.Job_Requirement_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getEdTypePicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.UG_Education_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }

    @AuraEnabled        
    public static List<String> getPGEdTypePicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Candidate_Profile__c.PG_Education_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }

    @AuraEnabled        
    public static List<String> getJobPostingDocList(String jobPostingId) {
        System.debug('jobPostingId>>>'+jobPostingId);
        List<String> jobPostingDocList = new List<String>();
        List<Job_Posting_Document__c> lstOfValues = [Select Id from Job_Posting_Document__c where Job_Posting__c =: jobPostingId];
        for(Job_Posting_Document__c values : lstOfValues){
            jobPostingDocList.add(values.Id);
        }
        System.debug('jobPostingDocList>>>'+jobPostingDocList);
        return jobPostingDocList;
    }

    @AuraEnabled        
    public static List<String> getJobPostingSkillExpList(String jobPostingId) {
        System.debug('jobPostingId>>>'+jobPostingId);
        List<String> jobPostingSkillExpList = new List<String>();
        List<Skill_Set_Experience__c> lstOfValues = [Select Id from Skill_Set_Experience__c where Job_Posting__c =: jobPostingId];
        for(Skill_Set_Experience__c values : lstOfValues){
            jobPostingSkillExpList.add(values.Id);
        }
        System.debug('jobPostingSkillExpList>>>'+jobPostingSkillExpList);
        return jobPostingSkillExpList;
    }

    @AuraEnabled        
    public static CustomTeams__Teams__c getTeamBasedOnAccEdit(String jobPostingId) {
        system.debug('jobPostingId>>>'+jobPostingId);
        Job_Posting__c team = [Select Teams__c from Job_Posting__c where Id =: jobPostingId];
        CustomTeams__Teams__c lstOfTeam = [Select Id,Name from CustomTeams__Teams__c where Id =: team.Teams__c];
        system.debug('CustomTeams__Teams__c>>>'+lstOfTeam);
        return lstOfTeam;
    }


    @AuraEnabled
    public static List<Skill_Set_Experience__c> saveCandidateProfile(Candidate_Profile__c candFields, List<Skill_Set_Experience__c> skills, List<Roll_and_Responsibilities__c> rolesAndResp){
        system.debug('candFields>>'+candFields);
        system.debug('skills>>'+skills);
        system.debug('rolesAndResp>>'+rolesAndResp);
       
        String candId = candFields.Id;
        system.debug('candId>>'+candId);

        //If candidate Id is present then update the existing record else create new
        if(candId != null){
            update candFields; 
        }else{
            insert candFields;
        }
        //insert candFields;
        system.debug('candFields>>'+candFields);
        //Removing duplicate skill id
        Set<Id> skillSet = new Set<Id>();
        
        for(Integer i =0; i<skills.size(); i++){
            system.debug(skills[i].Skill_Set__c);
            skillSet.add(skills[i].Skill_Set__c);

        }
        system.debug('skillSet'+skillSet);

        //Getting Skill name with skill id
        List<Skill_Set__c> skillName = [Select Name from Skill_Set__c where Id IN : skillSet];
        system.debug('skillName'+skillName);
        //Pushing skill name to skills object
        for(Integer i=0; i<skillName.size(); i++){
            skills[i].Name=(skillName[i].Name);
        }
        system.debug('skills>>'+skills);
        //Removing Duplicate id
        Set<Id> rolesSet = new Set<Id>();
        
        for(Integer i =0; i<rolesAndResp.size(); i++){
            system.debug(rolesAndResp[i].Rolls_and_Responsibilities_Master__c);
            rolesSet.add(rolesAndResp[i].Rolls_and_Responsibilities_Master__c);

        }
        system.debug('rolesSet>>'+rolesSet);
        //Querying Roles and Resp  name with filtered Master id
        List<Rolls_and_Responsibilities_Master__c> rolesAndRespName = [Select Name from Rolls_and_Responsibilities_Master__c where Id IN : rolesSet];
        system.debug('rolesAndRespName>>>'+rolesAndRespName);
        for(Integer i=0; i<rolesAndRespName.size(); i++){
            rolesAndResp[i].Name=(rolesAndRespName[i].Name);
        }
        system.debug('rolesAndResp>>'+rolesAndResp);

        for(Roll_and_Responsibilities__c rollsAndRespList : rolesAndResp){
            rollsAndRespList.Candidate_Profile__c = candFields.Id;
            system.debug('rollsAndRespList>>'+rollsAndRespList);
        }
        insert rolesAndResp;

       for(Skill_Set_Experience__c skillsList : skills){
            skillsList.Candidate_Profile__c = candFields.Id;
            
            system.debug('skillsList>>'+skillsList);
        }
        system.debug('skills>>'+skills);
        insert skills;
        return skills;
    }

    @AuraEnabled
    public static void newJobPosting(Job_Posting__c jobPostingfields, List<Skill_Set_Experience__c> skillsList, List<Job_Posting_Document__c> docMasterList){
        system.debug('jobPostingfields>>'+jobPostingfields);
        system.debug('skillsList>>>'+skillsList);
        system.debug('docMasterList>>>'+docMasterList);
        insert jobPostingfields;

        //INSERT SKILL LIST START
        if(skillsList.size() <> 0){
        Set<Id> skillSet = new Set<Id>();
        for(Integer i =0; i<skillsList.size(); i++){
            skillSet.add(skillsList[i].Skill_Set__c);
        }
        List<Skill_Set__c> skillName = [Select Name from Skill_Set__c where Id IN : skillSet];
        system.debug('skillName'+skillName);
        for(Integer i=0; i<skillName.size(); i++){
            skillsList[i].Name=(skillName[i].Name);
        }
        system.debug('skillsList>>'+skillsList);

        for(Skill_Set_Experience__c skills : skillsList){
                skills.Job_Posting__c = jobPostingfields.Id;
                system.debug('skills>>'+skills);
            }
        insert skillsList;
        }
        //INSERT SKILL LIST ENDS

        //INSERT DOCUMENT MASTER LIST START
        if(docMasterList.size() <> 0){
        Set<Id> docMasterSet = new Set<Id>();
        for(Integer i =0; i<docMasterList.size(); i++){
            docMasterSet.add(docMasterList[i].Document_Master__c);
            system.debug('docMasterSet>>'+docMasterSet);
        }
        List<Document_Master__c> docMasterNameId = [Select Id,Name from Document_Master__c where Id IN : docMasterSet];
        for(Integer i=0; i<docMasterNameId.size(); i++){
            docMasterList[i].Document_Master__c=(docMasterNameId[i].Id);
            docMasterList[i].Name=(docMasterNameId[i].Name);
            docMasterList[i].Job_Posting__c=jobPostingfields.Id;
            system.debug('docMasterList>>'+docMasterList);
        }

        system.debug('docMasterList>>'+docMasterList);
        insert docMasterList;
        }
        //INSERT DOCUMENT MASTER LIST ENDS

    }

    @AuraEnabled
    public static void updateJobPosting(Job_Posting__c jobPostingfields,List<Skill_Set_Experience__c> skillsList, List<Job_Posting_Document__c> docMasterList,String updateJobPosId){
        system.debug('jobPostingfields>>>'+jobPostingfields);
        system.debug('skillsList>>>'+skillsList);
        system.debug('docMasterList>>>'+docMasterList);
        system.debug('updateJobPosId>>>'+updateJobPosId);
        
        //UPDATE TEAM START
        if(jobPostingfields.Teams__c != null){
            Job_Posting__c updateValues = new Job_Posting__c(Id=updateJobPosId); 
            updateValues.Teams__c = jobPostingfields.Teams__c;
            update updateValues;
        }
        //UPDATE TEAM ENDS
        
        //INSERT SKILL LIST START
        Set<Id> newSkillSet = new Set<Id>();
        if(skillsList.size() <> 0){
            for(Integer i =0; i<skillsList.size(); i++){
                newSkillSet.add(skillsList[i].Skill_Set__c);
            }
        }
        List<Skill_Set_Experience__c> existingSkill = [SELECT Skill_Set__c FROM Skill_Set_Experience__c WHERE Job_Posting__c = :updateJobPosId];
        System.debug('Existing Skill' + existingSkill);
        List<Skill_Set_Experience__c> skilltoRemove = new list<Skill_Set_Experience__c>();
        set<Id> skillsToRemove = new set<Id>();
        
        for (Skill_Set_Experience__c skill : existingSkill) {
            if(newSkillSet.contains(skill.Skill_Set__c)){
                System.debug('Skill already Exist');
                newSkillSet.remove(skill.Skill_Set__c);
            }else{
                skilltoRemove.add(skill);
            }
        }
        delete skilltoRemove;
        // list<Skill_Set__c> skillList = [Select Name from Skill_Set__c where Id IN : newSkillSet];
        Map<Id,String> idSkillMAp = new Map<Id,String>();
        for (Skill_Set_Experience__c skill : skillsList) {
            idSkillMAp.put(skill.Skill_Set__c, skill.Name);
        }
        
        List<Skill_Set_Experience__c> skilltoAdd = new list<Skill_Set_Experience__c>();
        for (Id newskill : newSkillSet) {
            Skill_Set_Experience__c addSkill = new Skill_Set_Experience__c();
            addSkill.Skill_Set__c = newskill;
            addSkill.Job_Posting__c = updateJobPosId;
            addSkill.Name = idSkillMAp.get(newskill);
            skilltoAdd.add(addSkill);
        }
        insert skilltoAdd; 
       
        //INSERT SKILL LIST ENDS
      
        //INSERT DOCUMENT MASTER LIST START
        if(docMasterList.size() <> 0){
        Set<Id> docMasterSet = new Set<Id>();
        for(Integer i =0; i<docMasterList.size(); i++){
            docMasterSet.add(docMasterList[i].Document_Master__c);
            system.debug('docMasterSet>>'+docMasterSet);
        }
        List<Document_Master__c> docMasterNameId = [Select Id,Name from Document_Master__c where Id IN : docMasterSet];
        for(Integer i=0; i<docMasterNameId.size(); i++){
            docMasterList[i].Document_Master__c=(docMasterNameId[i].Id);
            docMasterList[i].Name=(docMasterNameId[i].Name);
            docMasterList[i].Job_Posting__c=updateJobPosId;
            system.debug('docMasterList 1097>>'+docMasterList);
        }

        system.debug('docMasterList>>'+docMasterList);
        insert docMasterList;
        }
        //INSERT DOCUMENT MASTER LIST ENDS
    }
    
    @AuraEnabled
    public static List<Skill_Set_Experience__c> getSkillName( List<Skill_Set_Experience__c> skillsList){
        
        system.debug('skillsList>>'+skillsList);
        
        
        Set<Id> skillSet = new Set<Id>();
        
        for(Integer i =0; i<skillsList.size(); i++){
            system.debug(skillsList[i].Skill_Set__c);
            skillSet.add(skillsList[i].Skill_Set__c);
            
        }
        system.debug('skillSet'+skillSet);
        List<Skill_Set__c> skillName = [Select Name from Skill_Set__c where Id IN : skillSet];
        system.debug('skillName>>>'+skillName);
        // for(Integer i=0; i<skillName.size(); i++){
        //     skillsList[i].Name=(skillName[i].Name);
        // }
        // system.debug('skillsList>>'+skillsList);
        for(Skill_Set_Experience__c skillsName : skillsList){
            for(Skill_Set__c skillsetName :skillName )
            if(skillsName.Skill_Set__c == skillsetName.Id){
                skillsName.Name = skillsetName.Name;
            }
            
        }
        system.debug('skillsList>>'+skillsList);
        return skillsList;
    }

    //Resume Upload

    @AuraEnabled
    public static string getAccessToken(){
        try {
            return GoogleDriveController.getAccessToken();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string gdriveDocUpload(String candidateName, String attachmentId,String uploadedDocId){
        try {
            System.debug(candidateName+'##'+attachmentId+'###'+uploadedDocId);
             
            String returnResponse = GoogleDriveController.gDriveResumeUpload(candidateName, attachmentId, uploadedDocId);
            return returnResponse;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
       @AuraEnabled
    public static string getPreviewLink(String resumeId){
        List<Resume__c> link =[SELECT PreviewLink__c FROM Resume__c WHERE Id=:resumeId LIMIT 1];
        return link[0].PreviewLink__c;
    }
    
     @AuraEnabled        
    public static List<String> getSkill(String skillExpId) {
       
        List<String> SkillExpList = new List<String>();
        List<Skill_Set_Experience__c> lstOfValues = [Select Id from Skill_Set_Experience__c where Candidate_Profile__c =: skillExpId];
        for(Skill_Set_Experience__c values : lstOfValues){
            SkillExpList.add(values.Id);
            //SkillExpList.add(values.Name);
            //SkillExpList.add(values.Ratings__c);
           // SkillExpList.add(values.Skill_Set__c);
           // SkillExpList.add(values.Skill_Experience_Level__c);
        }
        System.debug('SkillExpList>>>'+SkillExpList);
        return SkillExpList;
    }
    @AuraEnabled        
    public static List<String> getRoleAndResp(String RoleAndRespId) {
        System.debug('RoleAndRespId>>>'+RoleAndRespId);
        List<String> RoleAndResp = new List<String>();
        List<Roll_and_Responsibilities__c> lstOfValues = [Select Id from Roll_and_Responsibilities__c where Candidate_Profile__c =: RoleAndRespId];
        for(Roll_and_Responsibilities__c values : lstOfValues){
            RoleAndResp.add(values.Id);
           // RoleAndResp.add(values.Name);
           // RoleAndResp.add(values.Type__c);
           // RoleAndResp.add(values.Rolls_and_Responsibilities_Master__c);
        }
        System.debug('RoleAndResp>>>'+RoleAndResp);
        return RoleAndResp;
    }
    @AuraEnabled
    public static List<Skill_Set_Experience__c> updateCandidateProfile(Candidate_Profile__c candFields, List<Skill_Set_Experience__c> skills, List<Roll_and_Responsibilities__c> rolesAndResp ,String updateCandiDateId ){
        system.debug('candFields>>'+candFields);
        system.debug('skills>>'+skills);
        system.debug('rolesAndResp>>'+rolesAndResp);
        system.debug('updateCandiDateId>>'+updateCandiDateId);
        if(candFields.Resume__c != null){
            Candidate_Profile__c updateValues = new Candidate_Profile__c(Id=updateCandiDateId); 
            updateValues.Resume__c = candFields.Email__c;
            update updateValues;
        }
       
        String candId = candFields.Id;
        system.debug('candId>>'+candId);

        //If candidate Id is present then update the existing record else create new
        if(candId != null){
            update candFields; 
        }else{
            insert candFields;
        }
        //insert candFields;
        system.debug('candFields>>'+candFields);
        //Removing duplicate skill id
        Set<Id> skillSet = new Set<Id>();
        
        for(Integer i =0; i<skills.size(); i++){
            system.debug(skills[i].Skill_Set__c);
            skillSet.add(skills[i].Skill_Set__c);

        }
        system.debug('skillSet'+skillSet);

        //Getting Skill name with skill id
        List<Skill_Set__c> skillName = [Select Name from Skill_Set__c where Id IN : skillSet];
        system.debug('skillName'+skillName);
        //Pushing skill name to skills object
        for(Integer i=0; i<skillName.size(); i++){
            skills[i].Name=(skillName[i].Name);
        }
        system.debug('skills>>'+skills);
        //Removing Duplicate id
        Set<Id> rolesSet = new Set<Id>();
        
        for(Integer i =0; i<rolesAndResp.size(); i++){
            system.debug(rolesAndResp[i].Rolls_and_Responsibilities_Master__c);
            rolesSet.add(rolesAndResp[i].Rolls_and_Responsibilities_Master__c);

        }
        system.debug('rolesSet>>'+rolesSet);
        //Querying Roles and Resp  name with filtered Master id
        List<Rolls_and_Responsibilities_Master__c> rolesAndRespName = [Select Name from Rolls_and_Responsibilities_Master__c where Id IN : rolesSet];
        system.debug('rolesAndRespName>>>'+rolesAndRespName);
        for(Integer i=0; i<rolesAndRespName.size(); i++){
            rolesAndResp[i].Name=(rolesAndRespName[i].Name);
        }
        system.debug('rolesAndResp>>'+rolesAndResp);

        for(Roll_and_Responsibilities__c rollsAndRespList : rolesAndResp){
            rollsAndRespList.Candidate_Profile__c = updateCandiDateId;
            system.debug('rollsAndRespList>>'+rollsAndRespList);
        }
        insert rolesAndResp;

       for(Skill_Set_Experience__c skillsList : skills){
            skillsList.Candidate_Profile__c = updateCandiDateId;
            
            system.debug('skillsList>>'+skillsList);
        }
        system.debug('skills>>'+skills);
        insert skills;
        return skills;
    }

    @AuraEnabled        
    public static boolean deleteSkill(list<String> skillExpId) {
       System.debug(skillExpId);
       list<Skill_Set_Experience__c> values = new list<Skill_Set_Experience__c>();
       for (String var : skillExpId) {
            System.debug('row added');
            Skill_Set_Experience__c skill = new Skill_Set_Experience__c(Id=var);
            values.add(skill);
        }
        system.debug(values);
        delete values;
        System.debug('SkillExpList>>>'+values);
        return true;
    }
    @AuraEnabled        
    public static List<String> deleteRoleAndResp(String RoleAndRespId) {
        List<String> RoleAndResp = new List<String>();
        List<Roll_and_Responsibilities__c> lstOfValues = [Select Id from Roll_and_Responsibilities__c where Candidate_Profile__c =: RoleAndRespId LIMIT 1];
        for(Roll_and_Responsibilities__c values : lstOfValues){
            delete values;
          
        }
        System.debug('RoleAndResp>>>'+lstOfValues);
        return RoleAndResp;
    }

}