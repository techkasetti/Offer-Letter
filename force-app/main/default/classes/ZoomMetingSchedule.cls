public class ZoomMetingSchedule {

    @AuraEnabled
    public static String scheduleMeeting(String timeDate,String hostEmail,String candEmail){

        system.debug('timeDate>>>>'+timeDate);
        system.debug('hostEmail>>>'+hostEmail);
        system.debug('candEmail>>>>'+candEmail);
        
        String endpointURL = 'callout:Zoom_Offer_letter'; // Named Credential
        HttpRequest request = new HttpRequest(); 
        request.setMethod('POST');
        request.setEndpoint('callout:Zoom_Offer_letter/');
        request.setHeader('Content-type', 'application/json');    
        request.setBody(jsonGenerator(timeDate));
        System.debug('jsonGenerator(timeDate)>>'+jsonGenerator(timeDate));
        Http http = new Http();
      	HTTPResponse res = http.send(request);
        System.debug('Request Sent');
        system.debug('Body'+res.getBody());
        System.debug('response1 ==>>'+res.getHeaderKeys());
        System.debug('response1 ==>>'+res.getStatus());
        System.debug('response1 ==>>'+res.getStatusCode());
        JSONParser parser = JSON.createParser(res.getBody());
        JSONParser parser1 = JSON.createParser(res.getBody());
        String hostURL='';
        String join_url='';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'start_url')) {
                    // Get the value.
                    parser.nextToken();
                    
                    // Compute the grand total price for all invoices.
                    hostURL += parser.getText();
                }
        }
        while (parser1.nextToken() != null) {
            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser1.getText() == 'join_url')) {
                    // Get the value.
                    parser1.nextToken();
                    
                    // Compute the grand total price for all invoices.
                    join_url += parser1.getText();
                }
        }
        system.debug('hostURL>>>>'+hostURL);
        system.debug('join_url>>>'+join_url);

        //SEND MAIL TO ADDRESS STARTS
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
        toAddresses.add(hostEmail);
        toAddresses.add(candEmail);
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Zoom Meeting');
        mail.setSubject('Zoom Meeting Shedule');
        mail.setPlainTextBody('Hello,\n\n Join the meeting ahead of schedule using a laptop/desktop and reliable internet connection using this link : \n'+hostURL+'\n\n Kindly acknowledge this mail by your acceptance  \n\n Warm Regards \n Admin');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        //SEND MAIL TO ADDRESS ENDS

        return 'response';
        
    }
    
    public static string jsonGenerator(String timeDate){
        System.debug('timeDate>>'+timeDate);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('agenda','Meeting Agenda Introduction');
        gen.writeObjectField('default_password','false');
        gen.writeObjectField('duration','60');
        gen.writeObjectField('password','123456');
       
        // gen.writeObjectField('schedule_for','sdkulkarni15@gmail.com'); //  
        gen.writeFieldName('settings');
        gen.writeStartObject();
        gen.writeObjectField('host_video',false);
        gen.writeObjectField('allow_multiple_devices',false);
        gen.writeObjectField('participant_video',false);
        gen.writeObjectField('join_before_host',false);
        gen.writeObjectField('mute_upon_entry',true);
        gen.writeObjectField('use_pmi',false);
        gen.writeObjectField('approval_type',0);
        gen.writeEndObject();
        gen.writeObjectField('start_time','2022-06-01T18:30:00Z'); // '2022-06-01T18:30:00Z'= 2022-07-06T13:30:00.000Z
        
        gen.writeObjectField('timezone','Asia/Calcutta'); // Time Zone
        gen.writeObjectField('topic','Intrview with Sony');
        gen.writeObjectField('type','2');
        gen.writeEndObject();
        string payload=gen.getAsString();
        System.debug('payload body'+payload);
        return payload;
    }

    @AuraEnabled
    public static String getCandEmail(String candidateID) {
        system.debug('candidateID>>>'+candidateID);
        Candidate_Profile__c email = [Select Email__c from Candidate_Profile__c  where Id=:candidateID];
        system.debug('email.Email__c>>>'+email.Email__c);
        return email.Email__c;
    }

    @AuraEnabled
    public static String getHostEmail(String hostID) {
        system.debug('hostID>>>'+hostID);
        Contact email = [Select Email from Contact where Id=: hostID];
        system.debug('email>>>'+email.Email);
        return email.Email;
    }

}