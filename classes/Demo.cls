public class Demo {
    /*public static void updateOppDescription(){
list <Account> acclist = [SELECT id,name,total_contacts__c,(SELECT id,lastName from contacts) from Account WHERE CreatedDate = last_year];
if(!acclist.isEmpty()){
for(Account acc:acclist){
acc.total_contacts__c = acc.contacts.size();
}
}
if(!acclist.isEmpty()){
update acclist;
}
}*/
    
    
    /* public static void phoneUpdateOfContact(){
list <contact> conlist = [SELECT id,firstName,lastName,phone,Account.id,account.phone ,Account.name 
FROM contact 
WHERE createdDate = last_year 
AND phone= null 
AND account.phone !=null];
if(!conlist.isEmpty()){
for(contact con:conlist){
con.Phone = con.account.phone;
}
}
if(conlist.size()>0){
update conlist;
}
}*/
    
    public static void updatePhoneOnContact()
    {
        list <Account> acclist = [SELECT id,name,phone
                                  from Account 
                                  WHERE CreatedDate = last_year 
                                  AND phone!= null];
        map <id,Account> accIdToAccountMap = new map<id,Account>(acclist);
        
        list <contact> conlist = [SELECT id,phone,AccountID 
                                  from contact
                                  WHERE ID IN:accIdToAccountMap.keyset()];     
        list <contact> conlistToUdpate = new list<contact>();
        if(!conlist.isEmpty()){
            for(contact con:conlist){
                if(accIdToAccountMap.containsKey(con.Id)){
                    contact conrec = new contact();
                    conrec.Phone = accIdToAccountMap.get(con.AccountId).phone;
                    conrec.Id = con.Id;
					conlistToUdpate.add(conrec);
                }
            }
        }
        
        
        
        
        if(conlistToUdpate.size()>0){
            update conlistToUdpate;
        }
    }
}