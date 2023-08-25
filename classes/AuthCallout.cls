public class AuthCallout {
    
    /** 
     * Created By :Mohd Rafiq 
     * Perpose : POC (Integrate intent API with salesforce using HTTP insted of CURL).
     * Date : 20-March-2023
     * 
    */
    @AuraEnabled(cacheable=true)
    public static String basicAuthCallout(String sender){
        String apiKey='J5FVISSZJVIFANJTJFKFOVSWJVDDMRKXIRKUSM2MGMZEYRRVJVEUGV2SINMUYRZSLFCVMU22G5BDEMSHJ5IFCNSMJ4ZVKVKOINGUCRKOJA2FCMS2I5GFMSKKJVBE6UCUIVNECMSVLJGVCVBSKI3VEU2LJJCFKN2OKMZVS7COIE';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.einstein.ai/v2/language/intent');
        request.setHeader('Content-Type', HttpFormBuilder.GetContentType());
        request.setHeader('Authorization','Bearer '+ apiKey);
        request.setMethod('POST');

        // Generate form body
        // If we using Content-Type', ContentType); then we have to create this 
        String body = '';
        body += HttpFormBuilder.WriteBoundary();
        body += HttpFormBuilder.WriteBodyParameter('modelId', 'ZXDBNOMPEWCUAQGTPNR533O4DI');
        body += HttpFormBuilder.WriteBoundary();
        body += HttpFormBuilder.WriteBodyParameter('document', sender);
        body += HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);
    
        Blob formBlob = EncodingUtil.base64Decode(body);

        request.setHeader('Content-Length', String.valueOf(formBlob.size()));
        request.setBodyAsBlob(formBlob);
        System.debug('response>>>'+request);

        HttpResponse res = http.send(request);
        System.debug('response>>>'+res.getBody());
        return res.getBody();
    }

    //To create the records for the chat (request= params , Responc = paramResp)
    @AuraEnabled
    public static Chat_Record__c createRecord(String params, String paramResp, Boolean RecordTypeValue) {
        try {
            Chat_Record__c req = new Chat_Record__c(Message__c = params, Type__c = true,record_type__c= false);
            Chat_Record__c res = new Chat_Record__c(Message__c = paramResp, Type__c = false,record_type__c= RecordTypeValue);
            List<Chat_Record__c> records = new List<Chat_Record__c>{req, res};
            insert records;
            return res;
        } catch (Exception e) {
            System.debug('Error occurred: ' + e.getMessage());
            return null;
        }
    }
    

    //to get the user id and their related chat history
    @AuraEnabled
    public static List<Chat_Record__c> chatHistory(String userId){
        list <Chat_Record__c> chatId = [SELECT Id,record_type__c, OwnerId, Name, CreatedDate, CreatedById,Type__c, Message__c FROM Chat_Record__c WHERE OwnerId =:userId ORDER BY Name ASC] ;
        return chatId;
    }


    /**
     * for rasa bot 
     **/

    // private static final String RASA_SERVER_URL = 'https://dedup.girikon.com/webhooks/rest/webhook';
    // //  private static final String MODEL_NAME = 'my_model';
    // //  private static final String PROJECT_NAME = 'my_project';
    

    @AuraEnabled
    public static String getRasaResponse(String message) {

        // create apex class curl --location 'http://0.0.0.0:5005/webhooks/sms/webhook' \
        // --header 'Content-Type: application/json' \
        // --header 'Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjU3NmMyNzdjLThkOWEtNDRiMi1hYTAxLTU0NjcwYzAzY2RiOSIsIm9yZ19pZCI6IjAwRDVqMDAwMDAxOEpVdEVBTSIsIm1ldGFkYXRhIjoiZ0FBQUFBQmtnekpOaDRmSkVFcVJDZzJWNWZNN2hnNGdxR1B6cFNKNU5VYkxMb3Y3RWk3N2J2LXpKSF9COVo0RFdYWHJuSWdLTGV0a1VXQ1lRamIycDk2dlkzeVJnTlh1ZXlKX0Q5elRXbi1kRXh2bV8tN0FxY0I5YS1SeWxmcksyZXhQV0paaVZxaFJSOWllSWxScGNicVRtZnA1dG92UU42TFZrXy1GWEJwemlwSXVkdU5YdXdoWlMwLV9SeHdUUEszRW1CRDZpWDRyR0ZtM3g5cGNUVFNBeFpYTzZRWFZpS3U2a2lXMWxZcjMzMWpuNDlfcF9RZVdvM0dCTE5sZ2l1MkJacDRyRWt2Zi0tNDRKMkZwOU5nMWUzanBsMGtBTDRhV3lZTWpUZkVTeWZtZnBtZVJQbmxTdVNjVzV4WE1XX1dTeTJQOFpIeFRvOU1LVjNBOHdaV0dYU0dKX2Z4UnhOclZzbi1CWXpob3Zaamx3MXNUTkRrN1Bra1JWeTh4NlczZE1vaXdYcFdNa2lmZW1JdFhHYVZmRVQ1NnRSWmxSaHpIT081TnNuT3M0cVFfdEI0NGxPUTVjSGFvMzM2QlV0eG5odUFZQkpIYVhzbTNTaTBsWDBhNjJZZW9nb1U0cTdGN2ZmV1R3Z2dvcDFqNnFfaHQ5S3pLOWVUTEh6OC0ySUpxaWRPMTJMOXEifQ.adi99FH9wcFEo26-bhj9eZbpuPl0Yz5ws6KHhYTLcqhLBRaK8kt2XJY05mQTe5n5xTYCtIqx9u6Z05hqzHb1xg' \
        // --data '{
        //     "message":"show me my New case records",
        //     "sender":"ss"
        // }'
        String xyx ='';
        try {
            HttpRequest request = new HttpRequest();
            System.debug(request);
            request.setEndpoint('https://e471-210-16-82-208.ngrok-free.app/webhooks/sms/webhook');
            request.setMethod('POST');
            system.debug('@@@req'+request);
            request.setHeader('Content-Type', 'application/json');
            System.debug(request);
            request.setHeader('Authorization', 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjU3NmMyNzdjLThkOWEtNDRiMi1hYTAxLTU0NjcwYzAzY2RiOSIsIm9yZ19pZCI6IjAwRDVqMDAwMDAxOEpVdEVBTSIsIm1ldGFkYXRhIjoiZ0FBQUFBQmt6TXJaSzRrTElmdHFpODJVX3I4NWRUdlA4WExoME9oZTExTHF5OF9JOGxRbzh5aGNHV2tMY0VSYXFRRzVGeTJFQjRyUEVsbUJEVjNlekNIX080X216OUJDNjllOVhORThGQURONldzZ0JEeGRISTlrRHpCU1k5ZmVwaVVkOVRrTDlYTHdYWkJsRUhqbl85Q3N0bFQxOWhKSnptNVYwODhFb2dGYkJFSU5lZG0wY0dLc3pYYjBlSlR6QXgtZ1lhbjc5MFQ3Q2RqNEFFX2dqQno3dVNGSU1pelNaNGxKbzA4blR6SHVubVc0WkdtLXgwQVl2bEE1dUdTamJRNHpVWmtkTU4yX1JDREhsYXA3czNFazg3aS1lUWZkTTJGcnk3X0wyRHNySjJEeGlsY0syclhmcHpmY0ZWVG5jeEZKQUNOdzcyTDJOWTM4YW9DODcxSFFQdmYxQTVna29PSFoxQUl4Mk5TMTdhZHdFcnNsa212NWJibVpkaG0ySVJIb3NCOVo4bEllUEJDRVdlMHBWWHEzNmhJelN3UFY1M1VWREVGak1zMnpmZTN0ZmMxY0hjVXhjRlBKMC1PR0pZYVptZ2lRYVE5dVBKOXN0ajVtNFZLS19aZkNxaTRHYi1xM0RSdzAtYTRXNkFoVkRnajFDN3ZpZDJIQXlRSkxHSHAzNFNxU0lEVG0iLCJleHAiOjE2OTM3MzQ4NzN9.pTbFcehKQ36m-_tRYTQ6nH2dKLtViEhu8dW31UqaGFDJ3rt9qwUJuwoWy8_axOgdn0yMsVrQu5QEDuahcOBhXA');
            
            String requestBody = '{ "message": "' + message + '" }';
            
            request.setBody(requestBody);
            // request.setBody('{"message":"show me my New case records", "sender":"ss"}');

            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug(response);

            // Process the response as needed
            String responseBody = response.getBody();
            System.debug(responseBody);
            return responseBody;
        } catch (Exception e) {
            System.debug('Callout error: '+ e);
            System.debug('Callout error: '+ e.getMessage());
            return e.getMessage();

        }
    }

    @AuraEnabled 
    public static String getOrgType(){ 
        Organization org = [SELECT OrganizationType FROM Organization LIMIT 1]; 
        String orgType = org.OrganizationType; 
        System.debug('Organization Type: ' + orgType); 
        return orgType; 
    }

    @AuraEnabled
    public static String getAccessToken() {
        appConfig__c setting = appConfig__c.getInstance();
        
        if (setting != null) {
            System.debug(setting.access_token__c);
            return setting.access_token__c;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static void uploadFile() {
        String endpoint = 'https://dedup.girikon.com/ssa_access/upload_files';
        String accessToken = 'eyJhbGciOiJIUzUxMiJ9.M3wwMEQ3RjAwMDAwNW9acUlVQVV8MDA1N0YwMDAwMDNHenhxUUFD.cX1UisOxtxX1JK9i4mv_CHQ5oHRmz8SMnPZ-aL-CLUdKG2F1AjvRp8w3ZumfY_fXfOjgrOEWt6sXrhCfutXJpg';
        String filePath = '/D:/project/ai/callback/uploads/min.xlsx';

        // Read file content
        Blob fileBlob = Blob.valueOf(filePath);
        String fileName = 'min.xlsx';

        // Create HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW');

        // Construct the multipart/form-data body
        String boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW';
        String header = '--' + boundary + '\r\n' +
                        'Content-Disposition: form-data; name="files"; filename="' + fileName + '"\r\n' +
                        'Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\r\n' +
                        'Content-Transfer-Encoding: binary\r\n\r\n';
        String footer = '\r\n--' + boundary + '--\r\n';
        String body = EncodingUtil.base64Encode(fileBlob);

        String bodyString = header + body + footer;
        req.setBodyAsBlob(EncodingUtil.base64Decode(bodyString));

        // Send the request
        Http http = new Http();
        HttpResponse res = http.send(req);

        // Handle the response
        if (res.getStatusCode() == 200) {
            // Successful upload
            System.debug('File uploaded successfully.');
        } else {
            // Handle error
            System.debug('File upload failed. Response: ' + res.getBody());
        }
    }

}