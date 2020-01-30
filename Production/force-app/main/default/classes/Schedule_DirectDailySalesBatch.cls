/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Schedule class for DirectDailySalesBatch class.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  08-Jan-2020
* *************************************************************** */
global class Schedule_DirectDailySalesBatch implements Schedulable {
     /* ***************************************************************
	* @description: calling function to execute DirectDailySalesBatch batch.
	* @Change:
	* *************************************************************** */
 global void execute(SchedulableContext ctx) 
    {
        try{
        //executes DirectDailySalesBatch class
        Database.executeBatch(new DirectDailySalesBatch()); 
            if(test.isRunningTest())
                integer i = 1/0;
        }catch(exception ex){
            ApexDebugLogController.insertLog('Schedule_DirectDailySalesBatch', 'execute', ex.getMessage(), ex.getLineNumber());
        }
        
    }   
}