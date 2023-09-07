global class batchContactschedule implements Database.Batchable<sObject> ,Schedulable ,Database.stateful{
    global set<id> FailedID=new set<id>();
    global set<id> SuccessID=new set<id>();
    global Integer totalSizeRecords=0;
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String Qry = 'SELECT Id,firstName,lastName,Greeting_send__c,Email FROM Contact WHERE Email != null';
        return Database.getQueryLocator(Qry);
    }
    
    // Execute method
    global void execute(Database.BatchableContext bc, List<Contact> conlistQry){
        List<Messaging.SingleEmailMessage> ListEmails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [SELECT Id, Subject, Body FROM EmailTemplate WHERE Name ='Greeting to contact'];
        for(Contact con : conlistQry)// store only emailaddress and Id
        {
            Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
            objEmail.setTemplateId(emailTemp.Id);
            objEmail.setSubject(emailTemp.Subject);
            objEmail.setHtmlBody(emailTemp.Body);
            objEmail.setTargetObjectId(con.Id);// store contact Id
            objEmail.setSaveAsActivity(false);
            objEmail.setUseSignature(false);
            ListEmails.add(objEmail);
            con.Greeting_send__c = true;
        }
        
        try{
            Messaging.SendEmailResult[] results = Messaging.sendEmail(ListEmails);
        }catch(Exception e){
            System.debug(e.getMessage());
        }
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
        List<User> userList = [SELECT Id, Name,Email, Profile.Name FROM User WHERE Profile.Name='System Administrator'];
        List<Messaging.SingleEmailMessage> lstEmailss = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage objEmails = new Messaging.SingleEmailMessage();
        objEmails.setTargetObjectId(userList[0].Id);
        objEmails.setToAddresses(new String[] {userList[1].Email});
        objEmails.setSubject('Monthly Update Report For Admin');
        String body = 'Total size of the succces ids = '+SuccessID.size()+', ';
        body += 'Total size of the Failed Ids ='+FailedID.size()+', '; 
        body += 'Total number of records processed ==> ' +totalSizeRecords;
        objEmails.setHtmlBody(body);
        objEmails.setSaveAsActivity(false);
        lstEmailss.add(objEmails);
        Messaging.sendEmail(lstEmailss);
    }
    global void execute(SchedulableContext SC) {
        batchContactschedule b = new batchContactschedule(); 
        database.executebatch(b);
    }
    
}