public with sharing class AzureFileUpload { 

    //modified on 08 June 2022 Akhilesh
    String azureStorageName; 
    String azureContainer;
    String azureURL;
    String azureStorageKey;
    String storageUrl;
    public AzureFileUpload() {
        List<Azure_File_Upload__mdt> azureFileUpload = Azure_File_Upload__mdt.getAll().values();
        system.debug('azureFileUpload>>'+azureFileUpload);
        Map<String, String> azureDetails = new Map<String, String>(); 
        for (Azure_File_Upload__mdt variable : azureFileUpload) {
            azureDetails.put(variable.MasterLabel,variable.Value__c);
        }
        azureStorageName = 'sfdxstorage'; 
        azureStorageName = azureDetails.get('Azure Storage Name'); //it will be the storage name in the portal. Storage name will be something like this       
        // azureContainer = 'offerletterfilecontainer';
        System.debug(azureStorageName);
        azureContainer = azureDetails.get('Azure Storage Container');
        //it will be directory name where you need to upload the files
        // azureStorageKey = 'Mx6jfc/vzV7byKVAQIWtFEfjEtDIC4qI0JTF/rHEQkTBVrQF8a4bvwTEAVszKjNOkg9IocW0LFce+ASteq3y2w==';
        System.debug(azureContainer);
        azureStorageKey = azureDetails.get('Azure Storage Key');
        System.debug(azureStorageKey);
        // azureURL = '.blob.core.windows.net/';	//it will be URL of the azure
        // storageUrl ='https://sfdxstorage.blob.core.windows.net'; // replaced with namedcrediential
    }
    public String fileUpload(String attachmentId ,String uploadedDocId, String fplink, String fileUploadName){
        system.debug('attachmentId>>'+attachmentId);
        system.debug('uploadedDocId>>'+uploadedDocId);
        
        List<ContentVersion> cvFile = [SELECT Title,VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        system.debug('cvFile>>>'+cvFile);

        String strGMTDate = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        // String azureFileId = EncodingUtil.urlEncode(cvFile[0].Title, 'UTF-8'); //To retain original file name

        String finalPath = (fplink+fileUploadName+'.'+(cvFile[0].FileType).toLowercase());
        String azureFileId = EncodingUtil.urlEncode(finalPath, 'UTF-8');
        system.debug('azureFileId>>>'+azureFileId);

        Blob bodyAsBlob = cvFile[0].VersionData;
        system.debug('bodyAsBlob>>>'+bodyAsBlob);

        Integer fileLength1 = bodyAsBlob.size();
        system.debug('fileLength1>>>'+fileLength1);

        String fileLength = String.valueof(fileLength1);
        system.debug('fileLength>>>'+fileLength);
        String cvFileType = cvFile[0].FileType;
        String fileType = 'image/'+cvFile[0].FileType;
        String canonicalHeader = 'x-ms-blob-type:BlockBlob\nx-ms-date:'+strGMTDate+'\nx-ms-version:2015-12-11\n';
        String canonRes = '/' + azureStorageName + '/' + azureContainer + '/' + azureFileId;
        String stringToSign = 'PUT\n\n\n'+fileLength+'\n\n'+fileType+'\n\n\n\n\n\n\n'+canonicalHeader+canonRes;
        String accountSharedKey = azureStorageKey; // replace with your accounts shared key
        Blob decodedAccountSharedKey = EncodingUtil.base64Decode(accountSharedKey);
        String authToken = EncodingUtil.base64Encode(crypto.generateMac('HmacSHA256',Blob.valueOf(stringToSign), decodedAccountSharedKey));
        String authHeader = 'SharedKey ' + azureStorageName + ':' + authToken;
       	// request.setEndpoint('callout:MyAzure/');
        //  String strEndpoint = 'https://' + azureStorageName	+ azureURL + azureContainer + '/' + azureFileId;
        String strEndpoint = 'callout:MyAzure' + '/'+ azureContainer + '/' + azureFileId;
        //System.debug(strEndpoint);
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


        // if(res.getStatus() == 'Created'){
           
        //     return finalPath;
        // }
        // else {
        //     return 'Failure';
        // }
        
            return 'Failure';
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
    String canonicalizedresource = '/blob/sfdxstorage/offerletterfilecontainer/'+azureFileId;
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

    NamedCredential sourceDomain = [SELECT Endpoint FROM NamedCredential Where DeveloperName='MyAzure' LIMIT 1];
    System.debug(LoggingLevel.INFO,sourceDomain);
    string sasURL = sourceDomain.Endpoint +'/'+ this.azureContainer+'/'+azureFileId+sasTokenString;
    System.debug('sasURL--->'+sasURL);
    System.debug(sasTokenString);
    return sasURL;
    }

    public String downloadAzureFileAWS(String azureFileId){

    Datetime sasExpiry = Datetime.now();
    sasExpiry = sasExpiry.addMinutes(15);
    Datetime sasStart = Datetime.now();
    sasStart = sasStart.addMinutes(-5);


    string signedpermissions = 'r';
    String signedstart = sasStart.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
    string signedexpiry = sasExpiry.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
    string signedservice = 'b';
    String canonicalizedresource = '/blob/sfdxstorage/offerletterfilecontainer/'+azureFileId;
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

    NamedCredential sourceDomain = [SELECT Endpoint FROM NamedCredential Where DeveloperName='MyAzure' LIMIT 1];
    System.debug(LoggingLevel.INFO,sourceDomain);
    string sasURL = sourceDomain.Endpoint +'/'+ this.azureContainer+'/'+azureFileId+sasTokenString;
    System.debug('sasURL--->'+sasURL);
    System.debug(sasTokenString);
    return sasURL;
    }

    public Boolean fileDel(String fplink, String fileUploadName){
        System.debug(LoggingLevel.INFO, fplink);
        System.debug(LoggingLevel.INFO, fileUploadName);
        return true;

    }

     public String fileUrlUploadForAWS(String fileURL){
        System.debug(fileURL);

       // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest reqFile = new HttpRequest();
        reqFile.setEndpoint(fileURL);
        reqFile.setTimeout(60000);//sets maximum timeout
        reqFile.setMethod('GET');
        
        // Send the request, and return a response
        HttpResponse resFile = h.send(reqFile);
        System.debug(resFile.getHeaderKeys());
        for (String variable : resFile.getHeaderKeys()) {
            System.debug(resFile.getHeader(variable));
        }

        Blob bodyAsBlob = resFile.getBodyAsBlob();
        system.debug('body   >>>>'+bodyAsBlob);
        // String base64 = EncodingUtil.base64Encode(bodyAsBlob);
        // System.debug(bodyAsBlob.toString());
        
        System.debug(LoggingLevel.DEBUG, bodyAsBlob);
        System.debug(bodyAsBlob.size());
        // String strGMTDate = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
       

        
        String strGMTDate = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        // String azureFileId = EncodingUtil.urlEncode(cvFile[0].Title, 'UTF-8'); //To retain original file name
        String finalPath = ('filefromAWS'+'.pdf');
        String azureFileId = EncodingUtil.urlEncode(finalPath, 'UTF-8');
        system.debug('azureFileId>>>'+azureFileId);
        system.debug('bodyAsBlob>>>'+bodyAsBlob);
        Integer fileLength1 = bodyAsBlob.size();
        system.debug('fileLength1>>>'+fileLength1);

        String fileLength = String.valueof(fileLength1);
        system.debug('fileLength>>>'+fileLength);
        String cvFileType = 'pdf';
        String fileType = 'application/pdf';
        String canonicalHeader = 'x-ms-blob-type:BlockBlob\nx-ms-date:'+strGMTDate+'\nx-ms-version:2015-12-11\n';
        String canonRes = '/' + azureStorageName + '/' + azureContainer + '/' + azureFileId;
        String stringToSign = 'PUT\n\n\n'+fileLength+'\n\n'+fileType+'\n\n\n\n\n\n\n'+canonicalHeader+canonRes;
        String accountSharedKey = azureStorageKey; // replace with your accounts shared key
        Blob decodedAccountSharedKey = EncodingUtil.base64Decode(accountSharedKey);
        String authToken = EncodingUtil.base64Encode(crypto.generateMac('HmacSHA256',Blob.valueOf(stringToSign), decodedAccountSharedKey));
        String authHeader = 'SharedKey ' + azureStorageName + ':' + authToken;
       	// request.setEndpoint('callout:MyAzure/');
        //  String strEndpoint = 'https://' + azureStorageName	+ azureURL + azureContainer + '/' + azureFileId;
        String strEndpoint = 'callout:MyAzure' + '/'+ azureContainer + '/' + azureFileId;
        //System.debug(strEndpoint);
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
           
            return finalPath;
        }
        else {
            return 'Failure';
        }

     }


}