@IsTest
private class testClassPagination {
    @IsTest
    static void testdisplayFields(){
        Test.startTest();
        Pagination pageInst= new Pagination();
        pageInst.secObject='Contact';
        pageInst.displayFields();
        System.assertEquals(pageInst.FieldList.size()!=0,true);   
    }
    @IsTest
    static void testaddButton(){
        Test.startTest();
        Pagination pageInst= new Pagination();
        pageInst.secObject='Contact';
        pageInst.displayFields();
        pageInst.selectedFields.add('name');
        pageInst.addFields.add(new SelectOption('name','name'));
        pageInst.addButton();
        System.assertEquals(pageInst.addFields.size(),1);
        
    }
    @IsTest
    static void testremoveButton(){
        Test.startTest();
        Pagination pageInst= new Pagination();
        pageInst.secObject='Contact';
        // pageInst.displayFields();
        pageInst.addFields.add(new SelectOption('name','name'));
        pageInst.addButton();
        System.assertEquals(pageInst.addFields.size(),1);  
        pageInst.FieldList.add(new SelectOption('name','name'));
        pageInst.removeButton();
        System.assertEquals(pageInst.FieldList.size()!=null,true);
        
    }
    @IsTest
    static void testreset(){
        Test.startTest();
        Pagination pageInst= new Pagination();
        pageInst.secObject='Contact';
        pageInst.displayFields();
        System.assertEquals(pageInst.FieldList.size()!=0,true);
        pageInst.reset();
        System.assertEquals(pageInst.FieldList.size()!=0,false);
        
    }
    @IsTest
    static void testprocessButton(){
        Test.startTest();
        Pagination pageInst= new Pagination();
        pageInst.secObject='Contact';
        pageInst.addFields.add(new SelectOption('name','name'));
        pageInst.processButton();
        System.assertEquals(pageInst.addFields.size()>0,true);
    }
}