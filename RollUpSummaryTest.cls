@isTest

public with sharing class RollUpSummaryTest {
    @TestSetup
    static void makeData(){
        testUtilityData.createAccountsWithContacts(1, 'Household Account', 1, 'Participant');

        testUtilityData.createProgram(1, 'Ski Program');
        testUtilityData.createProgram(1, 'Wilderness Program');
        
    }
    @isTest static void testMethod1()  {
        String vRecId = testUtilityData.createRecordType('Contact', 'Volunteer');
        String sRecId = testUtilityData.createRecordType('Contact', 'Staff');
        Contact p = [Select Id from Contact];

        String pr = [Select Id from pmdm__Program__c where recordType.Name = 'Wilderness Program'].id;
        String sk = [Select Id from pmdm__Program__c where recordType.Name = 'Ski Program'].id;

        insert new Scheduled_Participant__c(Program__c = pr, Participant__c = p.Id);
        p.recordTypeId = sRecId;
        update p;
        p = [Select Id from Contact ];
        insert new Scheduled_Instructor__c(Program__c = pr, Instructor__c = p.Id);
        insert new Scheduled_Volunteer__c(Program__c = pr, Volunteer__c = p.Id);




    }
}