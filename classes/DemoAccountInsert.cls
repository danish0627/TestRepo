public class DemoAccountInsert {
    
    public static void insertAccount(String accountName, String accountType) {
        Account newAccount = new Account();
        newAccount.Name = accountName;
        newAccount.Type = accountType;
        insert newAccount;
    }
    
}