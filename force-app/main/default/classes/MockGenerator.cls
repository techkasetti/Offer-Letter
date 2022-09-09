@isTest
global class MockGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        //System.assertEquals('https://www.googleapis.com/drive/v3/files', req.getEndpoint());
       // System.assertEquals('POST', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
         res.setBody('{"id":"a088Z000013B4OrQAK"}');
        res.setStatus('Failure');
        res.setStatusCode(200);
        return res;
        
           //res.setHeader('Content-Type', 'application/json');
        // res.setHeader('Content-length', '5');
         //res.setHeader('Authorization', 'Basic YXBmFtaWx5');
         //res.setBody('{"getCurrentToken":"sdgsdakhgkhadgkhkya","Username":"testuser@test.com", "owner":"testowner@test.com", "uniqueid":"123456789", "email":"testemail@test.com"}');
        
        
       // res.setBodyAsBlob(blob.valueOf(FAKE_RESPONSE));

        // HttpResponse res = new HttpResponse();
        // res.setHeader('Content-Type', 'application/json');
        // res.setHeader('Content-length', '5');
        // res.setHeader('Authorization', 'Basic YXBmFtaWx5');
        // res.setBody('{"getCurrentToken":"sdgsdakhgkhadgkhkya","Username":"testuser@test.com", "owner":"testowner@test.com", "uniqueid":"123456789", "email":"testemail@test.com"}');
        // res.setStatusCode(200);
        // return res;
    }
}