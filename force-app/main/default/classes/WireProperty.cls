public with sharing class WireProperty {
  @AuraEnabled(cacheable = true)
  public static List<Contact> getContacs(String accId){
    return [SELECT AccountId, Id , FirstName, LastName FROM Contact WHERE AccountId =: accId];
  }
}