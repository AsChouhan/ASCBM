@isTest
public class salesforceTosalesforceTestClass {
	/*@isTest
    static void testgetFiles(){
        Test.setMock(HttpCalloutMock.class, new sTosMockClass());
       List<object> result =  salesforceintiApex.getFiles();
        System.debug(result.size());
    }*/
    
    @isTest
    static void testuploadFiles(){
        Test.setMock(HttpCalloutMock.class, new sTosMockClass());
        String fileName = 'aasheesh singh';
        String file64 = 'eyJuYW1lIjoiYnJpc2ttaW5kUE5HLnBuZyIsImRvY3VtZW50SWQiOiIwNjk1ZzAwMDAwQ3hqOHFBQUIiLCJjb250ZW50VmVyc2lvbklkIjoiMDY4NWcwMDAwMERBZWQ1QUFEIiwiY29udGVudEJvZHlJZCI6IjA1VDVnMDAwMDBpbGxuVUVBUSIsIm1pbWVUeXBlIjoiaW1hZ2UvcG5nIn0=';
        
        String result = salesforceintiApex.uploadFiles(fileName, file64);
        System.assertEquals(result, 'Upload Success');
    }
}