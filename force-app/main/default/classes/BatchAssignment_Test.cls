@isTest
private class BatchAssignment_Test{
    public static String CRON_EXP = '0 0 0 3 9 ? 2042';
    @isTest
    private static void testBatchApex(){
        List<Contact> cList = new List<Contact>();
        for (Integer i=0;i<200;i++){
            contact ct = new Contact(Lastname = 'TestBatch');
            cList.add(ct);
        }
        insert clist;
        Test.startTest();
        BatchAssignment ba = new BatchAssignment();
        Database.executeBatch(ba);
        	
        Test.stopTest();
         String jobId = System.schedule('testclassScheduler', BatchAssignment_Test.CRON_EXP, new BatchAssignment()); 
        List<Contact> tempClist = new List<Contact>();
        
        tempclist = [SELECT  FirstName,Status__c FROM Contact WHERE Status__c='Ready for approved']; 
                     System.assertEquals(tempClist.size() == cList.size(),true);
      }
 }