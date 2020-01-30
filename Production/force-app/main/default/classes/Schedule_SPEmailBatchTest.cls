@istest
public class Schedule_SPEmailBatchTest 
{
    @isTest
    static void testMeth()
    {
        test.startTest();
        Schedule_SPEmailBatch nightlyUpdate = new Schedule_SPEmailBatch();
        String schedule = '0 0 23 * * ?';
        system.schedule('Nightly Update', schedule, nightlyUpdate);
        test.stopTest();
    }
    
}