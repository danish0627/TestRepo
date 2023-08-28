public with sharing class AccountHandler {
    @AuraEnabled
    public static List <Account> fetchAccounts() {
        List<Account> accList = [SELECT Id, Name, BillingState, 
                                 Website, Phone, Industry,Active__c ,Type from Account WHERE Industry!=Null LIMIT 10];
        return accList;
    }
    
}