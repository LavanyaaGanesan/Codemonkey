/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Trigger for deleting the dailysales records related to shipto information records.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  17-Jan-2020
* *************************************************************** */
trigger DeleteDailySaleWhenShipToDelete on ShipTo_Information__c (before delete) 
{
     //get the Organization default Custom Settings for ShipTo Information object object
    ShipTo_Setting__c spSetting =  ShipTo_Setting__c.getOrgDefaults();
    //check IsActiveTrigger__c =true else it will InActive trigger
    if (spSetting.IsActive_trigger__c){
    //Gets the deleted shipto information record.
	for(ShipTo_Information__c st: Trigger.old)
    {
        // pass the record to DeleteDailySaleWhenShipToDeleteC class
        DeleteDailySaleWhenShipToDeleteC.getDailyRecToDel(st);
    }
    }
}