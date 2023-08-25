public class ContactSiblingHandler {
    
    public static void countSibling(list <contact> triggerNew)
    {
        set<Id> accountIDs = new set<Id>();
        for(contact c:triggerNew)
        {
            if(c.AccountId!= null)
            {
                accountIDs.add(c.AccountId);
            }
        }
        
        list<Account> getAccounts = [SELECT id,name,(SELECT id from contacts) from Account where ID in:accountIDs];
        Map <Id,Integer> accountContactMap = new Map<Id,Integer>();
        for(Account acc:getAccounts)
        {
            integer count;
            if(acc.contacts.size()>0)
            {
                count = acc.contacts.size()-1;
            }
            else if(acc.contacts.size()==0)
            {
                count =0;	
            }
            accountContactMap.put(acc.Id,count);
        }   
        list <contact> getContacts = [SELECT id,Sibling__c from contact where accountID IN :accountContactMap.keyset()];
        list <contact> toUpdate = new list<Contact>();
        
        for(contact c:getContacts)
        {
            c.Sibling__c = accountContactMap.get(c.AccountId);
        }
        update(toUpdate);
        
    }
}