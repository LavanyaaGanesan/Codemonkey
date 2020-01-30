/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Trigger fire on SalesPlanner object
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  8-Jan-2020
* *************************************************************** */
trigger Trg_SalesPlanner on Sales_Planner__c (before insert,before update,
                                              after insert,after update,
                                              before delete, after undelete) 
{
    //get the Organization default Custom Settings for SP object
    SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
    //check ActiveTrigger__c =true then its Activate the Trigger else it will InActive trigger
    if (spSetting.ActiveTrigger__c){
        //check the before Insert, before Update and before delete condition
        if (trigger.isBefore){
            if(trigger.isInsert){
                //calling the beforeInsert function in handler class
                Trg_SalesPlanner_Helper.beforeInsert(trigger.new);
            }
            if(trigger.isUpdate){
                //calling the beforeUpdate function in handler class
                Trg_SalesPlanner_Helper.beforeUpdate(trigger.new);
            }
            if(trigger.isDelete){
                //calling the beforeDelete function in handler class
                Trg_SalesPlanner_Helper.beforeDelete(trigger.old);
            }
        } 
        //check the after Insert and after Update condition
        if (trigger.isAfter){
            if(trigger.isInsert){
                //calling the afterInsert function in handler class
                Trg_SalesPlanner_Helper.afterInsert(trigger.new);
            }
            if(trigger.isUpdate){
                //calling the afterUpdate function in handler class
                Trg_SalesPlanner_Helper.afterUpdate(trigger.new,trigger.old);
            }
        }
        //check the isundelete condition
        if( trigger.isundelete){
            //calling the isundelete function in handler class
            Trg_SalesPlanner_Helper.isundelete(trigger.new);        
        }
    }
}