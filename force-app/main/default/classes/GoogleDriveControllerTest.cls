@IsTest
public class GoogleDriveControllerTest {
    @IsTest(seeAllData=false)
    public static void testGoogleDriveController1() {
        Account account = new Account();
        account.Name = 'Burlingt sew';
        //account.Billing_City__c = 'pune';
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
        jobPost.Document_Stoarge__c = 'Google Drive';
        insert jobPost;
        
        Candidate_Profile__c candProfile = new Candidate_Profile__c();
        candProfile.Name = 'Alex Hakes';
        candProfile.Email__c = 'alesx@gmail.com';
        insert candProfile;
        
        Document_Master__c docMaster = new Document_Master__c();
        docMaster.Name = 'PUC';
        docMaster.Job_Posting_Documents__c  = jobPost.Id;
        insert docMaster;
        
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Name = 'Alex hakes';
        jobApp.Client_Approval_Process__c = 'Deloitte';
        jobApp.Profile_Status__c = 'Open';
        jobApp.Candidate_Profile__c = candProfile.Id;
        jobApp.Job_Posting__c = jobPost.Id;
        //jobApp.Job_Posting_Document__c = jobPostDocument.Id
        insert jobApp;
        
        Job_Posting_Document__c jobPostDocument = new Job_Posting_Document__c();
        jobPostDocument.Name = docMaster.Name;
        jobPostDocument.Job_Posting__c = jobPost.Id;
        jobPostDocument.Job_Application__c = jobApp.Id;
        jobPostDocument.Document_Master__c = docMaster.Id;
        insert jobPostDocument;
        
        
        
        //Comments__c comments = new Comments__c();
        //comments.Job_Application__c = jobApp.Id;
        //insert comments;
        
        GoogleDriveController.fetchJobPostingDocList(jobApp.Id,jobPost.Id);
        GoogleDriveController.showDocumentVerifiedButton(jobApp.Id,jobPost.Id);
        GoogleDriveController.fetchDocumentStorageName(jobPost.Id);
        GoogleDriveController.DownloadDoc(jobPostDocument.Id);
        GoogleDriveController.ViewDoc(jobPostDocument.Id);
        GoogleDriveController.changeJobAppProfileStatusToVerified(jobApp.Id);
        GoogleDriveController.changeJobAppProfileStatusToRejected(jobApp.Id);
        GoogleDriveController.cloaseDocumentUploadppup(jobApp.Id);
        GoogleDriveController.azureFileDownload(jobPostDocument.Id);
    }
    
    @isTest(seealldata=true)
    private static void testGoogleDriveController2() {
        Account account = new Account();
        account.Name = 'Burlingt sew';
        //account.Billing_City__c = 'pune';
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
        jobPost.Document_Stoarge__c = 'Google Drive';
        insert jobPost;
        
        Candidate_Profile__c candProfile = new Candidate_Profile__c();
        candProfile.Name = 'Alex Hakes';
        candProfile.Email__c = 'alesx@gmail.com';
        insert candProfile;
        
        Document_Master__c docMaster = new Document_Master__c();
        docMaster.Name = 'PUC';
        docMaster.Job_Posting_Documents__c  = jobPost.Id;
        insert docMaster;
        
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Name = 'Alex hakes';
        jobApp.Client_Approval_Process__c = 'Deloitte';
        jobApp.Profile_Status__c = 'Open';
        jobApp.Candidate_Profile__c = candProfile.Id;
        jobApp.Job_Posting__c = jobPost.Id;
        //jobApp.Job_Posting_Document__c = jobPostDocument.Id
        insert jobApp;
        
        Job_Posting_Document__c jobPostDocument = new Job_Posting_Document__c();
        jobPostDocument.Name = docMaster.Name;
        jobPostDocument.Job_Posting__c = jobPost.Id;
        jobPostDocument.Job_Application__c = jobApp.Id;
        jobPostDocument.Document_Master__c = docMaster.Id;
        insert jobPostDocument;
        
        //Comments__c comments = new Comments__c();
        //comments.Job_Application__c = jobApp.Id;
        //insert comments;
        
        // ContentVersion version = new ContentVersion();
        // version.Title='dharshan';
        // version.PathOnClient='sample.jpg';
        // version.VersionData=EncodingUtil.base64Decode('AA==');
        
        // String path = 'https://nxstage--qa--c.cs92.content.force.com/sfc/servlet.shepherd/version/download';                             
        // version.PathOnClient = path;
        
        // Blob b=Blob.valueOf('Unit Test Attachment Body');
        // version.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        // insert version;
        
        // ContentVersion cvvvv = new ContentVersion(title='foo', contentUrl='http:///www.foor.bar');
        // insert cvvvv;
        
        // ContentVersion cv = new ContentVersion();
        // cv.ContentLocation = 'S'; // 'S' = a Salesforce File
        // cv.VersionData = EncodingUtil.base64Decode('AA==');
        // cv.Title = 'dharshan';
        // String path = 'https://nxstage--qa--c.cs92.content.force.com/sfc/servlet.shepherd/version/download'; 
        // cv.PathOnClient = path;
        
        // //Utils.DatabaseInsert(cv);
        // insert cv;
        
        //String myId = '069nnnnnnnnnnnnnnn';
        //String path = 'https://nxstage--qa--c.cs92.content.force.com/sfc/servlet.shepherd/version/download'; 
        
        //ContentVersion cv = new ContentVersion(Title='foo', contentUrl='http:///www.foor.bar' , ContentDocumentId = myId , VersionData = EncodingUtil.base64Decode('AA==') , PathOnClient = path);
        //insert cv;
        //ContentVersion cvRes = [select id, ContentDocument.id, ContentDocument.title from ContentVersion where id= :cv.id];
        //ContentDocument cd = cv.ContentDocument;
        
        //Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        //ContentVersion cv = new ContentVersion();
        //cv.Title = 'test content trigger';      
        //cv.PathOnClient ='test';           
        //cv.VersionData =beforeblob;      
        //cv.ContentDocumentId = testContent.ContentDocumentId;
        //insert cv;
        
        //ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id];
        //system.debug('testContent>>'+testContent);
        
        //Attachment attachment = new Attachment();
        //attachment.ParentId = jobPostDocument.Id;
        //attachment.Name = 'Test Attachment for Parent';
        //attachment.Body = beforeblob;
        //insert attachment;
        
        //Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        //ContentVersion cv = new ContentVersion();
        //cv.Title = 'test content trigger';      
        //cv.PathOnClient ='test';           
        //cv.VersionData =beforeblob;      
        //insert cv;
        
        Attachment attach = [SELECT Id, Name, Body, ContentType, ParentId From Attachment LIMIT 1];
        
        List<ContentDocument> conDocument = [SELECT Id,Title FROM ContentDocument];
        
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument[0].Id;//Add ContentDocumentId
        cDocLink.LinkedEntityId = attach.ParentId;//Add attachment parentId
        cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockGenerator());
        GoogleDriveController.getAccessToken();
        GoogleDriveController.azureDocUpload(cDocLink.ContentDocumentId,jobPostDocument.Id);
        GoogleDriveController.gdriveDocUpload(cDocLink.ContentDocumentId,'accessToken',jobPostDocument.Id);
        System.Test.StopTest();
    }
    
    @IsTest(seeAllData=false)
    public static void testGoogleDriveController3() {
    }
}