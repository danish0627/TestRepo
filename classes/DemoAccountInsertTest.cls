@isTest
public class DemoAccountInsertTest {

    @isTest
    static void testInsertAccount() {
        String accountName = 'Test Account';
        String accountType = 'Prospect';

        Test.startTest();
        DemoAccountInsert.insertAccount(accountName, accountType);
        Test.stopTest();

        Account insertedAccount = [SELECT Id, Name, Type FROM Account WHERE Name = :accountName AND Type = :accountType LIMIT 1];

        System.assertEquals(accountName, insertedAccount.Name);
        System.assertEquals(accountType, insertedAccount.Type);
    }
}