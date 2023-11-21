@isTest
public with sharing class FlowOfLeadObject {
    // * Constants
    static final Integer NUMBER_OF_RECORDS = 200;
    static final String RATING_COLD = 'Cold';
    static final String RATING_WARM = 'Warm';
    static final String RATING_HOT = 'Hot';

    // * Description: This method is used to create initial data for the test methods
    @TestSetup
    static void makeData() {
        List<Lead> leads = new List<Lead>();
        for(Integer i=1; i<=NUMBER_OF_RECORDS; i++) {
            leads.add(new Lead(LastName = 'Test Lead ' + i, Company='Test Company'));
        }
        insert leads;
    }

    /*
    *   Description: This method is used to verify lead rating
    *   when the annual revenue is less than 25,000
    */
    @isTest
    public static void updateLeadBasedOnAnnualRevenueLessThan25kTest() {
        List<Lead> leads = [SELECT AnnualRevenue FROM Lead];
        Test.startTest();
        for(Lead lead : leads) {
            lead.AnnualRevenue = 24999;
        }
        update leads;
        List<Lead> updatedLeads = [SELECT Rating FROM Lead];
        for(Lead lead : updatedLeads) {
            System.assertEquals(RATING_COLD, lead.Rating, 'Lead rating should be: ' + RATING_COLD);
        }
        Test.stopTest();
    }

    /*
    *   Description: This method is used to verify lead rating
    *   when the annual revenue is between 25,000 and 75,000.
    *   We're keeping the value at floor i.e. 25,000 for this test
    */
    @isTest
    public static void updateLeadBasedOnAnnualRevenueBetween25kAnd75kFloorTest() {
        List<Lead> leads = [SELECT AnnualRevenue FROM Lead];
        Test.startTest();
        for(Lead lead : leads) {
            lead.AnnualRevenue = 25000;
        }
        update leads;
        List<Lead> updatedLeads = [SELECT Rating FROM Lead];
        for(Lead lead : updatedLeads) {
            System.assertEquals(RATING_WARM, lead.Rating, 'Lead rating should be: ' + RATING_WARM);
        }
        Test.stopTest();
    }

    /*
    *   Description: This method is used to verify lead rating
    *   when the annual revenue is between 25,000 and 75,000.
    *   We're keeping the value at ceiling i.e. 75,000 for this test
    */
    @isTest
    public static void updateLeadBasedOnAnnualRevenueBetween25kAnd75kCeilingTest() {
        List<Lead> leads = [SELECT AnnualRevenue FROM Lead];
        Test.startTest();
        for(Lead lead : leads) {
            lead.AnnualRevenue = 75000;
        }
        update leads;
        List<Lead> updatedLeads = [SELECT Rating FROM Lead];
        for(Lead lead : updatedLeads) {
            System.assertEquals(RATING_WARM, lead.Rating, 'Lead rating should be: ' + RATING_WARM);
        }
        Test.stopTest();
    }

    /*
    *   Description: This method is used to verify lead rating
    *   when the annual revenue is greater than 75,000
    */
    @isTest
    public static void updateLeadBasedOnAnnualRevenueGreaterThan75kTest() {
        List<Lead> leads = [SELECT AnnualRevenue FROM Lead];
        Test.startTest();
        for(Lead lead : leads) {
            lead.AnnualRevenue = 75001;
        }
        update leads;
        List<Lead> updatedLeads = [SELECT Rating FROM Lead];
        for(Lead lead : updatedLeads) {
            System.assertEquals(RATING_HOT, lead.Rating, 'Lead rating should be: ' + RATING_HOT);
        }
        Test.stopTest();
    }

    /*
    *   Description: This method is used to cover all low elements and verify lead rating
    *   when the annual revenue is less than 25k, between 25k and 75k and also greater than 75k
    */
    @isTest
    public static void updateLeadBasedOnAnnualRevenueAllElementsTest() {
        List<Lead> leads = [SELECT AnnualRevenue FROM Lead];
        Test.startTest();
        for(Lead lead : leads) {
            lead.AnnualRevenue = 20000;
        }
        update leads;
        List<Lead> updatedLeadsWithRatingCold = [SELECT Rating FROM Lead];
        for(Lead lead : updatedLeadsWithRatingCold) {
            System.assertEquals(RATING_COLD, lead.Rating, 'Lead rating should be: ' + RATING_COLD);
        }
        for(Lead lead : leads) {
            lead.AnnualRevenue = 50000;
        }
        update leads;
        List<Lead> updatedLeadsWithRatingWarm = [SELECT Rating FROM Lead];
        for(Lead lead : updatedLeadsWithRatingWarm) {
            System.assertEquals(RATING_WARM, lead.Rating, 'Lead rating should be: ' + RATING_WARM);
        }
        for(Lead lead : leads) {
            lead.AnnualRevenue = 80000;
        }
        update leads;
        List<Lead> updatedLeadsWithRatingHot = [SELECT Rating FROM Lead];
        for(Lead lead : updatedLeadsWithRatingHot) {
            System.assertEquals(RATING_HOT, lead.Rating, 'Lead rating should be: ' + RATING_HOT);
        }
        Test.stopTest();
    }
}