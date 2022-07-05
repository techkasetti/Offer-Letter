public with sharing class AzureFileUpload {

    //modified on 08 June 2022 Akhilesh
    String azureStorageName; 
    String azureContainer;
    String azureURL;
    String azureStorageKey;
    String storageUrl;
    public AzureFileUpload() {
        azureStorageName = 'azurefileaccountsfdx'; //it will be the storage name in the portal. Storage name will be something like this
        azureContainer = 'offerletterfilecontainer';	//it will be directory name where you need to upload the files
        azureURL = '.blob.core.windows.net/';	//it will be URL of the azure
        azureStorageKey = 'S/sL/l8NEQxkxk5Wmy2+Tv/eZgS+sCQJDJY+xY59CBouNIQrpOG9OS++/sIGEPRDeMqg5LJAKxZy+AStSglo/w==';
        storageUrl ='https://azurefileaccountsfdx.blob.core.windows.net';
    }
    public String fileUpload(String attachmentId ,String uploadedDocId, String fileUploadName){
        system.debug('attachmentId>>'+attachmentId);
        system.debug('uploadedDocId>>'+uploadedDocId);
        
        List<ContentVersion> cvFile = [SELECT Title,VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        system.debug('cvFile>>>'+cvFile);

        String strGMTDate = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        // String azureFileId = EncodingUtil.urlEncode(cvFile[0].Title, 'UTF-8'); //To retain original file name
        String azureFileId = EncodingUtil.urlEncode(fileUploadName, 'UTF-8');
        system.debug('azureFileId>>>'+azureFileId);

        Blob bodyAsBlob = cvFile[0].VersionData;
        system.debug('bodyAsBlob>>>'+bodyAsBlob);

        Integer fileLength1 = bodyAsBlob.size();
        system.debug('fileLength1>>>'+fileLength1);

        String fileLength = String.valueof(fileLength1);
        system.debug('fileLength>>>'+fileLength);

        String fileType = 'image/jpg';
        String canonicalHeader = 'x-ms-blob-type:BlockBlob\nx-ms-date:'+strGMTDate+'\nx-ms-version:2015-12-11\n';
        String canonRes = '/' + azureStorageName + '/' + azureContainer + '/' + azureFileId;
        String stringToSign = 'PUT\n\n\n'+fileLength+'\n\n'+fileType+'\n\n\n\n\n\n\n'+canonicalHeader+canonRes;
        String accountSharedKey = azureStorageKey; // replace with your accounts shared key
        Blob decodedAccountSharedKey = EncodingUtil.base64Decode(accountSharedKey);
        String authToken = EncodingUtil.base64Encode(crypto.generateMac('HmacSHA256',Blob.valueOf(stringToSign), decodedAccountSharedKey));
        String authHeader = 'SharedKey ' + azureStorageName + ':' + authToken;
        String strEndpoint = 'https://' + azureStorageName	+ azureURL + azureContainer + '/' + azureFileId;

        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setHeader('x-ms-blob-type', 'BlockBlob');
        req.setHeader('x-ms-date', strGMTDate);
        req.setHeader('Authorization', authHeader);
        req.setHeader('x-ms-version', '2015-12-11');
        req.setHeader('Content-Length', fileLength);
        req.setHeader('Content-Type',fileType);
        System.debug(fileType);
        req.setEndpoint(strEndpoint);
        req.setBodyAsBlob(bodyAsBlob);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('res>>'+res.getStatus());


        if(res.getStatus() == 'Created'){
            Job_Posting_Document__c updateAzureDocURL = [SELECT Azure_Document_URL__c  FROM Job_Posting_Document__c WHERE Id =: uploadedDocId];
            updateAzureDocURL.Azure_FileID__c = fileUploadName;
            update updateAzureDocURL;
            return 'Success';
        }
        else {
            return 'Failure';
        }
    }

    public String downloadAzureFile(String azureFileId){

    Datetime sasExpiry = Datetime.now();
    sasExpiry = sasExpiry.addMinutes(15);
    Datetime sasStart = Datetime.now();
    sasStart = sasStart.addMinutes(-5);


    string signedpermissions = 'r';
    String signedstart = sasStart.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
    string signedexpiry = sasExpiry.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
    string signedservice = 'b';
    String canonicalizedresource = '/blob/azurefileaccountsfdx/offerletterfilecontainer/'+azureFileId;
    string signedidentifier = '';
    string signedIP = '';
    string signedProtocol = '';
    string signedversion = '2015-04-05';
    string rscc='';
    string rscd='';
    string rsce='';
    string rscl='';
    string rsct='';


    string stringToSign =signedpermissions + '\n' +  
        signedstart + '\n' +  
        signedexpiry + '\n' +  
        canonicalizedresource + '\n' +  
        signedidentifier + '\n' +  
        signedIP + '\n' +  
        signedProtocol + '\n' +  
        signedversion + '\n' +  
        rscc + '\n' +  
        rscd + '\n' +  
        rsce + '\n' +  
        rscl + '\n' +  
        rsct;
    System.debug('stringToSign--->'+stringToSign);
    string signedExpiryEncode = EncodingUtil.urlEncode(signedexpiry, 'UTF-8'); 
    string signedStartEncode = EncodingUtil.urlEncode(signedstart, 'UTF-8'); 
    String sasToken = '';
    Blob unicodeKey = EncodingUtil.base64Decode(azureStorageKey);
    Blob data = Crypto.generateMac('HMACSHA256', Blob.valueOf(stringToSign), unicodeKey);
    sasToken = EncodingUtil.base64Encode(data);
    sasToken = EncodingUtil.urlEncode(sasToken, 'UTF-8');        
    String sasTokenString= '?sv=' + signedversion + '&se=' + signedexpiry +'&st='+signedstart+'&sr='+signedservice+'&sp=' + signedpermissions + '&sig=' + sasToken;

    string sasURL = storageUrl+'/'+azureContainer+'/'+azureFileId+sasTokenString;
    System.debug('sasURL--->'+sasURL);
    System.debug(sasTokenString);
    return sasURL;
    }
}