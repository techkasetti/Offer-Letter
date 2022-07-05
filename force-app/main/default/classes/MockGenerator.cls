@isTest
global class MockGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        //System.assertEquals('https://www.googleapis.com/oauth2/v4/token', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //res.setBodyAsBlob(blob.valueOf(FAKE_RESPONSE));
        res.setStatusCode(200);
        return res;

        // HttpResponse res = new HttpResponse();
        // res.setHeader('Content-Type', 'application/json');
        // res.setHeader('Content-length', '5');
        // res.setHeader('Authorization', 'Basic YXBmFtaWx5');
        // res.setBody('{"getCurrentToken":"sdgsdakhgkhadgkhkya","Username":"testuser@test.com", "owner":"testowner@test.com", "uniqueid":"123456789", "email":"testemail@test.com"}');
        // res.setStatusCode(200);
        // return res;
    }
}