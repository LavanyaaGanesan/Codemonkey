/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Test Class to provide test data for Schedule_InDirectDailySalesBatch class.
* @Change:  
* @last modify by: Prashant Damke
* @last modify date:  14-Jan-2020
* *************************************************************** */
@istest
public class Schedule_InDirectDailySalesBatchTest
{
    /* ***************************************************************
	* @description: Method which provides test data for the Schedule_InDirectDailySalesBatch class 
	* @Change:
	* *************************************************************** */
    @isTest
    static void testMeth()
    {
         try{
        test.startTest();
        //Create instance for Schedule_InDirectDailySalesBatch class.
        Schedule_InDirectDailySalesBatch nightlyUpdate = new Schedule_InDirectDailySalesBatch();
        //Provide test schedule data timing 
        String schedule = '0 0 23 * * ?';
        //to schedule the test class for the test timing.
        system.schedule('Nightly Update', schedule, nightlyUpdate);
        test.stopTest();
         }catch(exception ex){
            ApexDebugLogController.insertLog('Schedule_InDirectDailySalesBatchTest', 'testMeth', ex.getMessage(), ex.getLineNumber());
        }

    }
     @isTest
    static void testMeth1(){
        try{
        test.startTest();
        //Create instance for Schedule_InDirectDailySalesBatch class.
        Schedule_INDirectDailySalesBatch nightlyUpdate = new Schedule_InDirectDailySalesBatch();
        //Provide test schedule data timing 
        String schedule ='';
        //to schedule the test class for the test timing.
        system.schedule('Nightly Update', schedule, nightlyUpdate);
        test.stopTest();
         }catch(exception ex){
            ApexDebugLogController.insertLog('Schedule_InDirectDailySalesBatchTest', 'testMeth', ex.getMessage(), ex.getLineNumber());
        }
    }
}