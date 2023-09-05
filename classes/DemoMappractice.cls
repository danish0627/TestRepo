global class DemoMappractice implements Database.Batchable<sObject> ,Database.Stateful {
    global set<id> FailedID=new set<id>();
    global set<id> SuccessID=new set<id>();
    global Integer totalSizeRecords=0;

    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String Qry = 'SELECT Id,firstName,lastName,Email FROM Contact WHERE Email != null LIMIT 5';
        return Database.getQueryLocator(Qry);
    }
    
    // Execute method
   global void execute(Database.BatchableContext bc, List<Contact> conlistQry){
        List<Messaging.SingleEmailMessage> msgEmail = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [SELECT Id, Subject, Body FROM EmailTemplate WHERE Name ='Greeting to contact'];
        for(contact con:conlistQry){
            Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
            list <String> toAddresses = new List <String>();
            toAddresses.add(con.Email);
            system.debug('toAddresses@@@'+toAddresses);
            //ēēobjEmail.setToAddresses(toAddresses);// store email addresses
            objEmail.setTargetObjectId(con.Id);// store contact Id
            objEmail.setTemplateId(emailTemp.Id);
            objEmail.setSubject(emailTemp.Subject);
            objEmail.setHtmlBody(emailTemp.Body);
            system.debug('con@@@'+con);
            objEmail.setSaveAsActivity(false);
            objEmail.setUseSignature(false);
            msgEmail.add(objEmail);
            Messaging.sendEmail(msgEmail);
        }

        //Messaging.SendEmailResult[] results = Messaging.sendEmail(msgEmail,false);
        //system.debug('@@@@ results'+results);
        
        totalSizeRecords+=conlistQry.size();
        
        database.SaveResult[] myResult=database.update(conlistQry,false);
        for(Integer i=0; i < myResult.size(); i++) {
            if(myResult.get(i).isSuccess()) {
                SuccessID.add(myResult.get(i).Id);
            }else if(!myResult.get(i).isSuccess()) {
                Database.Error errors =  myResult.get(i).getErrors().get(0);
                FailedID.add(myResult.get(i).Id);
            }
        }
    }
    
    //finish Method  
    global void finish(Database.BatchableContext bc){
        
    }
}