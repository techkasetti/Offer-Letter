@isTest
public with sharing class HomePageControllerTest {
    @isTest(seeAllData=false)
    public static void HomePageControllerTest1()
    {
        Account account = new Account();
        account.Name = 'Burlingt sew';
        account.KTDO1__Billing_City__c = 'pune';
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
        KTDO1__Job_Posting__c jobPost = new KTDO1__Job_Posting__c();
        jobPost.Name = 'Job Sony';
        jobPost.KTDO1__Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
        jobPost.KTDO1__Job_OC_Status__c = 'Open';
        jobPost.KTDO1__No_Of_Candidate_Selected__c = 10;
        //jobPost.KTDO1__Contact__c= con.Id;
        jobPost.KTDO1__Teams__c = team.Id;
        jobPost.KTDO1__Account__c = account.Id;
        insert jobPost;
        
        KTDO1__Job_Posting__c jobPost2 = new KTDO1__Job_Posting__c();
        jobPost2.Name = 'Job Sony';
        jobPost2.KTDO1__Posting_Due_Date__c =  Date.newInstance(2022, 06, 07);
        jobPost2.KTDO1__Job_OC_Status__c = 'Open';
        jobPost2.KTDO1__No_Of_Candidate_Selected__c = 10;
        //jobPost2.KTDO1__Contact__c= con.Id;
        jobPost2.KTDO1__Teams__c = team.Id;
        
        insert jobPost2;
       
        //String companyFilter = 'Sony India';
        //String postStatus = 'Open';
        HomePageController.getJobPosting(account.Name,jobPost.KTDO1__Job_OC_Status__c);
        HomePageController.getClientList();
        HomePageController.getStatusList();
        
       //HomePageController homePageContrl = new HomePageController();
        Schema.DescribeFieldResult statusfield = KTDO1__Job_Posting__c.KTDO1__Job_OC_Status__c.getDescribe();
        Map<String,String> statusList = HomePageController.getPickListValuesIntoMap(statusfield);
        
    }
    
    
    
}