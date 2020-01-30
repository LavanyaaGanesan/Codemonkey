/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: It used to schedule the SP Email Batch 
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  10-Jan-2020
* *************************************************************** */
global class Schedule_SPEmailBatch implements Schedulable {  
    /* ***************************************************************
    * @description: This function used to execute the SP EMail Batch
    * @Change:  
    * *************************************************************** */
    global void execute(SchedulableContext ctx) 
    {
        //execute the SP EMail Batch 
        Database.executeBatch(new SPEmailBatch()); 
    }   
}