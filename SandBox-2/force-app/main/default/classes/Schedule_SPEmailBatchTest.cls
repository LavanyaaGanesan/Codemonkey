/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: It used to test schedule SP Email Batch class 
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  10-Jan-2020
* *************************************************************** */
@istest
public class Schedule_SPEmailBatchTest 
{
    /* ***************************************************************
    * @description: This function used for code coverage 
    * @Change:  
    * *************************************************************** */
    @isTest
    static void testMeth()
    {
        //start the code coverage execution
        test.startTest();
        //create the Schedule_SPEmailBatch object
        Schedule_SPEmailBatch nightlyUpdate = new Schedule_SPEmailBatch();
        //declare variable with crone expression
        String schedule = '0 0 23 * * ?';
        //sshedule a batch
        system.schedule('Nightly Update', schedule, nightlyUpdate);
        //stop the code coverage execution
        test.stopTest();
    }
    
}