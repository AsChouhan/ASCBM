@isTest
private class KanbanTest{
    @isTest
    static void testGetFields(){
        Map<String,String> allFieldsMap = new Map<String,String>();
        test.startTest();
        allFieldsMap = CustomKanbanController.getFields('Account'); 
        List<String> fieldsValues = allFieldsMap.values();
        test.stopTest();
        System.assertEquals(fieldsValues.size(),12);
    }
    @isTest
    static void testGetRecords(){
        test.startTest();
        CustomKanbanController.KanBanWrapper kw = CustomKanbanController.getRecords('Account','Type');
        test.stopTest();
        System.assertEquals(kw.pickVals.contains('Prospect'), true);
    }
    
        @isTest
    static void testGetRecord(){
        test.startTest();
        CustomKanbanController.KanBanWrapper kw = CustomKanbanController.getRecords('Case','Status');
        test.stopTest();
        System.assertEquals(kw.pickVals.contains('New'), true);
    }
    @isTest
    static void testgetUpdatePickListValue_Apex(){
        List<Account> acntList = new List<Account>();
        Account acc=new Account(Name='Shankar');
        Account acc1=new Account(Name='shubham');
        acntList.add(acc);
        acntList.add(acc1);
        insert acntList;
        test.startTest();
        CustomKanbanController.getUpdatePicklistValue_Apex(acntList[0].id, 'Type', 'Other');
        update acntList[0];
        test.stopTest();
        System.assertEquals(acntList[0].Type, null);
    }
}