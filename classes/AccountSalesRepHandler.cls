public class AccountSalesRepHandler {
/*
When we create the Account record, the Account Owner will be automatically added to Sales Rep field.
When we update the Account owner of the record, then also the Sales Rep will be automatically updated.
*/
    public static void AccSaleRep(list <Account> triggerNew){
        set <id> SetAccowner = new set<Id>();
        for (Account acc:triggerNew)
        {
            SetAccowner.add(acc.OwnerId);
        }
        Map<id,user> userMap = new Map<Id, user>([SELECT name from user where id IN:SetAccowner]);
        for(Account acc:triggerNew)
        {
            user usr=userMap.get(Acc.OwnerId);
            acc.Sales_Rep__c = usr.Name;
        }
    }
}