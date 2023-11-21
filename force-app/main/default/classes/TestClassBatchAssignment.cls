@isTest
public class TestClassBatchAssignment {
        @isTest
        static void Teststart(){
        Test.startTest();
            BatchAssignment kp = new BatchAssignment();
            kp.CSVFile='Name , Birthdate , Description ,LastModifiedBy , DoNotCall,\n';
            Database.executeBatch(kp);
        Test.stopTest();
    }
    static void Testexecute(){
         Test.startTest();
            BatchAssignment kp = new BatchAssignment();
            List<Contact> ct = [SELECT  FirstName,Status__c,Birthdate,Description,LastCURequestDate,DoNotCall FROM Contact];
        for(Contact c:ct){
            c.Status__c='Ready for approved';
            kp.CSVFile+=c.FirstName+',';
        }
        update ct;
         Database.executeBatch(kp);
        Test.stopTest();
    }
}