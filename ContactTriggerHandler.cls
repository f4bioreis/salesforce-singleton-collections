public class ContactTriggerHandler {
    
    // This method implements an example of related records' fields requirement
    public static void setAccountNames(List<Contact> contacts) {
        Map<Id, Account> accountMap = ContactUtil.getAccountMap(contacts);
        for (Contact ct :contacts) {
            ct.AccountName__c = accountMap.get(ct.AccountId)?.Name;
        }
    }
    
}