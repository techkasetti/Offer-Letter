@IsTest
public with sharing class smartSearchControllerTest {
    @IsTest(seeAllData=false)
    public static void smartSearchControllerTest1()
    { 
        List<Skill_Set__c> skillSetList = new List<Skill_Set__c>();
        Skill_Set__c skillSet1 = new Skill_Set__c();
        skillSet1.Name = 'Java';
        skillSet1.Department__c = 'IT';
        skillSetList.add(skillSet1);

        Skill_Set__c skillSet2 = new Skill_Set__c();
        skillSet2.Name = 'Html';
        skillSet1.Department__c = 'Accounts';
        skillSetList.add(skillSet2);

        insert skillSetList;

        Skill_Set__c skillSet3 = new Skill_Set__c();
        skillSet3.Name = 'Java';
        skillSet3.Department__c = 'IT';
        //skillSet3.SkillSet_Experience__c = '1 Yrs';
        insert skillSet3;

        // List<Location_Set__c> locationSetList = new List<Location_Set__c>();
        // Location_Set__c locationSet1 = new Location_Set__c();
        // locationSet1.Name = 'Java';
        // locationSetList.add(locationSet1);

        // Location_Set__c locationSet2 = new Location_Set__c();
        // locationSet2.Name = 'Html';
        // locationSetList.add(locationSet2);

        // insert locationSetList;

        List<Candidate_Profile__c> candidateList = new List<Candidate_Profile__c>();
        Candidate_Profile__c candidate1 = new Candidate_Profile__c();
        candidate1.Name = 'Ram';
        candidate1.Current_Location__c = 'Pune';
        candidate1.Expected_CTC__c = 89;
        candidate1.Experience__c = 1;
        candidate1.Notice_Period__c = '0-15';
        candidate1.Skills__c = 'Java';
        candidate1.Designation__c = 'Salesforce Developer';
        candidate1.Annual_CTC__c = 47;
        //candidate1.Preferred_Location__c = 'Bangalore';
        candidate1.Email__c = 'ram123@gmail.com';
        candidate1.Phone__c = '1234567891';
        candidateList.add(candidate1);
		
		Candidate_Profile__c candidate2 = new Candidate_Profile__c();
        candidate2.Name = 'Raj';
        candidate2.Current_Location__c = 'Hyderbad';
        candidate2.Expected_CTC__c = 45;
        candidate2.Experience__c = 3;
        candidate2.Notice_Period__c = '0-15';
        candidate2.Skills__c = 'Java';
        candidate2.Designation__c = 'Tester';
        candidate2.Annual_CTC__c = 67;
       // candidate2.Preferred_Location__c = 'Bangalore';
        candidate2.Email__c = 'raj123@gmail.com';
        candidate2.Phone__c = '1234567891';
        candidateList.add(candidate2);

        insert candidateList;

        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'Burlingt sew';
        accList.add(acc1);

        Account acc2 = new Account();
        acc2.Name = 'Dickenson plc';
        accList.add(acc2);

        insert accList;

        List<Document_Master__c> docMasterist = new List<Document_Master__c>();
        Document_Master__c docMaster1 = new Document_Master__c();
        docMaster1.Name = 'PUC';
        docMasterist.add(docMaster1);

        Document_Master__c docMaster2 = new Document_Master__c();
        docMaster2.Name = 'SSLC';
        docMasterist.add(docMaster2);

        insert docMasterist;

        Document_Master__c docMaster = new Document_Master__c();
        docMaster.Name = 'SSLC';
        insert docMaster;

        Account account = new Account();
        account.Name = 'Burlingt sew';
        insert account;

        Contact con = new Contact();
        con.AccountId = account.Id;
        con.LastName = 'B K';
        insert con;

        CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        team.Name = 'Team Delloite';
        team.Account__c = account.Id;
        insert team;

        Job_Posting__c jobPost = new Job_Posting__c();
        jobPost.Notice_Period__c = 'Immediate';
        jobPost.Job_Requirement_Type__c = 'Contract';
        //jobPost.Contact__c = con.Id;
        jobPost.Teams__c = team.Id;
        jobPost.Account__c = account.Id;
        insert jobPost;

        Candidate_Profile__c candidate = new Candidate_Profile__c();
        candidate.Functional_Area__c = 'Developer';
        candidate.Designation__c = 'Salesforce Developer';
        candidate.UG_Stream__c = 'BE/B.Tech';
        candidate.PG_Stream__c = 'M.Tech';
        candidate.Email__c = 'abc123@gmail.com';
        candidate.UG_Education_Type__c = 'Full Time';
        candidate.PG_Education_Type__c = 'Part Time';
        insert candidate;

        Rolls_and_Responsibilities_Master__c rolesRespMaster = new Rolls_and_Responsibilities_Master__c();
        rolesRespMaster.Name = 'Immediate';
        rolesRespMaster.Type__c = 'Rolls';
        insert rolesRespMaster;

        Skill_Set_Experience__c skillSetExp = new Skill_Set_Experience__c();
        skillSetExp.Name = 'Java';
        skillSetExp.SkillSet_Experience__c = '3';
        skillSetExp.Job_Posting__c = jobPost.Id;
        skillSetExp.Ratings__c = '5';
        skillSetExp.Skill_Set__c = skillSet3.Id;
        insert skillSetExp;

        Skill_Set__c skillSet4 = new Skill_Set__c();
        skillSet4.Name = 'Html';
        skillSet4.Department__c = 'IT';
        insert skillSet4;

        Skill_Set__c skillSet5 = new Skill_Set__c();
        skillSet5.Name = 'C Language';
        skillSet5.Department__c = 'IT';
        insert skillSet5;

        List<Skill_Set_Experience__c> skillSetExpList = new List<Skill_Set_Experience__c>();
        Skill_Set_Experience__c skillSetExp1 = new Skill_Set_Experience__c();
        skillSetExp1.Name = 'Html';
        skillSetExp1.SkillSet_Experience__c = '3';
        skillSetExp1.Job_Posting__c = jobPost.Id;
        skillSetExp1.Ratings__c = '5';
        skillSetExp1.Skill_Set__c = skillSet4.Id;
        skillSetExpList.add(skillSetExp1);

        Skill_Set_Experience__c skillSetExp2 = new Skill_Set_Experience__c();
        skillSetExp2.Name = 'C Language';
        skillSetExp2.SkillSet_Experience__c = '3';
        skillSetExp2.Job_Posting__c = jobPost.Id;
        skillSetExp2.Ratings__c = '9';
        skillSetExp2.Skill_Set__c = skillSet5.Id;
        skillSetExpList.add(skillSetExp2);

        insert skillSetExpList;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user = new User(Alias = 'VKuma',LastName='Kumar',UserName='kasettidevorg@techkasetti.com');

        CustomTeams__Team_Members__c teamMem = new CustomTeams__Team_Members__c();
        teamMem.CustomTeams__User__c = user.Name;
        teamMem.CustomTeams__Team__c = team.Id;
        teamMem.CustomTeams__Access_Level__c = 'Read';
        insert teamMem;

        Job_Application__c jobApplication = new Job_Application__c();
        jobApplication.Name = 'Akhilesh';
        jobApplication.Candidate_Profile__c = candidate.Id;
        jobApplication.Job_Posting__c = jobPost.Id;
        insert jobApplication;

        Job_Posting_Document__c jobPostingDoc = new Job_Posting_Document__c();
        jobPostingDoc.Name = 'PUC';
        jobPostingDoc.Document_Master__c = docMaster.Id;
        jobPostingDoc.Job_Posting__c = jobPost.Id;
        jobPostingDoc.Job_Application__c = jobApplication.Id;
        insert jobPostingDoc;

        List<Roll_and_Responsibilities__c> rollsResList = new List<Roll_and_Responsibilities__c>();
        Roll_and_Responsibilities__c rollsRes1 = new Roll_and_Responsibilities__c();
        rollsRes1.Type__c = 'Role';
        rollsRes1.Rolls_and_Responsibilities_Master__c = rolesRespMaster.Id;
        rollsRes1.Candidate_Profile__c = candidate.Id;
        rollsResList.add(rollsRes1);

        Roll_and_Responsibilities__c rollsRes2 = new Roll_and_Responsibilities__c();
        rollsRes2.Type__c = 'Responsibility';
        rollsRes2.Rolls_and_Responsibilities_Master__c = rolesRespMaster.Id;
        rollsRes2.Candidate_Profile__c = candidate.Id;
        rollsResList.add(rollsRes2);

        insert rollsResList;


        List<Job_Posting_Document__c> jobPostingList = new List<Job_Posting_Document__c>();
        Job_Posting_Document__c jobPostingDoc1 = new Job_Posting_Document__c();
        jobPostingDoc1.Name = 'PUC';
        jobPostingDoc1.Document_Master__c = docMaster.Id;
        jobPostingDoc1.Job_Posting__c = jobPost.Id;
        jobPostingDoc1.Job_Application__c = jobApplication.Id;
        jobPostingList.add(jobPostingDoc1);

        Job_Posting_Document__c jobPostingDoc2 = new Job_Posting_Document__c();
        jobPostingDoc2.Name = 'PUC';
        jobPostingDoc2.Document_Master__c = docMaster.Id;
        jobPostingDoc2.Job_Posting__c = jobPost.Id;
        jobPostingDoc2.Job_Application__c = jobApplication.Id;
        jobPostingList.add(jobPostingDoc2);

        insert jobPostingList;

        Candidate_Profile__c candidate3 = new Candidate_Profile__c();
        candidate3.Functional_Area__c = 'Developer';
        candidate3.Designation__c = 'SQL Developer';
        candidate3.UG_Stream__c = 'BE/B.Tech';
        candidate3.PG_Stream__c = 'M.Tech';
        candidate3.Email__c = 'abc123675267@gmail.com';
        candidate3.UG_Education_Type__c = 'Part Time';
        candidate3.PG_Education_Type__c = 'Full Time';
        insert candidate3;

        Job_Posting__c jobPost1 = new Job_Posting__c();
        jobPost1.Name = 'Sony';
        jobPost1.Notice_Period__c = 'Immediate';
        jobPost1.Job_Requirement_Type__c = 'Contract';
        //jobPost1.Contact__c = con.Id;
        jobPost1.Teams__c = team.Id;
        jobPost1.Account__c = account.Id;


        String curLocation = 'Bangalore';
        String expCTC = '5,7';
        String minExperience = '1';
        String maxExperience = '2';
        String noticePer = '0-15';

        List<String> userIds = new List<String>();
        userIds.add('dha');
        userIds.add('bangalore');

        List<String> listString = new List<String>();
        listString.add('Ram');
        listString.add(candidate.Id);
        listString.add(jobPost.Id);

        List<String> listSkillExp = new List<String>();
        listSkillExp.add('JavaScript, 1 Yrs');
        listSkillExp.add('JavaScript, 6 Yrs');
        


             //Test.StartTest();
             smartSearchController.getDepartmentPickListValues1(skillSetList);
             smartSearchController.getDepartmentPickListValues();
            // smartSearchController.getSkillSetPickListValues();
            //smartSearchController.getCustomerProfile(curLocation,expCTC,minExperience,maxExperience,noticePer,skillSetList,locationSetList);
             smartSearchController.getNoticePerPickListValues();
             smartSearchController.fetchSkillsDataList('ja','IT');
             smartSearchController.fetchPreLocationDataList('ja');
             smartSearchController.fetchDocumentList('ja');
             smartSearchController.getJoiningInPickListValues();
             smartSearchController.getJobReqTypePicklist();
             //smartSearchController.appendToFile('ja','IT','Java');
             //smartSearchController.fetchDocument('ja','IT','Java');
             smartSearchController.fetchCandidateDataList('ja');
             smartSearchController.getIndustryPicklistValues();
             smartSearchController.getFunctionalAreaPicklistValues();
             smartSearchController.getDesignationPicklistValues();
             smartSearchController.getStreamPicklistValues();
             smartSearchController.getPGStreamPicklistValues();
             smartSearchController.getCandidateProfile(listSkillExp,true);
             //smartSearchController.getJSONFieldSet();
             smartSearchController.getsObjects();
             //smartSearchController.getFieldSet();
             //smartSearchController.getFieldSetMember();
             smartSearchController.getJobPostingPickListValues(account.Id);
             smartSearchController.saveJobApplication(listString);
             smartSearchController.getTeams(); 
             smartSearchController.getTeamMembers('Team Delloite');
             smartSearchController.getSkillSetRatingPickList();
             smartSearchController.getJobPostingValues(jobPost.Id,'[{"KTDO1__Ratings__c":"3","KTDO1__Skill_Experience_Level__c":"4","KTDO1__Skill_Set__c":"a2Q4x000000yFq4EAE","Name":"JavaScript"}]');
             smartSearchController.getClientPicklistValues();
             //smartSearchController.getTypePicklistValues();
             //smartSearchController.fetchRollsResponsibilitiesList('sal','Rolls');
             smartSearchController.getJobTypePickListValues();
             smartSearchController.getEdTypePicklistValues();
             smartSearchController.getPGEdTypePicklistValues();
             smartSearchController.getTeamBasedOnAcc(account.Id);

             //Test.stopTest();

    }

    @IsTest(seeAllData=false)
    public static void TestSaveCandidateProfile()
    {

        Account account = new Account();
        account.Name = 'Burlingt sew';
        insert account;

        CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        team.Name = 'Team Delloite';
        team.Account__c = account.Id;
        insert team;

        Document_Master__c docMaster = new Document_Master__c();
        docMaster.Name = 'SSLC';
        insert docMaster;

        Job_Posting__c jobPost = new Job_Posting__c();
        jobPost.Notice_Period__c = 'Immediate';
        jobPost.Job_Requirement_Type__c = 'Contract';
        //jobPost.Contact__c = con.Id;
        jobPost.Teams__c = team.Id;
        jobPost.Account__c = account.Id;
        insert jobPost;

        Candidate_Profile__c candidate = new Candidate_Profile__c();
        candidate.Functional_Area__c = 'Developer';
        candidate.Designation__c = 'Salesforce Developer';
        candidate.UG_Stream__c = 'BE/B.Tech';
        candidate.PG_Stream__c = 'M.Tech';
        candidate.Email__c = 'abc123@gmail.com';
        candidate.UG_Education_Type__c = 'Full Time';
        candidate.PG_Education_Type__c = 'Part Time';
        insert candidate;
		
		Job_Application__c jobApplication = new Job_Application__c();
        jobApplication.Name = '/Akhilesh';
        jobApplication.Candidate_Profile__c = candidate.Id;
        jobApplication.Job_Posting__c = jobPost.Id;
        insert jobApplication;


		List<Job_Posting_Document__c> jobPostingList = new List<Job_Posting_Document__c>();
        Job_Posting_Document__c jobPostingDoc1 = new Job_Posting_Document__c();
        jobPostingDoc1.Name = 'PUC';
        jobPostingDoc1.Document_Master__c = docMaster.Id;
        jobPostingDoc1.Job_Posting__c = jobPost.Id;
        jobPostingDoc1.Job_Application__c = jobApplication.Id;
        jobPostingList.add(jobPostingDoc1);

        Job_Posting_Document__c jobPostingDoc2 = new Job_Posting_Document__c();
        jobPostingDoc2.Name = 'PUC';
        jobPostingDoc2.Document_Master__c = docMaster.Id;
        jobPostingDoc2.Job_Posting__c = jobPost.Id;
        jobPostingDoc2.Job_Application__c = jobApplication.Id;
        jobPostingList.add(jobPostingDoc2);



        Job_Posting__c jobPost1 = new Job_Posting__c();
        jobPost1.Name = 'Sony';
        jobPost1.Notice_Period__c = 'Immediate';
        jobPost1.Job_Requirement_Type__c = 'Contract';
        //jobPost1.Contact__c = con.Id;
        jobPost1.Teams__c = team.Id;
        jobPost1.Account__c = account.Id;

        Skill_Set__c skillSet4 = new Skill_Set__c();
        skillSet4.Name = 'Html';
        skillSet4.Department__c = 'IT';
        insert skillSet4;

        Skill_Set__c skillSet5 = new Skill_Set__c();
        skillSet5.Name = 'C Language';
        skillSet5.Department__c = 'IT';
        insert skillSet5;

         List<Skill_Set_Experience__c> skillSetExpList = new List<Skill_Set_Experience__c>();
        Skill_Set_Experience__c skillSetExp1 = new Skill_Set_Experience__c();
        skillSetExp1.Name = 'Html';
        skillSetExp1.SkillSet_Experience__c = '3';
        skillSetExp1.Job_Posting__c = jobPost.Id;
        skillSetExp1.Ratings__c = '5';
        skillSetExp1.Skill_Set__c = skillSet4.Id;
        skillSetExpList.add(skillSetExp1);

        Skill_Set_Experience__c skillSetExp2 = new Skill_Set_Experience__c();
        skillSetExp2.Name = 'CLanguage';
        skillSetExp2.SkillSet_Experience__c = '3';
        skillSetExp2.Job_Posting__c = jobPost.Id;
        skillSetExp2.Ratings__c = '9';
        skillSetExp2.Skill_Set__c = skillSet5.Id;
        skillSetExpList.add(skillSetExp2);

        Rolls_and_Responsibilities_Master__c rolesRespMaster = new Rolls_and_Responsibilities_Master__c();
        rolesRespMaster.Name = 'Immediate';
        rolesRespMaster.Type__c = 'Rolls';
        insert rolesRespMaster;

        List<Roll_and_Responsibilities__c> rollsResList = new List<Roll_and_Responsibilities__c>();
        Roll_and_Responsibilities__c rollsRes1 = new Roll_and_Responsibilities__c();
        rollsRes1.Type__c = 'Role';
        rollsRes1.Rolls_and_Responsibilities_Master__c = rolesRespMaster.Id;
        rollsRes1.Candidate_Profile__c = candidate.Id;
        rollsResList.add(rollsRes1);

        Roll_and_Responsibilities__c rollsRes2 = new Roll_and_Responsibilities__c();
        rollsRes2.Type__c = 'Responsibility';
        rollsRes2.Rolls_and_Responsibilities_Master__c = rolesRespMaster.Id;
        rollsRes2.Candidate_Profile__c = candidate.Id;
        rollsResList.add(rollsRes2);

        candidate_Profile__c candidate3 = new candidate_Profile__c();
        candidate3.Functional_Area__c = 'Tester';
        candidate3.Designation__c = 'Salesforce Tester';
        candidate3.UG_Stream__c = 'BE/B.Tech';
        candidate3.PG_Stream__c = 'M.Tech';
        candidate3.Email__c = 'abcdds122533@gmail.com';
        candidate3.UG_Education_Type__c = 'Full Time';
        candidate3.PG_Education_Type__c = 'Part Time';

        smartSearchController.saveCandidateProfile(candidate3,skillSetExpList,rollsResList);
    }

    @IsTest(seeAllData=false)
    public static void testNewJobPosting()
    {

        Account account = new Account();
        account.Name = 'Burlingt sew';
        insert account;

        CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        team.Name = 'Team Delloite';
        team.Account__c = account.Id;
        insert team;

        Document_Master__c docMaster = new Document_Master__c();
        docMaster.Name = 'SSLC';
        insert docMaster;

        Job_Posting__c jobPost = new Job_Posting__c();
        jobPost.Notice_Period__c = 'Immediate';
        jobPost.Job_Requirement_Type__c = 'Contract';
        //jobPost.Contact__c = con.Id;
        jobPost.Teams__c = team.Id;
        jobPost.Account__c = account.Id;
        insert jobPost;

        Candidate_Profile__c candidate = new Candidate_Profile__c();
        candidate.Functional_Area__c = 'Developer';
        candidate.Designation__c = 'Salesforce Developer';
        candidate.UG_Stream__c = 'BE/B.Tech';
        candidate.PG_Stream__c = 'M.Tech';
        candidate.Email__c = 'abc123@gmail.com';
        candidate.UG_Education_Type__c = 'Full Time';
        candidate.PG_Education_Type__c = 'Part Time';
        insert candidate;
		
		Job_Application__c jobApplication = new Job_Application__c();
        jobApplication.Name = '/Akhilesh';
        jobApplication.Candidate_Profile__c = candidate.Id;
        jobApplication.Job_Posting__c = jobPost.Id;
        insert jobApplication;


		List<Job_Posting_Document__c> jobPostingList = new List<Job_Posting_Document__c>();
        Job_Posting_Document__c jobPostingDoc1 = new Job_Posting_Document__c();
        jobPostingDoc1.Name = 'PUC';
        jobPostingDoc1.Document_Master__c = docMaster.Id;
        jobPostingDoc1.Job_Posting__c = jobPost.Id;
        jobPostingDoc1.Job_Application__c = jobApplication.Id;
        jobPostingList.add(jobPostingDoc1);

        Job_Posting_Document__c jobPostingDoc2 = new Job_Posting_Document__c();
        jobPostingDoc2.Name = 'PUC';
        jobPostingDoc2.Document_Master__c = docMaster.Id;
        jobPostingDoc2.Job_Posting__c = jobPost.Id;
        jobPostingDoc2.Job_Application__c = jobApplication.Id;
        jobPostingList.add(jobPostingDoc2);


        Skill_Set__c skillSet4 = new Skill_Set__c();
        skillSet4.Name = 'Html';
        skillSet4.Department__c = 'IT';
        insert skillSet4;

        Skill_Set__c skillSet5 = new Skill_Set__c();
        skillSet5.Name = 'C Language';
        skillSet5.Department__c = 'IT';
        insert skillSet5;

       List<Skill_Set_Experience__c> skillSetExpList = new List<Skill_Set_Experience__c>();
        Skill_Set_Experience__c skillSetExp1 = new Skill_Set_Experience__c();
        skillSetExp1.Name = 'Html';
        skillSetExp1.SkillSet_Experience__c = '3';
        skillSetExp1.Job_Posting__c = jobPost.Id;
        skillSetExp1.Ratings__c = '5';
        skillSetExp1.Skill_Set__c = skillSet4.Id;
        skillSetExpList.add(skillSetExp1);

        Skill_Set_Experience__c skillSetExp2 = new Skill_Set_Experience__c();
        skillSetExp2.Name = 'C Language';
        skillSetExp2.SkillSet_Experience__c = '3';
        skillSetExp2.Job_Posting__c = jobPost.Id;
        skillSetExp2.Ratings__c = '9';
        skillSetExp2.Skill_Set__c = skillSet5.Id;
        skillSetExpList.add(skillSetExp2);

        Rolls_and_Responsibilities_Master__c rolesRespMaster = new Rolls_and_Responsibilities_Master__c();
        rolesRespMaster.Name = 'Immediate';
        rolesRespMaster.Type__c = 'Rolls';
        insert rolesRespMaster;

        List<Roll_and_Responsibilities__c> rollsResList = new List<Roll_and_Responsibilities__c>();
        Roll_and_Responsibilities__c rollsRes1 = new Roll_and_Responsibilities__c();
        rollsRes1.Type__c = 'Role';
        rollsRes1.Rolls_and_Responsibilities_Master__c = rolesRespMaster.Id;
        rollsRes1.Candidate_Profile__c = candidate.Id;
        rollsResList.add(rollsRes1);

        Roll_and_Responsibilities__c rollsRes2 = new Roll_and_Responsibilities__c();
        rollsRes2.Type__c = 'Responsibility';
        rollsRes2.Rolls_and_Responsibilities_Master__c = rolesRespMaster.Id;
        rollsRes2.Candidate_Profile__c = candidate.Id;
        rollsResList.add(rollsRes2);

        Job_Posting__c jobPost1 = new Job_Posting__c();
        jobPost1.Name = 'Sony';
        jobPost1.Notice_Period__c = 'Immediate';
        jobPost1.Job_Requirement_Type__c = 'Contract';
        //jobPost1.Contact__c = con.Id;
        jobPost1.Teams__c = team.Id;
        jobPost1.Account__c = account.Id;

        smartSearchController.newJobPosting(jobPost1,skillSetExpList,jobPostingList);
    }

}