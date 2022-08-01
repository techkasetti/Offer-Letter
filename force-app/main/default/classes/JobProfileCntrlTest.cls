@isTest
public with sharing class JobProfileCntrlTest {
    @isTest(seeAllData=false)
    public static void toGetJobApplicantsTest() {

        Account account = new Account();
        account.Name = 'Burlingt sew';
        insert account;
        
        Contact con = new Contact();
        con.AccountId = account.Id;
        con.LastName = 'B K';
        insert con;

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'FirstName',
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',     
            ContactId = con.id
            );

            CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        team.Name = 'Team Delloite';
        insert team;

            Job_Posting__c jobPost = new Job_Posting__c();
            jobPost.Name = 'Job Sony';
            jobPost.Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
            jobPost.Job_OC_Status__c = 'Open';
            jobPost.No_Of_Candidate_Selected__c = 10;
            //jobPost.Contact__c= con.Id;
            jobPost.Teams__c = team.Id;
            jobPost.Account__c = account.Id;
            insert jobPost;

            Candidate_Profile__c candProfile = new Candidate_Profile__c();
            candProfile.Name = 'Alex Hakes';
            candProfile.Email__c = 'alesx@gmail.com';
            insert candProfile;

            Job_Application__c jobApp = new Job_Application__c();
            jobApp.Name = 'Alex hakes';
            jobApp.Client_Approval_Process__c = 'Deloitte';
            jobApp.Profile_Status__c = 'Open';
            jobApp.Candidate_Profile__c = candProfile.Id;
            jobApp.Job_Posting__c = jobPost.Id;
            insert jobApp;
            
            // Comments__c comments = new Comments__c();
            // comments.Job_Application__c = jobApp.Id;
            // insert comments;




            String buttonType = 'Onboard';
            String comment = 'Good Knowledge';
            //String buttonTypeId = ;
            JobProfileCntrl.toGetJobApplicants(buttonType, jobApp.Id);   
            JobProfileCntrl.getContact(jobPost.Id);
            JobProfileCntrl.setL1InterviewScheduled(jobApp.Id);
            JobProfileCntrl.hideProfileStatus();
            //JobProfileCntrl.saveComment(jobApp.Id,comment);
            //JobProfileCntrl.getComments(jobApp.Id);
            //JobProfileCntrl.saveResubmitProfile()
 
    }

    @isTest(seeAllData=false)
    public static void toGetJobApplicantsTest2() {

        Account account = new Account();
        account.Name = 'Burlingt sew';
        insert account;
        
        Contact con = new Contact();
        con.AccountId = account.Id;
        con.LastName = 'B K';
        insert con;

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'FirstName',
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',     
            ContactId = con.id
            );

            CustomTeams__Teams__c team = new CustomTeams__Teams__c();
        team.Name = 'Team Delloite';
        insert team;

            Job_Posting__c jobPost = new Job_Posting__c();
            jobPost.Name = 'Job Sony';
            jobPost.Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
            jobPost.Job_OC_Status__c = 'Open';
            jobPost.No_Of_Candidate_Selected__c = 10;
            //jobPost.Contact__c= con.Id;
            jobPost.Teams__c = team.Id;
            jobPost.Account__c = account.Id;
            insert jobPost;

            Candidate_Profile__c candProfile = new Candidate_Profile__c();
            candProfile.Name = 'Alex Hakes';
            candProfile.Email__c = 'alesx@gmail.com';
            insert candProfile;

            Job_Application__c jobApp = new Job_Application__c();
            jobApp.Name = 'Alex hakes';
            jobApp.Client_Approval_Process__c = 'Deloitte';
            jobApp.Profile_Status__c = 'Open';
            jobApp.Candidate_Profile__c = candProfile.Id;
            jobApp.Job_Posting__c = jobPost.Id;
            insert jobApp;
            
            // Comments__c comments = new Comments__c();
            // comments.Job_Application__c = jobApp.Id;
            // insert comments;




            String buttonType = '';
            String comment = 'Good Knowledge';
            //String buttonTypeId = ;
            JobProfileCntrl.toGetJobApplicants(buttonType, jobApp.Id);   
            
 
    }
}