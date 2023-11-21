public with sharing class AccountTriggerHandler {
    public static void updateOpp(List<Account> newList) {

        List<opportunity> oppRecords = [SELECT Id, StageName, Name FROM opportunity WHERE accountId IN :newList AND CreatedDate != LAST_N_DAYS:30 AND StageName != 'Closed Won'];
        for(opportunity opp : oppRecords){
            opp.StageName = 'Closed Lost';
        }
        update oppRecords;
    }
}