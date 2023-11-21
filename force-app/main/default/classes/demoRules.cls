public with sharing class demoRules {
  public static void createCase(){
    Id marketingRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name = 'Marketing' LIMIT 1].Id;
    List<Case> listofCase = new List<Case>();
    Case newCase = new Case();
    
    newCase.RecordTypeId = marketingRecordTypeId; // Set the RecordTypeId to the Marketing record type
    newCase.Subject = 'Demo Case 3'; // Set the Subject field to 'Demo Case'
    newCase.Description = 'This is a demo case record.'; // Set the Description field
    newCase.Status = 'New'; // Set the Status field (You can set it to the desired value)
    newCase.Priority = 'High'; // Set the Priority field (You can set it to the desired value)
    
    // Assign the Contact record's Id to the Contact field
    newCase.ContactId = '0035g000010jcSCAAY'; // Replace with the actual Contact Id
    
    listofCase.add(newCase);
    
    insert listofCase;  
}

}