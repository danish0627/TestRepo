global class abc {
    
    global static List<Account> rollUpSummary(list <contact> conList){
        Set<Id> accIds = new Set<Id>();
        for(Contact con:conList){
            accIds.add(con.AccountId);
        }
        
        list <Account> accOfRelatedContacts = [SELECT id,Total_Amount__c,(SELECT id,Amount__c FROM Contacts) 
                                               FROM Account 
                                               WHERE Id IN:accIds];
        return accOfRelatedContacts;
    }

    // Test Comment
}
