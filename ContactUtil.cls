public class ContactUtil {
    
    private static Set<Id> acctIds;
    private static Map<Id, Account> accountMap;

    public static Set<Id> getAcctIds(List<Contact> cts) {
        if (acctIds != null) {
            return acctIds;
        }
        else {
            acctIds = new Set<Id>();
            for (Contact c :cts) {
                acctIds.add(c.AccountId);
            }
            return acctIds;
        }
    }

    public static Map<Id, Account> getAccountMap(List<Contact> cts) {
        // The accountMap is only populated if it hasn't been defined at the time
        // Otherwise, it is simply returned

        if (accountMap != null) return accountMap;
        acctIds = getAcctIds(cts);

        accountMap = new Map<Id, Account>([
            SELECT Id, Name FROM Account WHERE Id IN :acctIds
        ]);
        return accountMap;
    }

    public static void resetCollections() {
        acctIds = null;
        accountMap = null;
    }
}