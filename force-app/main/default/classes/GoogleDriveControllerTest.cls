@IsTest
public class GoogleDriveControllerTest {
    @IsTest(seeAllData=false)
    public static void fetchJobPostingDocList() {
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
                jobPost.KTDO1__Document_Stoarge__c = 'Google Drive';
                insert jobPost;
    
                KTDO1__Candidate_Profile__c candProfile = new KTDO1__Candidate_Profile__c();
                candProfile.Name = 'Alex Hakes';
                candProfile.KTDO1__Email__c = 'alesx@gmail.com';
                insert candProfile;

                KTDO1__Document_Master__c docMaster = new KTDO1__Document_Master__c();
                docMaster.Name = 'PUC';
                docMaster.KTDO1__Job_Posting_Documents__c  = jobPost.Id;
                insert docMaster;

                KTDO1__Job_Application__c jobApp = new KTDO1__Job_Application__c();
                jobApp.Name = 'Alex hakes';
                jobApp.KTDO1__Client_Approval_Process__c = 'Deloitte';
                jobApp.KTDO1__Profile_Status__c = 'Open';
                jobApp.KTDO1__Candidate_Profile__c = candProfile.Id;
                jobApp.KTDO1__Job_Posting__c = jobPost.Id;
                //jobApp.KTDO1__Job_Posting_Document__c = jobPostDocument.Id
                insert jobApp;

                KTDO1__Job_Posting_Document__c jobPostDocument = new KTDO1__Job_Posting_Document__c();
                jobPostDocument.Name = docMaster.Name;
                jobPostDocument.KTDO1__Job_Posting__c = jobPost.Id;
                jobPostDocument.KTDO1__Job_Application__c = jobApp.Id;
                jobPostDocument.KTDO1__Document_Master__c = docMaster.Id;
                insert jobPostDocument;
    
                
                
                KTDO1__Comments__c comments = new KTDO1__Comments__c();
                comments.KTDO1__Job_Application__c = jobApp.Id;
                insert comments;

                GoogleDriveController.fetchJobPostingDocList(jobApp.Id,jobPost.Id);
                GoogleDriveController.showDocumentVerifiedButton(jobApp.Id,jobPost.Id);
                GoogleDriveController.fetchDocumentStorageName(jobPost.Id);
                //GoogleDriveController.getAccessToken();
                GoogleDriveController.DownloadDoc(jobPostDocument.Id);
                GoogleDriveController.ViewDoc(jobPostDocument.Id);
                GoogleDriveController.changeJobAppProfileStatusToVerified(jobApp.Id);
                GoogleDriveController.changeJobAppProfileStatusToRejected(jobApp.Id);
                GoogleDriveController.cloaseDocumentUploadppup(jobApp.Id);
                GoogleDriveController.azureFileDownload(jobPostDocument.Id);
    }

    
}