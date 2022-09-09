@isTest
public with sharing class HomePageControllerTest {
    @isTest(seeAllData=false)
    public static void HomePageControllerTest1()
    {
        Account account = new Account();
        account.Name = 'Burlingt sew';
        insert account;
        
        Contact con = new Contact();
        con.AccountId = account.Id;
        con.LastName = 'B K';
        con.Email='test@test.com';
        insert con;
        
        CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        team.Name = 'Team Delloite';
        insert team;
        
        
        Candidate_Profile__c lstcand=new Candidate_Profile__c();
        lstcand.Name='Akhilesh';
        lstcand.Email__c='akhilesh.h.n@gmail.com';
        lstcand.Designation__c='Java Developer';
        lstcand.Experience__c=2;
        lstcand.Skills__c='javascript';
        lstcand.Current_Location__c='Bangalore';
        lstcand.Notice_Period__c='2';
        insert lstcand;
        
        
        
        
        
        Job_Posting__c jobPost = new Job_Posting__c();
        jobPost.Name = 'Job Sony';
        jobPost.Designation__c='Salesforce Developer123';
        jobPost.No_Of_Positions__c=2;
        jobPost.Location__c='Bengaluru';
        jobPost.Job_Requirement_Type__c='Permanent';
        jobPost.Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
        jobPost.Job_OC_Status__c = 'Open';
        jobPost.No_Of_Candidate_Selected__c = 10;
        //jobPost.Contact__c= con.Id;
        jobPost.Teams__c = team.Id;
        jobPost.Account__c = account.Id;
        
        insert jobPost;
        
        Job_Posting__c jobPost1 = new Job_Posting__c();
        
        
        
        
        Job_Application__c lst=new Job_Application__c();
        lst.Name='Akhilesh';
        lst.Job_Posting__c =jobPost.Id;
        lst.Client_Approval_Process__c = 'Sony';
        lst.Profile_Status__c='Offer Letter'; 
        //lst.Status__c='Open';
        lst.Candidate_Profile__c = lstcand.Id; 
        insert lst;
        
        /*   Job_Application__c lst1=new Job_Application__c();
lst.Name='Barney';
lst.Job_Posting__c =jobPost.Id;
lst.Client_Approval_Process__c = 'Sony';
lst.Profile_Status__c='Document Verified'; 
//lst.Status__c='Open';
lst.Candidate_Profile__c = lstcand.Id; 
insert lst1;
*/
        
        
        List<Comment__c> comment=new List<Comment__c>();
        Comment__c com=new Comment__c();
        com.Job_Application__c=lst.id;
        com.Remarks__c='Medium in Apex Callouts';
        com.User__c='development Team';
        comment.add(com);
        insert com;
        
        
        
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'FirstName',
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',     
            ContactId = con.id
        );
        
        CustomTeams__Team_Members__c teamMembers = new CustomTeams__Team_Members__c();
        teamMembers.CustomTeams__User__c = u.Id;
        teamMembers.CustomTeams__Team__c = team.Id;
        teamMembers.CustomTeams__Access_Level__c = 	'Read';
        insert teamMembers;
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id);
        
        
        
        
        
        
        
        //HomePageController homePageContrl = new HomePageController();
        
        
        Job_Posting__c jobPost2 = new Job_Posting__c();
        jobPost2.Name = 'Job Sony';
        jobPost2.Posting_Due_Date__c =  Date.newInstance(2022, 06, 07);
        jobPost2.Job_OC_Status__c = 'Open';
        jobPost2.No_Of_Candidate_Selected__c = 10;
        //jobPost2.Contact__c= con.Id;
        jobPost2.Teams__c = team.Id;
        
        insert jobPost2;
        
        
        
        //String companyFilter = 'Sony India';
        //String postStatus = 'Open';
        HomePageController.getJobPosting(account.Name,jobPost.Job_OC_Status__c);
        
        HomePageController.getClientList();
        
        HomePageController.getStatusList();
        
        HomePageController.togetJobPostings('Sony India','Open','Onboard',lst.id);
        
        
        HomePageController.getContact(jobPost.id);
        
        HomePageController.getCandEmail(lstcand.id);
        
        HomePageController.getHostEmail(con.id);
        
        HomePageController.getComments(lst.Id);
        
        HomePageController.saveComment(lst.Id,'so nice');
        
        HomePageController.hideProfileStatus();
 
        //HomePageController homePageContrl = new HomePageController();
        Schema.DescribeFieldResult statusfield = Job_Posting__c.Job_OC_Status__c.getDescribe();
        Map<String,String> statusList = HomePageController.getPickListValuesIntoMap(statusfield);
        
    }
    @isTest(seeAllData=false)
    public static void HomePageControllerTest2()
    {
        Account account1 = new Account();
        account1.Name = 'Sony India';
        insert account1;
        
        CustomTeams__Teams__c team1 = new CustomTeams__Teams__c();
        team1.Name = 'Team Anil';
        insert team1;
        
        CustomTeams__Teams__c team2 = new CustomTeams__Teams__c();
        team1.Name = 'Team Anil';
        insert team2;
        
        Candidate_Profile__c lstcand1=new Candidate_Profile__c();
        lstcand1.Name='Akhilesh';
        lstcand1.Email__c='akhilesh.h.n@gmail.com';
        lstcand1.Designation__c='Java Developer';
        lstcand1.Experience__c=2;
        lstcand1.Skills__c='javascript';
        lstcand1.Current_Location__c='Bangalore';
        lstcand1.Notice_Period__c='2';
        insert lstcand1;
        
        Job_Posting__c jobPost1 = new Job_Posting__c();
        jobPost1.Id=jobPost1.id;
        jobPost1.Name = 'Job Sony';
        jobPost1.Designation__c='Salesforce Developer123';
        jobPost1.No_Of_Positions__c=2;
        // jobPost.role__c='lead';
        jobPost1.Location__c='Bengaluru';
        jobPost1.Job_Requirement_Type__c='Permanent';
        jobPost1.Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
        jobPost1.Job_OC_Status__c = 'Open';
        jobPost1.No_Of_Candidate_Selected__c = 10;
        //jobPost.Contact__c= con.Id;
        jobPost1.Teams__c = team1.Id;
        jobPost1.Account__c = account1.id;
         
        
        insert jobPost1;
        
        Job_Application__c lst1=new Job_Application__c();
        lst1.Name='Akhilesh';
        lst1.Job_Posting__c =jobPost1.Id;
        lst1.Client_Approval_Process__c = 'Sony';
        lst1.Profile_Status__c='Offer Letter'; 
        //lst.Status__c='Open';
        lst1.Candidate_Profile__c = lstcand1.Id; 
        insert lst1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user = new User(Alias = 'newUser', Email='raghu.kr@techkasetti.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = p.Id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='1234vinod@techkasetti.com');
        system.debug('user>>'+user);
        insert user;
        
        //List<CustomTeams__Team_Members__c> teamMembersList = new List<CustomTeams__Team_Members__c>();
        
        
        
        CustomTeams__Team_Members__c teamMembers = new CustomTeams__Team_Members__c();
        teamMembers.CustomTeams__User__c = user.Id;
        teamMembers.CustomTeams__Team__c = team1.Id;
        teamMembers.CustomTeams__Access_Level__c = 	'Read';
        teamMembers.Testing__c = 'Hello';
        insert teamMembers;
        //teamMembersList.add(teamMembers);
        
        /*Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user2 = new User(Alias = 'VKuma',LastName='Kumar',UserName='kasettidevorg@techkasetti.com');*/
        
        /*CustomTeams__Team_Members__c teamMembers2 = new CustomTeams__Team_Members__c();
teamMembers2.CustomTeams__User__c = user.Id;
teamMembers2.CustomTeams__Team__c = team2.Id;
teamMembers2.CustomTeams__Access_Level__c = 	'Read';
teamMembersList.add(teamMembers2);*/
        
        //insert teamMembersList;
        
        System.runAs(user) {
            Test.startTest();
           
            HomePageController.togetJobPostings('Sony India','Open','Onboard','');
            Test.stopTest();
        }
        
        
        
        
    }
}