Public class GoogleDriveController {
    
    // private String code;
    
    // public boolean val {
    //     get;
    //     set;
    // }

    // public blob file {
    //     get;
    //     set;
    // }
    
    // public String filetype {
    //     get;
    //     set;
    // }
    
    // public String filename {
    //     get;
    //     set;
    // }
    
    // public String gdriveFileId {
    //     get;
    //     set;
    // }
    // public List<String> documents {
    //     get;
    //     set;
    // }
    
    
    @AuraEnabled
    public static List<Job_Posting_Document__c> fetchJobPostingDocList(String JobApplicationId, String JobPostingId) {
        system.debug('JobApplicationId'+JobApplicationId);
        system.debug('JobPostingId'+JobPostingId);
        
        Boolean DocumentCheck = true;
        
       //INSERTING RECORD IN Job_Posting_Documents__c ,IF THERE IS NO RECORD FOR Job_Application__c STARTS
        List<Job_Posting_Document__c> docs = [select Id,Name,Job_Posting__c,Document_Master__c,Job_Application__c from Job_Posting_Document__c where Job_Posting__c =: JobPostingId AND Job_Application__c = null];
        List<Job_Posting_Document__c> documentList = new  List<Job_Posting_Document__c>();

         if(docs <> null){

            //CHECKING Job_Application__c IS CREATED IN Job_Posting_Document__c STARTED
            List<Job_Posting_Document__c> docsCheckList = [select Id,Job_Application__c from Job_Posting_Document__c where Job_Application__c =: JobApplicationId AND Job_Posting__c=: JobPostingId limit 1];
            System.debug('docsCheckList>>>'+docsCheckList.size());
             if(docsCheckList.size() == 0){
                for(Job_Posting_Document__c doc : docs){
                    Job_Posting_Document__c document = new Job_Posting_Document__c(Name = doc.Name,Document_Master__c=doc.Document_Master__c,Job_Posting__c=doc.Job_Posting__c,Job_Application__c=JobApplicationId);
                    documentList.add(document);
                       }
            }
                insert documentList;
        }
        //INSERTING RECORD IN Job_Posting_Documents__c ,IF THERE IS NO RECORD FOR Job_Application__c STARTS
        
       //GET RECORDS FROM Job_Posting_Document__c
        List <Job_Posting_Document__c> lstOfValues = [select Name,GDrive_Doc_URL__c,Azure_Document_URL__c,Azure_FileID__c from Job_Posting_Document__c where Job_Application__c =: JobApplicationId AND Job_Posting__c =: JobPostingId];
        system.debug('lstOfValues>>>'+lstOfValues);
        return lstOfValues;
    }
    
    @AuraEnabled
    public static boolean showDocumentVerifiedButton(String JobApplicationId, String JobPostingId) {
        system.debug('JobApplicationId'+JobApplicationId);
        system.debug('JobPostingId'+JobPostingId);
        List <Job_Posting_Document__c> lstOfValues = [select Name,GDrive_Doc_URL__c from Job_Posting_Document__c where Job_Application__c =: JobApplicationId AND Job_Posting__c =: JobPostingId];
        system.debug('lstOfValues>>>'+lstOfValues);
        for(Job_Posting_Document__c value : lstOfValues){
            if(value.GDrive_Doc_URL__c == null)
            {
                return false;
            }
        }
        return true;
    }
    
    
    @AuraEnabled
    public static String fetchDocumentStorageName(String JobPostingId) {
        Job_Posting__c storageName = [select Document_Stoarge__c from Job_Posting__c where Id =: JobPostingId];
        String storageNameValue = storageName.Document_Stoarge__c;
        return storageNameValue;
    }
    

    @AuraEnabled
    public static String getAccessToken(){
        Google_Drive_File_Upload__c detail = Google_Drive_File_Upload__c.getInstance();         
        String key = detail.Client_ID__c;
        String secret = detail.Client_Secret__c;
        //string key ='862976282738-stoq67bq4u6f0aluep688fdmetllintg.apps.googleusercontent.com';  //<Your client id>;
        //string secret ='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'; //<Your client secret >;
        string redirecturi ='https://developers.google.com/oauthplayground'; //<Your Visual force Page URL>; 
        // Should be //the same URL in authorized URL in your Google Developers Console //Project.
        String accesstoken;
        String refreshtoken;
        Integer expiresIn;
        String tokentype;
        Google_Drive_Token__mdt gd= [Select Refresh_Token__c  from Google_Drive_Token__mdt where DeveloperName =: 'lable_1'];
        refreshtoken = gd.Refresh_Token__c;
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'client_id=' + key + '&client_secret=' + secret + '&refresh_token='+refreshtoken+'&redirect_uri=' + redirecturi + '&grant_type=refresh_token';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60 * 1000);
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        system.debug('resp>>'+resp);
        
        JSONParser parser = JSON.createParser(resp);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'access_token') {
                    accesstoken = parser.getText();
                } else if (fieldName == 'expires_in') {
                    expiresIn = parser.getIntegerValue();
                } else if (fieldname == 'token_type') {
                    tokentype = parser.getText();
                }
                
            } 
        }
        system.debug('accesstoken>>'+accesstoken);
        
        return accesstoken;
    }
    
    
    
    @AuraEnabled
    Public static string gdriveDocUpload(String attachmentId, String accessToken,String uploadedDocId, String jobApplication, String jobPosting) {
        String fileID;
        String webContentLink;
        String embedLink;
        String accFolderId;
        String jpFolderId;
        String apFolderId;
        
        // List<ContentVersion> cvFile = [SELECT Title,VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        // System.debug('cvFile>>'+cvFile);
        // blob file = cvFile[0].VersionData;
        // String filetype;
        // String filename = cvFile[0].Title;
        
        // system.debug('file>>>'+file);
        // system.debug('filename>>>'+filename);
        // system.debug('filetype>>>'+filetype);
        
        
        // Google_Drive_File_Upload__c detail = Google_Drive_File_Upload__c.getInstance();         
        // String key = detail.Client_ID__c;
        // String secret = detail.Client_Secret__c;
        // String thumbnailLink;
        // String fid;
        // String clink;
        // Integer expiresIn;
        // String tokentype;
        
        // //CREATE NEW FILE IN GOOGLE DRIVE STARTS
        
        // Http httpC = new Http();
        // HttpRequest reqC = new HttpRequest();
        // reqC.setMethod('POST');
        // reqC.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=media');
        // reqC.setHeader('content-type', 'text/plain');
        // reqC.setHeader('Authorization','Bearer '+accessToken);
        
        // String messageBody = 'Hi, This message is from Salesforce';
        // reqC.setBody(messageBody);  
        // reqC.setTimeout(60*1000);
        // HttpResponse respC = httpC.send(reqC);
        // system.debug('resp create file response>>>'+respC.getBody());
        Job_Posting_Document__c updateDocURL = [SELECT Name, GDrive_FileID__c, Id, GDrive_Doc_URL__c,GDrive_View_URL__c  FROM Job_Posting_Document__c WHERE Id =: uploadedDocId LIMIT 1];

        String authorizationHeaders = 'Bearer ' + accessToken; 
        Job_Posting__c folderIdRecord = [SELECT Id ,Name, GDrive_Folder_ID__c, Account__c, Account__r.GDrive_Folder_ID__c , Account__r.Name,(SELECT id ,Name, GDrive_Folder_ID__c FROM Job_Applications__r WHERE Id = :jobApplication) FROM Job_Posting__c WHERE Id = :jobPosting];
        Job_Application__c jobGDApplication = new Job_Application__c(Id=(folderIdRecord.Job_Applications__r).Id, Name=(folderIdRecord.Job_Applications__r).Name);
        Account jobAccount = new Account(Id=folderIdRecord.Account__c, Name=folderIdRecord.Account__r.Name);
        apFolderId = (folderIdRecord.Job_Applications__r).GDrive_Folder_ID__c;
        System.debug(LoggingLevel.INFO, updateDocURL);
        System.debug('Account GD Folder'+folderIdRecord.Account__r.GDrive_Folder_ID__c);
        System.debug('Account Name'+folderIdRecord.Account__r.Name);
        System.debug('Job Posting Folder'+folderIdRecord.GDrive_Folder_ID__c);
        System.debug('Job Posting Name'+folderIdRecord.Name);
        System.debug('Job Application'+(folderIdRecord.Job_Applications__r));
        System.debug('Job Application Name'+(folderIdRecord.Job_Applications__r).Name);
        System.debug('Job Application Folder'+(folderIdRecord.Job_Applications__r).GDrive_Folder_ID__c);
        System.debug('File Uploaded'+updateDocURL.Name);
        System.debug('attachmentId>>'+attachmentId);
        System.debug('accessToken>>'+accessToken);
        System.debug('uploadedDocId>>'+uploadedDocId);

        //Acc f
        if(String.isBlank(folderIdRecord.Account__r.GDrive_Folder_ID__c)){
            String name = folderIdRecord.Account__r.Name;
            Httpresponse response = googleDriveFunction(authorizationHeaders, name);
            system.debug('Create Account Folder resp>>'+response.getBody());
            JSONParser getAccountFolderIdParser = JSON.createParser(response.getBody());
            while (getAccountFolderIdParser.nextToken() != null) {
                if ((getAccountFolderIdParser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = getAccountFolderIdParser.getText();
                    System.debug('Folder Creation Response'+fieldName);
                    getAccountFolderIdParser.nextToken();
                    if (fieldName == 'Id') {
                        accFolderId = getAccountFolderIdParser.getText();
                        folderIdRecord.Account__r.GDrive_Folder_ID__c = accFolderId;
                        jobAccount.GDrive_Folder_ID__c = accFolderId;
                    }
                } 
            }
        }
        if(String.isBlank(folderIdRecord.GDrive_Folder_ID__c) & String.isNotBlank(folderIdRecord.Account__r.GDrive_Folder_ID__c)){
            String name = folderIdRecord.Name;
            String inId = folderIdRecord.Account__r.GDrive_Folder_ID__c;
            Httpresponse response = googleDriveFunction(authorizationHeaders, name, inId);
            system.debug('Create Account Folder resp>>'+response.getBody());
            JSONParser getAccountFolderIdParser = JSON.createParser(response.getBody());
            while (getAccountFolderIdParser.nextToken() != null) {
                if ((getAccountFolderIdParser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = getAccountFolderIdParser.getText();
                    System.debug('Folder Creation Response'+fieldName);
                    getAccountFolderIdParser.nextToken();
                    if (fieldName == 'Id') {
                        jpFolderId = getAccountFolderIdParser.getText();
                        folderIdRecord.GDrive_Folder_ID__c = jpFolderId;
                   
                    }
                } 
            }
        }
        if(String.isBlank((folderIdRecord.Job_Applications__r).GDrive_Folder_ID__c) & String.isNotBlank(folderIdRecord.GDrive_Folder_ID__c)){
            String name = (folderIdRecord.Job_Applications__r).Name;
            String inId = folderIdRecord.GDrive_Folder_ID__c;
            Httpresponse response = googleDriveFunction(authorizationHeaders, name, inId);
            system.debug('Create Account Folder resp>>'+response.getBody());
            JSONParser getAccountFolderIdParser = JSON.createParser(response.getBody());
            while (getAccountFolderIdParser.nextToken() != null) {
                if ((getAccountFolderIdParser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = getAccountFolderIdParser.getText();
                    System.debug('Folder Creation Response'+fieldName);
                    getAccountFolderIdParser.nextToken();
                    if (fieldName == 'Id') {
                        apFolderId = getAccountFolderIdParser.getText();
                        jobGDApplication.GDrive_Folder_ID__c = apFolderId;
                    }
                } 
            }
        }

       
        
        
        // //CREATE NEW FILE IN GOOGLE DRIVE ENDS
        
         List<ContentVersion> cvFile = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
         Blob myBlob = cvFile[0].VersionData;
         String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
         string authorizationHeader = 'Bearer ' + accessToken; 
        Integer contentSize = myBlob.size();
        HttpRequest req = new HttpRequest();
        req.setheader('Authorization',authorizationHeader);
        req.setheader('Content-Length',String.valueOf(contentSize));
        req.setheader('Content-Type','image/'+cvFile[0].FileType);
        req.setMethod('POST');  
        req.setEndpoint(url); 
        req.setBodyAsBlob(myBlob); 
        Http h = new Http(); 
        Httpresponse resp = h.send(req);
        system.debug('resp>>'+resp.getBody());
        Map<String, Object> p = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        fileID=(String) p.get('id');
        System.debug('fileID>>'+fileID);
        
        // Rename file
        String urlRename = 'https://www.googleapis.com/drive/v3/files/'+fileID+'?addParents=';
        HttpRequest request = new HttpRequest();
        request.setheader('Authorization',authorizationHeader);
        request.setheader('Content-Type','application/json');
        request.setMethod('PATCH');  
        String folderId = apFolderId;
        request.setEndpoint(urlRename+folderId); 
        String fName= updateDocURL.Name+' '+(folderIdRecord.Job_Applications__r).Name;
        String renameBody = '{"name":"'+fname+'"}';
        request.setBody(renameBody);
        Http fireRequest = new Http(); 
        Httpresponse response = fireRequest.send(request);
        system.debug('rename resp>>'+response.getBody());
       
        // end rename

        
        // String boundary = '----------9889464542212';
        // String delimiter = '\r\n--' + boundary + '\r\n';
        // String close_delim = '\r\n--' + boundary + '--';
        // if(file!=null)
        // {
        //     String bodyEncoded = EncodingUtil.base64Encode(file);
        //     //Folder Id of Google drive Folder
        //     String FolderId='1kPk5J6nK_Dvn4kKhjznlA1tRArwmH938';
            
        //     String body1 = '{"title" : filename,"mimeType" : "image/jpeg","parents": [{"kind": "drive#fileLink","id": "1kPk5J6nK_Dvn4kKhjznlA1tRArwmH938"}]}';
        //     try{
        //         Http http = new Http();
        //         HttpRequest req1 = new HttpRequest();
        //         req1.setEndpoint('https://www.googleapis.com/drive/v2/files?uploadType=media');
        //         req1.setHeader('Authorization', 'Bearer ' + accesstoken);
        //         req1.setHeader('Content-length', String.valueOf(body1.length()));
        //         req1.setBody(body1);
        //         req1.setMethod('POST');
        //         req1.setTimeout(60 * 1000);
        //         System.debug('req1>>'+req1);
        //         HttpResponse resp1 = http.send(req1);
        //         System.debug(resp1.getBody());
        //     } catch
        //         (Exception e) {
        //             System.debug(LoggingLevel.ERROR,
        //                          'Call exception ' + e.getMessage());
        //         }
        // }

        JSONParser parser = JSON.createParser(resp.getBody());
        system.debug('parser>>'+parser);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'webContentLink') {
                    webContentLink = parser.getText();
                } 
                if (fieldName == 'embedLink') {
                    embedLink = parser.getText();
                } 
            } 
        }
          System.debug('webContentLink>>'+webContentLink);
        System.debug('embedLink>>'+embedLink);
        
        if(folderIdRecord != null){
            update folderIdRecord;
            System.debug(jobAccount);
            System.debug(jobGDApplication);
            update jobAccount;
            update jobGDApplication;
        }
        
        if(uploadedDocId != null){
            //Query is on top 
            System.debug('updateDocURL>>'+updateDocURL);
            updateDocURL.GDrive_Doc_URL__c = webContentLink;
            updateDocURL.GDrive_View_URL__c = embedLink;
            updateDocURL.GDrive_FileID__c = fileID;
            update updateDocURL;
        }
        
        delete new ContentDocument(Id = cvFile[0].ContentDocumentId);
        //return String.valueOf(res.getStatuscode());
        // return 'null';

        return String.valueOf(resp.getStatuscode());
    }

  

    // Resume Upload while creating candidate profile
    @AuraEnabled
    public static String gDriveResumeUpload(String candidateName, String attachmentId, String uploadedDocId){
        String accessToken = getAccessToken();
        try {
            String fileID;
            String webContentLink;
            String embedLink;
            if(String.isBlank(candidateName)){
                candidateName='Resume Upload';
            }
            List<ContentVersion> file = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
            Blob myBlob = file[0].VersionData;
            Integer contentSize = myBlob.size();
            String url = 'https://www.googleapis.com/upload/drive/v3/files?uploadType=media';
            string authorizationHeader = 'Bearer ' + accessToken; 
            HttpRequest req = new HttpRequest();
            req.setheader('Authorization',authorizationHeader);
            req.setheader('Content-Length',String.valueOf(contentSize));
            req.setheader('Content-Type', 'application/'+file[0].FileType);
            req.setMethod('POST');

          

          req.setBodyAsBlob(myBlob);
            req.setEndpoint(url);
            Http h = new Http();
            Httpresponse response = h.send(req);
            system.debug('resp>>'+response.getBody());
           System.debug(JSON.deserializeUntyped(response.getBody()));
            JSONParser parser = JSON.createParser(response.getBody());
            system.debug('parser>>'+parser);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if (fieldName == 'id') {
                        fileId = parser.getText();
                    }  
                    if (fieldName == 'webContentLink') {
                    webContentLink = parser.getText();
                    } 
                    if (fieldName == 'embedLink') {
                        embedLink = parser.getText();
                    } 
                } 
            }


            
            GoogleDriveUpload__c detail = GoogleDriveUpload__c.getInstance();         
            String folderId = detail.ResumeFolderId__c;
            String urlRename = 'https://www.googleapis.com/drive/v3/files/'+fileID+'?addParents=';
            HttpRequest request = new HttpRequest();
            request.setheader('Authorization',authorizationHeader);
            request.setheader('Content-Type','application/json');
            request.setMethod('PATCH');  
            request.setEndpoint(urlRename+folderId); 
            String renameBody = '{"name":"'+candidateName+'"}';
            request.setBody(renameBody);
            Http fireRequest = new Http(); 
            Httpresponse responseRename = fireRequest.send(request);
            system.debug('rename resp>>'+responseRename.getBody());
           
           

            //p
            String urlp = 'https://www.googleapis.com/drive/v3/files/'+fileID+'/permissions';
            HttpRequest prequest = new HttpRequest();
            prequest.setheader('Authorization',authorizationHeader);
            prequest.setheader('Content-Type','application/json');
            prequest.setMethod('POST');  
            prequest.setEndpoint(urlp); 
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeObjectField('role', 'reader');
            gen.writeObjectField('type', 'anyone');
            gen.writeEndObject();
            String bodyp = gen.getAsString();
            System.debug(bodyp);

            prequest.setBody(bodyp);
            Http firepRequest = new Http(); 
            Httpresponse responsep = firepRequest.send(prequest);
            System.debug(responsep);
            System.debug(responsep.getStatus() +' : ' + responsep.getStatusCode());
            System.debug(responsep.getBody());

            Resume__c newResume = new Resume__c();
            newResume.Name = fileId;
            newResume.PreviewLink__c = 'https://drive.google.com/file/d/'+fileId+'/view';
            newResume.FileLink__c	='https://drive.google.com/uc?id='+fileId+'&export=download';
            
            insert newResume;
            String returnResponse= responsep.getStatusCode()+'#'+newResume.Id;
           return returnResponse;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static Httpresponse googleDriveFunction(String authorizationHeaders, String name) {
        String urlCreateFolder = 'https://www.googleapis.com/drive/v3/files';
            HttpRequest requestfolder = new HttpRequest();
            requestfolder.setheader('Authorization',authorizationHeaders);
            requestfolder.setheader('Content-Type','application/json');
            requestfolder.setMethod('POST');  
            requestfolder.setEndpoint(urlCreateFolder); 
            String urlCreateFolderMetadata = '{"mimeType": "application/vnd.google-apps.folder", "name": "'+name+'"}';
            requestfolder.setBody(urlCreateFolderMetadata);
            Http fireFolderRequest = new Http(); 
            Httpresponse responseCreateFolder = fireFolderRequest.send(requestfolder);
            return responseCreateFolder;
    }

    public static Httpresponse googleDriveFunction(String authorizationHeaders, String name, String inId) {
        
        String urlCreateFolder = 'https://www.googleapis.com/drive/v3/files';
            HttpRequest requestfolder = new HttpRequest();
            requestfolder.setheader('Authorization',authorizationHeaders);
            requestfolder.setheader('Content-Type','application/json');
            requestfolder.setMethod('POST');  
            requestfolder.setEndpoint(urlCreateFolder); 
            String urlCreateFolderMetadata = '{"mimeType": "application/vnd.google-apps.folder", "name": "'+name+'", "parents":["'+inId+'"]}';
            requestfolder.setBody(urlCreateFolderMetadata);
            Http fireFolderRequest = new Http(); 
            Httpresponse responseCreateFolder = fireFolderRequest.send(requestfolder);
            return responseCreateFolder;
    }
    
    
    
    
    @AuraEnabled
    public static String DownloadDoc(String downloadDocId) {
        System.debug('downloadDocId>>'+downloadDocId);
        Job_Posting_Document__c downloadDocURL = [SELECT GDrive_Doc_URL__c FROM Job_Posting_Document__c WHERE Id =: downloadDocId];
        System.debug('downloadDocURL>>'+downloadDocURL);
        String downloadURL = downloadDocURL.GDrive_Doc_URL__c;
        return downloadURL;
    }
    
    @AuraEnabled
    public static String ViewDoc(String viewDocId) {
        System.debug('viewDocId>>'+viewDocId);
        Job_Posting_Document__c viewDocURL = [SELECT GDrive_View_URL__c FROM Job_Posting_Document__c WHERE Id =: viewDocId];
        System.debug('viewDocURL>>'+viewDocURL);
        String viewURL = viewDocURL.GDrive_View_URL__c;
        return viewURL;
    }
    
    @AuraEnabled
    public static void changeJobAppProfileStatusToVerified(String jobApplicationId) {
        System.debug('jobApplicationId>>'+jobApplicationId);
        Job_Application__c jobAppProfileStatus = [SELECT Profile_Status__c FROM Job_Application__c WHERE Id =: jobApplicationId];
        System.debug('jobAppProfileStatus>>'+jobAppProfileStatus);
        jobAppProfileStatus.Profile_Status__c = 'Document Verified';
        update jobAppProfileStatus;
    }
    
    @AuraEnabled
    public static void changeJobAppProfileStatusToRejected(String jobApplicationId) {
        System.debug('jobApplicationId>>'+jobApplicationId);
        Job_Application__c jobAppProfileStatus = [SELECT Profile_Status__c FROM Job_Application__c WHERE Id =: jobApplicationId];
        System.debug('jobAppProfileStatus>>'+jobAppProfileStatus);
        jobAppProfileStatus.Profile_Status__c = 'Document Rejected';
        update jobAppProfileStatus;
    }
    
    @AuraEnabled
    public static void cloaseDocumentUploadppup(String jobApplicationId) {
        System.debug('jobApplicationId>>'+jobApplicationId);
        Job_Application__c jobAppProfileStatus = [SELECT Profile_Status__c FROM Job_Application__c WHERE Id =: jobApplicationId];
        System.debug('jobAppProfileStatus>>'+jobAppProfileStatus);
        jobAppProfileStatus.Profile_Status__c = 'L2 Interview Approved';
        update jobAppProfileStatus;
    }
    
    
    
    // Azure File Upload and File Download
    @AuraEnabled
    Public static string azureDocUpload(String attachmentId ,String uploadedDocId, String jobApplication, String jobPosting) {
        AzureFileUpload azureupload = new AzureFileUpload();
        Job_Posting_Document__c applicationDocument = [SELECT Id,Document_Master__c, 	Job_Application__c FROM Job_Posting_Document__c WHERE Id=:uploadedDocId LIMIT 1];
        System.debug(applicationDocument);

        // to get which document is being uploaded Ex SSLC PAN etc
        Job_Posting_Document__c updateDocURL = [SELECT Name, Azure_FileID__c, Id, Document_Master__c, Job_Application__c FROM Job_Posting_Document__c WHERE Id =: uploadedDocId LIMIT 1];
        
         Job_Posting__c folderIdRecord = [SELECT Id ,Name, Azure_Folder_ID__c, Account__c, Account__r.Azure_Folder_ID__c , Account__r.Name,(SELECT id ,Name, Azure_Folder_ID__c FROM Job_Applications__r WHERE Id = :jobApplication) FROM Job_Posting__c WHERE Id = :jobPosting];

        

         
         Account jobAccount = new Account(Id=folderIdRecord.Account__c, Name=folderIdRecord.Account__r.Name);
         if(String.isBlank(folderIdRecord.Account__r.Azure_Folder_ID__c)){
            String folderId = folderIdRecord.Account__r.Name +'-'+folderIdRecord.Account__c;
            jobAccount.Azure_Folder_ID__c = folderId;
            System.debug(LoggingLevel.INFO, jobAccount.Azure_Folder_ID__c);
            
            System.debug('Account Folder name updated');
        }else {
            System.debug('Azure account Folder Name Already Exist');
          
        }
        if(String.isBlank(folderIdRecord.Account__r.Azure_Folder_ID__c)){
            folderIdRecord.Azure_Folder_ID__c = folderIdRecord.Name +'-'+ folderIdRecord.Id;
            System.debug(LoggingLevel.INFO, folderIdRecord.Azure_Folder_ID__c);
          
            System.debug('job posting Folder name updated');
        } else {
            System.debug('Job Posting Folder Name Already Exist');
            
        }
        Job_Application__c jobGDApplication = new Job_Application__c(Id=(folderIdRecord.Job_Applications__r).Id, Name=(folderIdRecord.Job_Applications__r).Name);
        if(String.isBlank((folderIdRecord.Job_Applications__r).Azure_Folder_ID__c)){
            jobGDApplication.Azure_Folder_ID__c = (folderIdRecord.Job_Applications__r).Name +'-'+ jobGDApplication.Id;
            System.debug(jobGDApplication.Azure_Folder_ID__c);
           
            System.debug('job Application Folder name updated');
        } else {
            System.debug('Job Application Folder Name Already Exist');
        }
        // update jobAccount;
    

        String fplink;
        if(String.isNotBlank(folderIdRecord.Azure_Folder_ID__c) && String.isNotBlank( jobAccount.Azure_Folder_ID__c) && String.isNotBlank(jobGDApplication.Azure_Folder_ID__c)){
            fplink = jobAccount.Azure_Folder_ID__c+'/'+folderIdRecord.Azure_Folder_ID__c+'/'+jobGDApplication.Azure_Folder_ID__c+'/';
        }


        System.debug(LoggingLevel.INFO, updateDocURL);
        System.debug('File Uploaded'+updateDocURL.Name);


        System.debug('Account GD Folder'+folderIdRecord.Account__r.Azure_Folder_ID__c);
        System.debug('Account Name'+folderIdRecord.Account__r.Name);
        System.debug('Job Posting Folder'+folderIdRecord.Azure_Folder_ID__c);
        System.debug('Job Posting Name'+folderIdRecord.Name);
        System.debug('Job Application'+(folderIdRecord.Job_Applications__r));
        System.debug('Job Application Name'+(folderIdRecord.Job_Applications__r).Name);
        System.debug('Job Application Folder'+(folderIdRecord.Job_Applications__r).Azure_Folder_ID__c);
        System.debug('attachmentId>>'+attachmentId);
        System.debug('uploadedDocId>>'+uploadedDocId);
        
        String fileUploadName = (folderIdRecord.Job_Applications__r).Name+'-'+ updateDocURL.Name+ '.jpg';
        System.debug(LoggingLevel.INFO, fileUploadName+'File Upload Name');

        String status = azureupload.fileUpload(attachmentId, uploadedDocId, fplink, fileUploadName);
        
        // String fileUploadName = applicationDocument.Id+'$'+applicationDocument.Document_Master__c+'$'+applicationDocument.Job_Application__c+'.jpg';
        System.debug(LoggingLevel.INFO, fileUploadName+'File Upload Name');
        if(status!= 'Failure'){
             Job_Posting_Document__c updateAzureDocURL = [SELECT Azure_Document_URL__c  FROM Job_Posting_Document__c WHERE Id =: uploadedDocId];
            updateAzureDocURL.Azure_FileID__c = status;
            update jobAccount;
            update folderIdRecord;
            update jobGDApplication;
            update updateAzureDocURL;
        }
        return status;
    }
    
    @AuraEnabled
    public static String azureFileDownload(String uploadedDocId)
    {   
        Job_Posting_Document__c updateAzureDocURL = [SELECT Azure_FileID__c  FROM Job_Posting_Document__c WHERE Id =: uploadedDocId];
        String azureFileId = updateAzureDocURL.Azure_FileID__c;
        AzureFileUpload azureDownload = new AzureFileUpload();
        System.debug(azureFileId);
        String link = azureDownload.downloadAzureFile(azureFileId);
        return link;
    }
    
    
}