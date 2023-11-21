@isTest
public with sharing class LeadUpdateFlowTest {
    static final Integer NUMBER_OF_RECORDS = 200;
    static final String RATING_COLD = 'Cold';
    static final String RATING_WARM = 'Warm';
    static final String RATING_HOT = 'Hot';

    @TestSetup
    static void makeData() {
        List<Lead> leads = new List<Lead>();
        for(Integer i=1; i<=NUMBER_OF_RECORDS; i++) {
            leads.add(new Lead(LastName = 'Test Lead ' + i, Company='Test Company'));
        }
        insert leads;
    }

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
}