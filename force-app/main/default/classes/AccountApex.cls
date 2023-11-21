public with sharing class AccountApex {
        @AuraEnabled
        public static List<Account> getAccountDetails(String accountId) {
            List<Account> accountList = [
                SELECT Name, (SELECT Name, LastName , Phone FROM Contacts), (SELECT Name, CloseDate FROM Opportunities)
                FROM Account
                WHERE Id = :accountId
            ];
            return accountList;
        }
    
}