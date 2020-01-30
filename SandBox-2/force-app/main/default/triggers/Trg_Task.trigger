/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Trigger fire on Task object
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  17-Jan-2020
* *************************************************************** */
trigger Trg_Task on Task (after delete, after insert, after undelete, after update) {
    //get the Organization default Custom Settings for task object
    Trg_Task_Setting__c spSetting =  Trg_Task_Setting__c.getOrgDefaults();
    //check IsActiveTrigger__c =true else it will InActive trigger
    if (spSetting.Is_Active__c) {
        //Creating set for Ids
        Set<Id> setids=new Set<Id>();
        //Checking condition for insert operation after record is saved.
        if(trigger.isInsert && Trigger.IsAfter)
        {
            Trg_Task_Helper.afterinsert(trigger.New);       
        }
        //Checking condition for Update operation after record is saved.
        if(trigger.isupdate && Trigger.IsAfter)
        {
            Trg_Task_Helper.afterUpdate(trigger.New);
        }
        ////Checking condition for delete operation after record is saved.
        if(trigger.isdelete && Trigger.IsAfter)
        {
            Trg_Task_Helper.afterDelete(trigger.old);
        }    
    }
}