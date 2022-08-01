@isTest
public with sharing class JobProfileCntrlTest {
    @isTest(seeAllData=false)
    public static void toGetJobApplicantsTest() {

        Account account = new Account();
        account.Name = 'Burlingt sew';
        account.KTDO1__Billing_City__c = 'pune';
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

            KTDO1__Job_Posting__c jobPost = new KTDO1__Job_Posting__c();
            jobPost.Name = 'Job Sony';
            jobPost.KTDO1__Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
            jobPost.KTDO1__Job_OC_Status__c = 'Open';
            jobPost.KTDO1__No_Of_Candidate_Selected__c = 10;
            //jobPost.KTDO1__Contact__c= con.Id;
            jobPost.KTDO1__Teams__c = team.Id;
            jobPost.KTDO1__Account__c = account.Id;
            insert jobPost;

            KTDO1__Candidate_Profile__c candProfile = new KTDO1__Candidate_Profile__c();
            candProfile.Name = 'Alex Hakes';
            candProfile.KTDO1__Email__c = 'alesx@gmail.com';
            insert candProfile;

            KTDO1__Job_Application__c jobApp = new KTDO1__Job_Application__c();
            jobApp.Name = 'Alex hakes';
            jobApp.KTDO1__Client_Approval_Process__c = 'Deloitte';
            jobApp.KTDO1__Profile_Status__c = 'Open';
            jobApp.KTDO1__Candidate_Profile__c = candProfile.Id;
            jobApp.KTDO1__Job_Posting__c = jobPost.Id;
            insert jobApp;
            
            KTDO1__Comments__c comments = new KTDO1__Comments__c();
            comments.KTDO1__Job_Application__c = jobApp.Id;
            insert comments;




            String buttonType = 'Onboard';
            String comment = 'Good Knowledge';
            //String buttonTypeId = ;
            JobProfileCntrl.toGetJobApplicants(buttonType, jobApp.Id);   
            JobProfileCntrl.getContact(jobPost.Id);
            JobProfileCntrl.setL1InterviewScheduled(jobApp.Id);
            JobProfileCntrl.hideProfileStatus();
            JobProfileCntrl.saveComment(jobApp.Id,comment);
            JobProfileCntrl.getComments(jobApp.Id);
            //JobProfileCntrl.saveResubmitProfile()
 
    }

    @isTest(seeAllData=false)
    public static void toGetJobApplicantsTest2() {

        Account account = new Account();
        account.Name = 'Burlingt sew';
        account.KTDO1__Billing_City__c = 'pune';
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

            KTDO1__Job_Posting__c jobPost = new KTDO1__Job_Posting__c();
            jobPost.Name = 'Job Sony';
            jobPost.KTDO1__Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
            jobPost.KTDO1__Job_OC_Status__c = 'Open';
            jobPost.KTDO1__No_Of_Candidate_Selected__c = 10;
            //jobPost.KTDO1__Contact__c= con.Id;
            jobPost.KTDO1__Teams__c = team.Id;
            jobPost.KTDO1__Account__c = account.Id;
            insert jobPost;

            KTDO1__Candidate_Profile__c candProfile = new KTDO1__Candidate_Profile__c();
            candProfile.Name = 'Alex Hakes';
            candProfile.KTDO1__Email__c = 'alesx@gmail.com';
            insert candProfile;

            KTDO1__Job_Application__c jobApp = new KTDO1__Job_Application__c();
            jobApp.Name = 'Alex hakes';
            jobApp.KTDO1__Client_Approval_Process__c = 'Deloitte';
            jobApp.KTDO1__Profile_Status__c = 'Open';
            jobApp.KTDO1__Candidate_Profile__c = candProfile.Id;
            jobApp.KTDO1__Job_Posting__c = jobPost.Id;
            insert jobApp;
            
            KTDO1__Comments__c comments = new KTDO1__Comments__c();
            comments.KTDO1__Job_Application__c = jobApp.Id;
            insert comments;




            String buttonType = '';
            String comment = 'Good Knowledge';
            //String buttonTypeId = ;
            JobProfileCntrl.toGetJobApplicants(buttonType, jobApp.Id);   
            
 
    }
}
