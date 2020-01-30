/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Trigger fire on Task object
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  8-Jan-2020
* *************************************************************** */
   trigger CreateEventWhenTaskCreated on Task(after insert,after update,after delete){
     //get the Organization default Custom Settings for task object
    Trg_Task_Setting__c spSetting =  Trg_Task_Setting__c.getOrgDefaults();
    //check IsActiveTrigger__c =true else it will InActive trigger
    if (spSetting.Is_Active__c){
        
    if(trigger.isAfter){
        //all after insert methods are declared inside trigger.isInsert
        if(trigger.isInsert){
            List<task> tskList = new List<Task>();
            for(Task t:trigger.new){
                if(t.CreateEventWhenTaskCreated__c){
                    tskList.add(t);
                }
            }
            if(!tskList.isEmpty()){
                createTaskhelper.createtasks(trigger.new);
            }
        }
        //All after update methods are called inside trigger.isUpdate
        if(trigger.isUpdate){
            createTaskhelper.updateEvent(trigger.newMap,trigger.oldMap);
        }
        //All after delete methods are called inside trigger.isDelete
        if(trigger.isDelete){
                Set<id> delTaskIds = new Set<id>();
            for(Task t:trigger.old){
                if(t.CreateEventWhenTaskCreated__c){
                    delTaskIds.add(t.id);
                }
            }
            if(!delTaskIds.isEmpty()){
                createTaskhelper.deleteEvent(delTaskIds);
            }
        }
    }
}
}