@IsTest
private class SeverSidePagTestClass {
    @IsTest
    static void testgetAllObject(){
        fetchData fetch = new fetchData();
        System.assert(fetchData.getAllObject().size()!=0,true);
    }
    
    @IsTest
    static void testgetAllfields(){
        String objectName = 'Contact';
        System.assert(fetchData.getAllfields(objectName).size()!=0,true);
    }
    
    @IsTest
    static void testretrieveRecord(){
        Integer pageSize = 10;
        List<String> field = new List<String>{'Amount_c','Rating','Industry','Active_c'};
            String objectName = 'Contact';
        fetchData.RecordsWrapper rec =new fetchData.RecordsWrapper();
        List<String> recordsofqu = new List<String>();
        String records = 'SELECT Id FROM ' + objectName;
        recordsofqu.add(records);
        rec.totalRecords = recordsofqu.size();
        System.assert(fetchData.retrieveRecord(objectName,field,pageSize).ListOfRecords.size()!=0,true);
    }
    
    @IsTest
    static void testgetSortRecords(){
        Integer pageSize = 10;
        List<String> field = new List<String>{'Amount_c','Rating','Industry','Active_c'};
            String objectName = 'Account';
        String sortDir = 'ASC';
        String sortField= 'FirstName';
        
        List<Id> ids = new List<Id>();
        ids.add('0035g00000mI9bFAAS');
        List<SObject> tempObj = fetchData.getSortRecords(ids,field,objectName,sortField,sortDir,pageSize);
        System.assert(fetchData.getSortRecords(ids,field,objectName,sortField,sortDir,pageSize).size()!=0,true);
        //System.assert(fetchData.getSortRecords(ids,field,objectName,sortField,sortDir,pageSize).records.size()!=0,true);
        // System.assert(tempObj.size()!=0,true);
    }
    @IsTest
    static void testnextButtonRecord(){
        fetchData fet = new fetchData();
        Integer pageSize = 10;
        List<String> field = new List<String>{'Amount_c','Rating','Industry','Active_c'};
            String objectName = 'Account';
        Id ids = '0035g00000mI9bFAAS';
        System.assert(fetchData.nextButtonRecord(ids, objectName, field, pageSize).size()!=0,true);
    }
     @IsTest
    static void testpreviousButtonRecords(){
        fetchData fet = new fetchData();
        Integer pageSize = 10;
        List<String> field = new List<String>{'Amount_c','Rating','Industry','Active_c'};
            String objectName = 'Account';
        Id ids = '0035g00000mI9bFAAS';
        System.assert(fetchData.previousButtonRecords(ids, objectName, field, pageSize).size()!=0,true);
    }
 @IsTest
    static void testlastButtonRecords(){
        fetchData fet = new fetchData();
        Integer pageSize = 10;
        List<String> field = new List<String>{'Amount_c','Rating','Industry','Active_c'};
            String objectName = 'Account';
        System.assert(fetchData.lastButtonRecords(objectName, field, pageSize).size()!=0,true);
    }
 @IsTest
    static void testsetPageRecord(){
        fetchData fet = new fetchData();
        Integer pageSize = 10;
        Id ids = '0035g00000mI9bFAAS';
        List<String> field = new List<String>{'Amount_c','Rating','Industry','Active_c'};
            String objectName = 'Account';
        System.assert(fetchData.setPageRecord(ids,objectName, field, pageSize).size()!=0,true);
    }

}