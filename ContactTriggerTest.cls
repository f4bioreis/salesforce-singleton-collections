@IsTest
private class ContactTriggerTest {
    
    @TestSetup
    private static void setup() {
        List<Account> accts = new List<Account>();
        Account acc = new Account(Name = 'Test Account 1');
        accts.add(acc);

        acc = new Account(Name = 'Test Account 2');
        accts.add(acc);

        Database.insert(accts);
    }

    // This method ensures that the singleton collection in question (accountMap) only gets
    // defined once, which translates to the proper implementation of the Singleton Design Pattern
    @IsTest
    static void testSingletonCollectionsFetch(){
        Account testAcct = [SELECT Id FROM Account WHERE Name = 'Test Account 1'];

        Contact ct = new Contact();
        ct.FirstName = 'Test';
        ct.LastName = 'Contact';
        ct.AccountId = testAcct.Id;

        // This illustrates that the total amount of queries will be increased upon the first
        // "getAccountMap" call

        Integer numberOfQueriesSoFar = Limits.getQueries();
        Map<Id, Account> accountMap = ContactUtil.getAccountMap(new List<Contact>{ct});
        Integer updatedNumberOfQueries = Limits.getQueries();

        System.assertNotEquals(numberOfQueriesSoFar, updatedNumberOfQueries);

        // Since "getAccountMap" uses a query to define the map, we must ensure that
        // the number of queries is not increased after the first call

        numberOfQueriesSoFar = updatedNumberOfQueries;
        accountMap = ContactUtil.getAccountMap(new List<Contact>{ct});
        updatedNumberOfQueries = Limits.getQueries();

        System.assertEquals(numberOfQueriesSoFar, updatedNumberOfQueries);
    }

    // This method ensures the proper population of the contacts' "AccountName__c" field
    // and the proper reset of the singleton collections after each batch of records
    // is processed by the trigger
    @IsTest
    private static void testSetAccountNamesBulk() {
        Account testAcct1 = [SELECT Id FROM Account WHERE Name = 'Test Account 1'];
        Account testAcct2 = [SELECT Id FROM Account WHERE Name = 'Test Account 2'];

        List<Contact> cts = new List<Contact>();
        Contact ct;

        // First set of records is created with the same account
        for (Integer i = 1; i <= 200; i++) {
            ct = new Contact();
            ct.FirstName = 'Test';
            ct.LastName = 'Contact ' + String.valueOf(i);
            ct.AccountId = testAcct1.Id;
            cts.add(ct);
        }

        // Another 400 contacts are created with a different account
        // Since "resetCollections" was implemented and this will result in more than one batch
        // of records, all contacts should have their "AccountName__c" fields properly populated
        for (Integer i = 1; i <= 400; i++) {
            ct = new Contact();
            ct.FirstName = 'Test';
            ct.LastName = 'Contact ' + String.valueOf(i);
            ct.AccountId = testAcct2.Id;
            cts.add(ct);
        }
        Database.insert(cts);

        // Inserted contacts are queried for again so that we get access to the AccountName__c field
        // and the final assertions can be performed
        cts = [SELECT Id, AccountName__c, Account.Name FROM Contact WHERE Id IN :cts];
        for (Contact newCt :cts) {
            System.assertEquals(newCt.Account.Name, newCt.AccountName__c);
        }
    }
}