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
        insert con;
        
        CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        team.Name = 'Team Delloite';
        insert team;
        
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
        
              
        //HomePageController homePageContrl = new HomePageController();
        Job_Posting__c jobPost = new Job_Posting__c();
        jobPost.Name = 'Job Sony';
        jobPost.Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
        jobPost.Job_OC_Status__c = 'Open';
        jobPost.No_Of_Candidate_Selected__c = 10;
        //jobPost.Contact__c= con.Id;
        jobPost.Teams__c = team.Id;
        jobPost.Account__c = account.Id;
        insert jobPost;
        
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
        
       //HomePageController homePageContrl = new HomePageController();
        Schema.DescribeFieldResult statusfield = Job_Posting__c.Job_OC_Status__c.getDescribe();
        Map<String,String> statusList = HomePageController.getPickListValuesIntoMap(statusfield);
        
    }
    
    
    
}