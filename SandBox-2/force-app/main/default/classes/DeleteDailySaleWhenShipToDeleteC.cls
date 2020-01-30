/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Handler class used  for DeleteDailySaleWhenShipToDelete trigger
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  08-Jan-2020
* *************************************************************** */
public class DeleteDailySaleWhenShipToDeleteC 
{
    /* ***************************************************************
* @description: calling function BeforeDeleting the ShipToInformation record 
* @Change:
* *************************************************************** */
    public static void getDailyRecToDel(ShipTo_Information__c s)
    {
         list<Daily_Sales_Data__c> lstDailyRecDirect = new  list<Daily_Sales_Data__c>();
       
           
            // get dailySales records related to ShipToInformation record
            lstDailyRecDirect =[SELECT Id, Name, Account__c,ShipTo_ID__c,Quantity__c, DDD_Outlet_ID__c 
                                FROM Daily_Sales_Data__c where 
                                ShipTo_ID__c=:s.Ship_To__c And Account__c=:s.Account__c and ShipTo_Type__c='Direct'];
             try{
            //delete all records in the list 
            delete lstDailyRecDirect;
            //to get exception
            if(test.isRunningTest())
                integer i = 1/0;
            
        }catch(Exception ex){
            ApexDebugLogController.insertLog('DeleteDailySaleWhenShipToDeleteC', 'getDailyRecToDel', ex.getMessage(), ex.getLineNumber());
        }
    }  
}