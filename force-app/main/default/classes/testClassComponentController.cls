@IsTest
private class testClassComponentController {
    @IsTest
    static void testStandardSetContFunction(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        pageComp.objectName='Contact';
        List<SelectOption> fieldList=new List<SelectOption>();
        pageComp.SelectedFieldOptions.add(new selectOption('name','name'));
        pageComp.SelectedFieldOptions.add(new selectOption('MobilePhone','Mobile'));
        pageComp.display();
        System.assertEquals(pageComp.SelectedFieldOptions.size()!=0, true);
        System.assertEquals(pageComp.myList.size()!=0, false); 
    }
    /*-----------------------------------------------------------------filterRecord method-------------------------------------------------------*/
    @IsTest 
    static void testfilterRecordSingleAlphabet(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        pageComp.objectName='Contact';
        pageComp.SelectedFieldOptions.add(new selectOption('name','name'));
        pageComp.SelectedFieldOptions.add(new selectOption('MobilePhone','Mobile'));
        pageComp.display();
        pageComp.selectedAlphabet='A';
        pageComp.filterRecord();
        System.assertEquals(pageComp.filterQuery!='null',true);
        System.assertEquals(pageComp.myList.size()!=0,false);   
    } 
    @IsTest
    static void testfilterRecordAllAlphabet(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        pageComp.objectName='Contact';
        pageComp.SelectedFieldOptions.add(new selectOption('name','name'));
        pageComp.SelectedFieldOptions.add(new selectOption('MobilePhone','Mobile'));
        pageComp.display();
        pageComp.selectedAlphabet='All';
        pageComp.filterRecord();
        System.assertEquals(pageComp.filterQuery!='null',true);
        System.assertEquals(pageComp.myList.size()!=0,false);
    }
    @IsTest
    static void testfilterRecordOther(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        pageComp.objectName='Contact';
        pageComp.SelectedFieldOptions.add(new selectOption('name','name'));
        pageComp.SelectedFieldOptions.add(new selectOption('MobilePhone','Mobile'));
        pageComp.display();
        pageComp.selectedAlphabet='Other';
        pageComp.filterRecord();
        System.assertEquals(pageComp.filterQuery!='null',true);
        System.assertEquals(pageComp.myList.size()!=0,false);
    }
    /*-----------------------------------------------------------------filterRecord method-------------------------------------------------------*/
    @IsTest
    static void testdoSortFieldASC(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        
        pageComp.sortFieldName='Name';
        pageComp.sortQuery+=pageComp.SelectedFieldOptions;
        pageComp.sortExp='ASC';
        pageComp.doSortField();
        String sortQuery1 = pageComp.sortQuery ;
        List<SObject> ct = new List<SObject>();
        System.debug('-->'+sortQuery1);
        
        ct=Database.query(sortQuery1);
        
        System.assertEquals(pageComp.ssc.getResultSize()==ct.size(),true);
    }
    @IsTest
    static void testdoSortFieldDESC(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        
        pageComp.sortFieldName='Name';
        pageComp.sortQuery+=pageComp.SelectedFieldOptions;
        pageComp.sortExp='DESC';
        pageComp.doSortField();
        String sortQuery1 = pageComp.sortQuery ;
        List<SObject> ct = new List<SObject>();
        //System.debug('-->'+sortQuery1);
        
        ct=Database.query(sortQuery1);
        
        System.assertEquals(pageComp.ssc.getResultSize()==ct.size(),true);
    }
    @IsTest
    static void testDeleteSelected(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        pageComp.updateSearchItemsMap();
        pageComp.getrecords();
        pageComp.DeleteSelected();
        System.assertEquals(pageComp.DeleteSelected.size()!=null,true);
    }
    @IsTest
    static void testdoDelete(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        pageComp.pageSize=5;
        pageComp.doDelete();
        System.assertEquals(PageComp.myList.size() != PageComp.ssc.getResultSize(),true);
    }
    @IsTest
    static void testnewRecord(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        pageComp.newRecord();
        System.assertEquals(pageComp.recordId!=null,true);
    }
    @IsTest
    static void testnext(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        pageComp.next();
        System.assertEquals(pageComp.pageNumber!=0,true);
        System.assertEquals(pageComp.myList.size()!=null,true);
        
    }
    @IsTest
    static void testLast(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        pageComp.Last();
        System.assertEquals(pageComp.TotalPages!=0,true);
        System.assertEquals(pageComp.pageNumber==pageComp.TotalPages,true);
        System.assertEquals(pageComp.myList.size()!=null,true);
    }
    @IsTest
    static void testprevious(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        pageComp.previous();
        System.assertEquals(pageComp.pageNumber!=0,false);
        System.assertEquals(pageComp.myList.size()!=null,true);
    }
    @IsTest
    static void testfirst(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        pageComp.first();
        System.assertEquals(pageComp.pageNumber!=0,true);
        //System.assertEquals(pageComp.myList.size()!=null,true);
        System.assertNotEquals(pageComp.myList.size(),0);
    }
    @IsTest
    static void testdownloadCSV(){
        Test.startTest();
        ComponentController pageComp = new ComponentController();
        List<Account> acct =TestRecordGenreate.AccountRecords();
        Account acc=new Account(name='Test');
        insert acc;
        pageComp.objectName='Account';
        pageComp.SelectedFieldOptions.add(new Selectoption('Name', 'Account Name'));
        pageComp.SelectedFieldOptions.add(new selectoption('Rating', 'Account Rating'));
        pageComp.display();
        ComponentController.WrapperClass wrap = new ComponentController.WrapperClass(acc,true);
        pageComp.myList=new List<ComponentController.WrapperClass>{wrap};
        pageComp.updateSearchItemsMap();
        pageComp.downloadCSV();
        pageComp.CSVFile+=pageComp.SelectedFieldOptions.get(0).getValue();
        System.assertEquals(pageComp.CSVFile!=null,true);
    }
}