public with sharing class FileUploaderClass {
    //public static string id;
   

    public class wrapData{
        public String id;	//804b27bb2ab7692d4ee91f163ba90de7
        public Integer file_size;	//38894
        public Integer pages;	//1
        public Integer quota_used;	//22
        public Integer quota_left;	//8
        public String quota_refill;
    }

    @AuraEnabled
    public static String uploadFile(String base64, String filename) {
        system.debug(base64);
        system.debug(filename);
        //system.debug(recordId);
        //String
        //String strApiKey = '34dab4d8a1b6e601ac7323c50b2c5c09bceeb1bd';
        //String strParserId = 'dcwhsmqgzvjk';
        String strApiKey = '42c7129afedebf9cffe11f1eca79cc2964ed4166';
        String strParserId = 'qbfiyqseiwjj';
        String strTargetURL = 'https://api.docparser.com/v1/document/upload/' + strParserId;
        String strSeparationKey = 'A_RANDOM_STRING';
        
        // assemble the body payload
        String strHeader = '--' + strSeparationKey + '\nContent-Disposition: form-data; name="file"; filename="' + filename + '"\nContent-Type: application/octet-stream\n\n';
        String strBody = base64;
        String strFooter = '\n--' + strSeparationKey + '--';
        
        String strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
        while(strHeaderEncoded.endsWith('=')) {
            strHeader+=' ';
            strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
        }
        system.debug(strHeaderEncoded);
        String strBodyEncoded = strBody;
        system.debug(strBodyEncoded);
        String strFooterEncoded = EncodingUtil.base64Encode(Blob.valueOf(strFooter));
        system.debug(strFooterEncoded);
        Blob blobBody = null;
        String last4Bytes = strBodyEncoded.substring(strBodyEncoded.length()-4,strBodyEncoded.length());
        
        if(last4Bytes.endsWith('=')) {
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest objHttpRequest = New HttpRequest();
            objHttpRequest.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = objHttpRequest.getBody()+strFooter;
            blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded.substring(0,strBodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        } else {
            blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded+strFooterEncoded);
        }
        system.debug(blobBody);
        if(blobBody.size()>3000000) {
            // throw new CustomException('File size limit is 3 MBytes');
            system.debug('File size limit is 3 MBytes');
        }else{
            system.debug('blobBody.size()'+blobBody.size());
        }
        
        // send out the request
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + strSeparationKey);
        req.setHeader('Authorization', 'Basic ' + strApiKey);
        req.setMethod('POST');
        req.setEndpoint(strTargetURL);
        req.setBodyAsBlob(blobBody);
        //req.setHeader('Content-Length', String.valueof(req.getBodyAsBlob().size()));
        Http http = New Http();
        HTTPResponse res = http.send(req);
        string responce=res.getBody();
        system.debug(res);
       system.debug('responce data'+res.getBody());
       wrapData resId = (wrapData) System.JSON.deserialize(responce, wrapData.class);
       system.debug('resId'+resId);
        system.debug('resId'+resId.id);
        //system.debug('deserializedRes'+ system.json.deserialize(responce,FileUploaderClass.class));
        
        //FileUploaderClass.getCandidateId(resId.id);

       return String.valueOf(resId.id);

    }


    /*@AuraEnabled
    public static void parsedFile(FileUploaderClass resId){
        // change the following variables according to your use-case
        system.debug('resId>>'+resId);
        String strApiKey = '34dab4d8a1b6e601ac7323c50b2c5c09bceeb1bd';
        String strParserId = 'dcwhsmqgzvjk';
        String strTargetURL = 'https://api.docparser.com/v1/results/' + strParserId + '/'+ resId.id;
        
        // send out the request
        HttpRequest req = New HttpRequest();
        req.setHeader('Authorization', 'Basic ' + strApiKey);
        req.setMethod('GET');
        req.setEndpoint(strTargetURL);
        Http http = New Http();
        HTTPResponse res = http.send(req);
        string responce=res.getBody();
        //system.json.deserialize(responce,FileUploaderClass.class);
        //system.debug('res'+list);
        system.debug('res'+res.getBody());
    }*/
   /* @AuraEnabled
    public static void parsedFile1(String base64, String filename, String recordId){
      system.debug(base64);
      system.debug(filename);
      system.debug(recordId);
        String strApiKey = '34dab4d8a1b6e601ac7323c50b2c5c09bceeb1bd';
        String strParserId = 'dcwhsmqgzvjk';
        String strTargetURL = 'https://api.docparser.com/v1/document/upload/' + strParserId;
        String strSeparationKey = 'A_RANDOM_STRING';
        
        // assemble the body payload
        String strHeader = '--' + strSeparationKey + '\nContent-Disposition: form-data; name="file"; filename="' + filename + '"\nContent-Type: application/octet-stream\n\n';
        String strBody = base64;
        String strFooter = '\n--' + strSeparationKey + '--';
        
        String strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
        while(strHeaderEncoded.endsWith('=')) {
            strHeader+=' ';
            strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
        }
        system.debug(strHeaderEncoded);
        String strBodyEncoded = EncodingUtil.base64Encode(Blob.valueOf(strBody));
        system.debug(strBodyEncoded);
        String strFooterEncoded = EncodingUtil.base64Encode(Blob.valueOf(strFooter));
        system.debug(strFooterEncoded);
        
        Blob blobBody = null;
        String last4Bytes = strBodyEncoded.substring(strBodyEncoded.length()-4,strBodyEncoded.length());
        
        if(last4Bytes.endsWith('=')) {
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest objHttpRequest = New HttpRequest();
            objHttpRequest.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = objHttpRequest.getBody()+strFooter;
            blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded.substring(0,strBodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        } else {
            blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded+strFooterEncoded);
        }
        system.debug(blobBody);
        
        if(blobBody.size()>3000000) {
            // throw new CustomException('File size limit is 3 MBytes');
            system.debug('File size limit is 3 MBytes');
        }else{
            system.debug('blobBody.size()'+blobBody.size());
        }
        
        // send out the request
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + strSeparationKey);
        req.setHeader('Authorization', 'Basic ' + strApiKey);
        req.setMethod('POST');
        req.setEndpoint(strTargetURL);
        req.setBodyAsBlob(blobBody);
        req.setHeader('Content-Length', String.valueof(req.getBodyAsBlob().size()));
        Http http = New Http();
        HTTPResponse res = http.send(req);
        system.debug(res);
        string responce=res.getBody();
        //system.json.deserialize(responce,FileUploaderClass.class);
       // system.debug(json.deserialize(responce,FileUploaderClass.class));
        system.debug('res'+id);
        system.debug('responce data'+res.getBody());
        if(res!=null){
            //Parsedfile(Id);
        }
        
        
    
    }*/

@AuraEnabled(cacheable=true)
public static String getCandidateId(String result){
    system.debug('result>>>'+result);
    Candidate_Profile__c candId = [Select Id from Candidate_Profile__c where Document_Id__c =:result];
    system.debug('candId>>>'+candId);

    return candId.Id;
}
    

}