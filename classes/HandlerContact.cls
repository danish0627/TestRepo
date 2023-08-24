public class HandlerContact {
    /*public static void AccRelatedContactCount(list <contact> conlist){
map<id,list<Account>> AccMap = new map<id,list<Account>>();
list <Account> AccInsert = new list <Account>();
for(Account a:AccInsert){
list<Account> tempAcc= new list<Account>();

//Account a = new Account();
//integer z = Accmap.get(a.id).size();
}
/*list <Account> acclist = [Select Id, Name,Total_Contacts__c,
(select id,lastName from contacts)
from Account
Where id IN:acc];

for(Account acc1:acclist){
list <Account> TempAcc = new list <Account>(); 
if(AccMap.ContainsKey(acc1.id)){
TempAcc = AccMap.get(acc1.Id);
}
tempAcc.add(aac1);
AccMap.put(id,tempAcc);
} */       
    //When a new contact is created for existing account then set contact other phone as account phone
    
    public static void UpdatephoneOnAccount(list <contact> newlist){
        set <Id> accIdset = new set <Id>();
        
        for(Contact con:newlist){
            if(con.AccountId!= null){
                accIdset.add(con.AccountId);
            }
        }
        
        if(accIdset.size()>0){
            Map <id,Account> AccMap = new map<id,Account> ([SELECT id,phone from Account 
                                                           WHERE id IN:accIdset]);
            for(contact con:newlist){
                con.OtherPhone = AccMap.get(con.AccountId).phone;
            }
        }
    }
    
    
    
    
}