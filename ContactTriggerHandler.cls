public class ContactTriggerHandler {
    
    public static void setAccountNames(List<Contact> contacts) {
        Map<Id, Account> accountMap = ContactUtil.getAccountMap(contacts);
        for (Contact ct :contacts) {
            ct.AccountName__c = accountMap.get(ct.AccountId)?.Name;
        }
    }

    // This proves that the singleton collection "accountMap" has already
    // been defined, and thus, will simply be returned when required
    public static void getRelatedAccounts() {
        // Map<Id, Account> accountMap = ContactUtil.getAccountMap(contacts);
    }
}