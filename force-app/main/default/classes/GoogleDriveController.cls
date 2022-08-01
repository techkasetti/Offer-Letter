Public class GoogleDriveController {
    
    private String code;
    
    public boolean val {
        get;
        set;
    }
    
    public blob file {
        get;
        set;
    }
    
    public String filetype {
        get;
        set;
    }
    
    public String filename {
        get;
        set;
    }
    
    public String gdriveFileId {
        get;
        set;
    }
    public List<String> documents {
        get;
        set;
    }

    
    @AuraEnabled
    public static List<KTDO1__Job_Posting_Document__c> fetchJobPostingDocList(String JobApplicationId, String JobPostingId) {
        system.debug('JobApplicationId'+JobApplicationId);
        system.debug('JobPostingId'+JobPostingId);

        Boolean DocumentCheck = true;
        
        //insert records in KTDO1__Job_Posting_Documents__c
        List<KTDO1__Document_Master__c> docs = [select Id,Name,KTDO1__Job_Posting_Documents__c from KTDO1__Document_Master__c where KTDO1__Job_Posting_Documents__c =: JobPostingId];

        List<KTDO1__Document_Master__c> docsInsert = docs;

        system.debug('docs>>'+docs);
        List<KTDO1__Job_Posting_Document__c> documentList = new  List<KTDO1__Job_Posting_Document__c>();
        if(docs != null){

            List<KTDO1__Job_Posting_Document__c> docsCheckList = [select Id,Name from KTDO1__Job_Posting_Document__c where KTDO1__Job_Application__c =: JobApplicationId];

            for(KTDO1__Job_Posting_Document__c docsCheck : docsCheckList ){
                for(KTDO1__Document_Master__c checkDocs : docs ){
                    if(docsCheck.Name == checkDocs.Name) {
                        DocumentCheck = false;
                    }
                }
            }

            if(DocumentCheck){
                for(KTDO1__Document_Master__c doc : docsInsert){
                    KTDO1__Job_Posting_Document__c document = new KTDO1__Job_Posting_Document__c(Name = doc.Name, 
                                                                                                 KTDO1__Document_Master__c=doc.Id,
                                                                                                 KTDO1__Job_Posting__c=JobPostingId,
                                                                                                 KTDO1__Job_Application__c=JobApplicationId
                                                                                                );
                    documentList.add(document);
                    system.debug('document>'+document);
                }
            }

            insert documentList;
        }
                
        //get records from KTDO1__Job_Posting_Documents__c
        List <KTDO1__Job_Posting_Document__c> lstOfValues = [select Name,KTDO1__GDrive_Doc_URL__c,KTDO1__Azure_Document_URL__c,KTDO1__Azure_FileID__c from KTDO1__Job_Posting_Document__c where KTDO1__Job_Application__c =: JobApplicationId AND KTDO1__Job_Posting__c =: JobPostingId];
        system.debug('lstOfValues>>>'+lstOfValues);
        return lstOfValues;
    }
    
    @AuraEnabled
    public static boolean showDocumentVerifiedButton(String JobApplicationId, String JobPostingId) {
        system.debug('JobApplicationId'+JobApplicationId);
        system.debug('JobPostingId'+JobPostingId);
        List <KTDO1__Job_Posting_Document__c> lstOfValues = [select Name,KTDO1__GDrive_Doc_URL__c from KTDO1__Job_Posting_Document__c where KTDO1__Job_Application__c =: JobApplicationId AND KTDO1__Job_Posting__c =: JobPostingId];
        system.debug('lstOfValues>>>'+lstOfValues);
        for(KTDO1__Job_Posting_Document__c value : lstOfValues){
            if(value.KTDO1__GDrive_Doc_URL__c == null)
            {
                return false;
            }
        }
        return true;
    }


    @AuraEnabled
    public static String fetchDocumentStorageName(String JobPostingId) {
        KTDO1__Job_Posting__c storageName = [select KTDO1__Document_Stoarge__c from KTDO1__Job_Posting__c where Id =: JobPostingId];
        String storageNameValue = storageName.KTDO1__Document_Stoarge__c;
        return storageNameValue;
    }


    @AuraEnabled
    public static String getAccessToken(){
        KTDO1__Google_Drive_File_Upload__c detail = KTDO1__Google_Drive_File_Upload__c.getInstance();         
        String key = detail.KTDO1__Client_ID__c;
        String secret = detail.KTDO1__Client_Secret__c;
        //string key ='862976282738-stoq67bq4u6f0aluep688fdmetllintg.apps.googleusercontent.com';  //<Your client id>;
        //string secret ='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'; //<Your client secret >;
        string redirecturi ='https://developers.google.com/oauthplayground'; //<Your Visual force Page URL>; 
        // Should be //the same URL in authorized URL in your Google Developers Console //Project.
        String accesstoken;
        String refreshtoken;
        Integer expiresIn;
        String tokentype;
        KTDO1__Google_Drive_Token__mdt gd= [Select KTDO1__Refresh_Token__c  from KTDO1__Google_Drive_Token__mdt where DeveloperName =: 'lable_1'];
        refreshtoken = gd.KTDO1__Refresh_Token__c;
        
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
    Public static string gdriveDocUpload(String attachmentId, String accessToken,String uploadedDocId) {
        system.debug('attachmentId>>'+attachmentId);
        system.debug('accessToken>>'+accessToken);
        system.debug('uploadedDocId>>'+uploadedDocId);
        
        String fileID;
        String webContentLink;
        String embedLink;
        
        List<ContentVersion> cvFile = [SELECT Title,VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        blob file = cvFile[0].VersionData;
        String filetype = cvFile[0].FileType;
        String filename = cvFile[0].Title;
        
        system.debug('file>>>'+file);
        system.debug('filename>>>'+filename);
        system.debug('filetype>>>'+filetype);


        KTDO1__Google_Drive_File_Upload__c detail = KTDO1__Google_Drive_File_Upload__c.getInstance();         
        String key = detail.KTDO1__Client_ID__c;
        String secret = detail.KTDO1__Client_Secret__c;
         String thumbnailLink;
         String fid;
         String clink;
         Integer expiresIn;
         String tokentype;

        //CREATE NEW FILE IN GOOGLE DRIVE STARTS

        Http httpC = new Http();
        HttpRequest reqC = new HttpRequest();
        reqC.setMethod('POST');
        reqC.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=media');
        reqC.setHeader('content-type', 'text/plain');
        reqC.setHeader('Authorization','Bearer '+accessToken);
        String messageBody = 'Hi, This message is from Salesforce';
        reqC.setBody(messageBody);  
        reqC.setTimeout(60*1000);
        HttpResponse respC = httpC.send(reqC);
        system.debug('resp create file response>>>'+respC.getBody());

        //CREATE NEW FILE IN GOOGLE DRIVE ENDS


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

         
      String boundary = '----------9889464542212';
      String delimiter = '\r\n--' + boundary + '\r\n';
      String close_delim = '\r\n--' + boundary + '--';
      if(file!=null)
      {
      String bodyEncoded = EncodingUtil.base64Encode(file);
      //Folder Id of Google drive Folder
      String FolderId='1kPk5J6nK_Dvn4kKhjznlA1tRArwmH938';

      String body1 = '{"title" : filename,"mimeType" : "image/jpeg","parents": [{"kind": "drive#fileLink","id": "1kPk5J6nK_Dvn4kKhjznlA1tRArwmH938"}]}';
      try{
      Http http = new Http();
      HttpRequest req1 = new HttpRequest();
      req1.setEndpoint('https://www.googleapis.com/drive/v2/files?uploadType=media');
      req1.setHeader('Authorization', 'Bearer ' + accesstoken);
      req1.setHeader('Content-length', String.valueOf(body1.length()));
      req1.setBody(body1);
      req1.setMethod('POST');
      req1.setTimeout(60 * 1000);
      System.debug('req1>>'+req1);
      HttpResponse resp1 = http.send(req1);
      System.debug(resp1.getBody());
         } catch
      (Exception e) {
          System.debug(LoggingLevel.ERROR,
      'Call exception ' + e.getMessage());
        }
      }


        if(uploadedDocId != null){
            KTDO1__Job_Posting_Document__c updateDocURL = [SELECT KTDO1__GDrive_FileID__c,Id,KTDO1__GDrive_Doc_URL__c,KTDO1__GDrive_View_URL__c  FROM KTDO1__Job_Posting_Document__c WHERE Id =: uploadedDocId];
            System.debug('updateDocURL>>'+updateDocURL);
            updateDocURL.KTDO1__GDrive_Doc_URL__c = webContentLink;
            updateDocURL.KTDO1__GDrive_View_URL__c = embedLink;
            updateDocURL.KTDO1__GDrive_FileID__c = fileID;
            update updateDocURL;
        }
        
        delete new ContentDocument(Id = cvFile[0].ContentDocumentId);
        //return String.valueOf(res.getStatuscode());
        return 'null';
    }
    
    
    
    
    @AuraEnabled
    public static String DownloadDoc(String downloadDocId) {
        System.debug('downloadDocId>>'+downloadDocId);
        KTDO1__Job_Posting_Document__c downloadDocURL = [SELECT KTDO1__GDrive_Doc_URL__c FROM KTDO1__Job_Posting_Document__c WHERE Id =: downloadDocId];
        System.debug('downloadDocURL>>'+downloadDocURL);
        String downloadURL = downloadDocURL.KTDO1__GDrive_Doc_URL__c;
        return downloadURL;
    }
    
    @AuraEnabled
    public static String ViewDoc(String viewDocId) {
        System.debug('viewDocId>>'+viewDocId);
        KTDO1__Job_Posting_Document__c viewDocURL = [SELECT KTDO1__GDrive_View_URL__c FROM KTDO1__Job_Posting_Document__c WHERE Id =: viewDocId];
        System.debug('viewDocURL>>'+viewDocURL);
        String viewURL = viewDocURL.KTDO1__GDrive_View_URL__c;
        return viewURL;
    }
    
    @AuraEnabled
    public static void changeJobAppProfileStatusToVerified(String jobApplicationId) {
        System.debug('jobApplicationId>>'+jobApplicationId);
        KTDO1__Job_Application__c jobAppProfileStatus = [SELECT KTDO1__Profile_Status__c FROM KTDO1__Job_Application__c WHERE Id =: jobApplicationId];
        System.debug('jobAppProfileStatus>>'+jobAppProfileStatus);
        jobAppProfileStatus.KTDO1__Profile_Status__c = 'Document Verified';
        update jobAppProfileStatus;
    }
    
    @AuraEnabled
    public static void changeJobAppProfileStatusToRejected(String jobApplicationId) {
        System.debug('jobApplicationId>>'+jobApplicationId);
        KTDO1__Job_Application__c jobAppProfileStatus = [SELECT KTDO1__Profile_Status__c FROM KTDO1__Job_Application__c WHERE Id =: jobApplicationId];
        System.debug('jobAppProfileStatus>>'+jobAppProfileStatus);
        jobAppProfileStatus.KTDO1__Profile_Status__c = 'Document Rejected';
        update jobAppProfileStatus;
    }

    @AuraEnabled
    public static void cloaseDocumentUploadppup(String jobApplicationId) {
        System.debug('jobApplicationId>>'+jobApplicationId);
        KTDO1__Job_Application__c jobAppProfileStatus = [SELECT KTDO1__Profile_Status__c FROM KTDO1__Job_Application__c WHERE Id =: jobApplicationId];
        System.debug('jobAppProfileStatus>>'+jobAppProfileStatus);
        jobAppProfileStatus.KTDO1__Profile_Status__c = 'Manager Round Approved';
        update jobAppProfileStatus;
    }



    // Azure File Upload and File Download
    @AuraEnabled
    Public static string azureDocUpload(String attachmentId ,String uploadedDocId) {
        AzureFileUpload azureupload = new AzureFileUpload();
        KTDO1__Job_Posting_Document__c applicationDocument = [SELECT Id,KTDO1__Document_Master__c, 	KTDO1__Job_Application__c FROM KTDO1__Job_Posting_Document__c WHERE Id=:uploadedDocId LIMIT 1];
        System.debug(applicationDocument);
        
        String fileUploadName = applicationDocument.Id+'$'+applicationDocument.KTDO1__Document_Master__c+'$'+applicationDocument.KTDO1__Job_Application__c+'.jpg';
        System.debug(LoggingLevel.INFO, fileUploadName+'File Upload Name');
        String status = azureupload.fileUpload(attachmentId, uploadedDocId, fileUploadName);
        return status;
    }

    @AuraEnabled
    public static String azureFileDownload(String uploadedDocId)
    {   
        KTDO1__Job_Posting_Document__c updateAzureDocURL = [SELECT KTDO1__Azure_FileID__c  FROM KTDO1__Job_Posting_Document__c WHERE Id =: uploadedDocId];
        String azureFileId = updateAzureDocURL.KTDO1__Azure_FileID__c;
        AzureFileUpload azureDownload = new AzureFileUpload();
        System.debug(azureFileId);
        String link = azureDownload.downloadAzureFile(azureFileId);
        return link;
    }


}