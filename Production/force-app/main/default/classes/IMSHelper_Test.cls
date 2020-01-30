@isTest
public class IMSHelper_Test {
    public static testMethod void createIMSYears(){
        Account a = new Account(Name = 'Test Account');
        insert a;
        test.startTest();
        
        String year = system.now().format('YYYY');
        IMSHelper.createIMSYear([SELECT Id from Account]);
        
        //test creating duplicates
        IMSHelper.createIMSYear([SELECT Id from Account]);
        
        //test Batch code
        schedule_Year_IMSBatch job = new schedule_Year_IMSBatch();
        String sch = '20 30 8 10 2 ?';
        String jobID = system.schedule('Test schedule_Year_IMSBatch', sch, job);
        
        test.stopTest();
        
    }
    public static testMethod void createIMSMonths(){
        Account a = new Account(Name = 'Test Account');
        insert a;
        
        IMS_Yearly_Stats__c imsYear = new IMS_Yearly_Stats__c(Account__c = a.Id,
                                                              Year__c = system.now().format('YYYY'));
        insert imsYear;
        
        test.startTest();
        
        String year = system.now().format('YYYY');
        IMSHelper.createPreviousIMSMonth([SELECT Id, Account__c from IMS_Yearly_Stats__c where Year__c =: year]);
        
        //test creating duplicates
        IMSHelper.createPreviousIMSMonth([SELECT Id, Account__c from IMS_Yearly_Stats__c where Year__c =: year]);
        
        //test Batch code
        schedule_Month_IMSBatch job = new schedule_Month_IMSBatch();
        String sch = '20 30 8 10 2 ?';
        String jobID = system.schedule('Test schedule_Month_IMSBatch', sch, job);
        test.stopTest();
    }
}