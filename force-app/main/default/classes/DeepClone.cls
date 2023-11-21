public class DeepClone {
    @AuraEnabled
    public static String CreateDeepClone(String recordId) {
        System.debug('RecordId>>>>'+recordId);
        
        if(recordId != 'undefined'){
            School__c sourceSchool = [SELECT Id, Name, City_Name__c, Mob_NO__c FROM School__c WHERE Id = :recordId];

            if (sourceSchool != null) {
                School__c newSchool = sourceSchool.clone(false, true, false, false); 
                newSchool.Name += ' (Clone)';
                Insert newSchool;
                List<Student__c> sourceStudents = [SELECT Id, Name, Mobile_Number__c, First_Name__c, Last_Name__c FROM Student__c WHERE School__c = :sourceSchool.Id];

                if (!sourceStudents.isEmpty()) {
                    List<Student__c> newStudents = new List<Student__c>();
                    for (Student__c sourceStudent : sourceStudents) {
                        Student__c newStudent = sourceStudent.clone(false, true, false, false);
                        newStudent.Name += ' (Clone1)';
                        newStudent.School__c = newSchool.Id;
                        newStudents.add(newStudent);
                    }

                    System.debug('RecordId>>>>1');
                    Insert newStudents;

                    List<Position__c> positionsToInsert = new List<Position__c>();

                    System.debug(sourceStudents);
                    System.debug(sourceStudents[0].Id);

                    for (Student__c sourceStudent : sourceStudents) {
                        List<Position__c> sourcePositions = [SELECT Id, Name, Student_position__c FROM Position__c WHERE Student__c = :sourceStudents[0].Id];

                        for (Position__c sourcePosition : sourcePositions) {
                            Position__c newPosition = sourcePosition.clone(false, true, false, false);
                            newPosition.Student__c = newStudents[0].Id;
                            positionsToInsert.add(newPosition);
                        }
                    }

                    Insert positionsToInsert;
                }
            }
        }
        return 'SUCCESS';
    }
}