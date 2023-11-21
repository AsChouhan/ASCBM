public class LookupController {
    @AuraEnabled
    public static List<SObjectResult> getResults(String ObjectName, String fieldName, String value) {
        system.debug('call'+ObjectName+fieldName+value);
        List<SObjectResult> SObjectResultList = new List<SObjectResult>();
        String q = 'SELECT Id, Name FROM ' + ObjectName + ' WHERE ' + fieldName + ' LIKE \''+ value + '%\'';
        System.debug('q///' + q);
        for (SObject so : Database.query(q)) {
            String fieldValue = (String) so.get(fieldName);
            SObjectResultList.add(new SObjectResult(fieldValue, so.Id));
            system.debug('data lisst' + SObjectResultList);
        }
        return SObjectResultList;
    }

    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;

        public SObjectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }
}