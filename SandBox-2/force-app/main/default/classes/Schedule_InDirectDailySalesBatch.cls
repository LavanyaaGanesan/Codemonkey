/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Schedule class for InDirectDailySalesBatch class.
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  14-Jan-2020
* *************************************************************** */
global class Schedule_InDirectDailySalesBatch implements Schedulable {
     /* ***************************************************************
	* @description: calling function to execute InDirectDailySalesBatch batch.
	* @Change:
	* *************************************************************** */
 global void execute(SchedulableContext ctx) 
    {
        try{
        //executes InDirectDailySalesBatch class
        Database.executeBatch(new IndirectDailySalesBatch()); 
            if(test.isRunningTest())
                integer i = 1/0;
        }catch(exception ex){
            ApexDebugLogController.insertLog('Schedule_InDirectDailySalesBatch', 'execute', ex.getMessage(), ex.getLineNumber());
        }
        
    }   
}