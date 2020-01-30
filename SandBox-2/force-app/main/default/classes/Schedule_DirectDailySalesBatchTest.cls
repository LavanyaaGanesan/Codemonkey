/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Test Class to provide test data for Schedule_DirectDailySalesBatch class.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  08-Jan-2020
* *************************************************************** */
@istest
public class Schedule_DirectDailySalesBatchTest
{
    /* ***************************************************************
	* @description: Method which provides test data for the Schedule_DirectDailySalesBatch class 
	* @Change:
	* *************************************************************** */
    @isTest
    static void testMeth()
    {
         try{
        test.startTest();
        //Create instance for Schedule_DirectDailySalesBatch class.
        Schedule_DirectDailySalesBatch nightlyUpdate = new Schedule_DirectDailySalesBatch();
        //Provide test schedule data timing 
        String schedule = '0 0 23 * * ?';
        //to schedule the test class for the test timing.
        system.schedule('Nightly Update', schedule, nightlyUpdate);
        test.stopTest();
         }catch(exception ex){
            ApexDebugLogController.insertLog('Schedule_DirectDailySalesBatchTest', 'testMeth', ex.getMessage(), ex.getLineNumber());
        }

    }
     @isTest
    static void testMeth1(){
        try{
        test.startTest();
        //Create instance for Schedule_DirectDailySalesBatch class.
        Schedule_DirectDailySalesBatch nightlyUpdate = new Schedule_DirectDailySalesBatch();
        //Provide test schedule data timing 
        String schedule ='';
        //to schedule the test class for the test timing.
        system.schedule('Nightly Update', schedule, nightlyUpdate);
        test.stopTest();
         }catch(exception ex){
            ApexDebugLogController.insertLog('Schedule_DirectDailySalesBatchTest', 'testMeth', ex.getMessage(), ex.getLineNumber());
        }
    }
}