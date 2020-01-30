/* ***************************************************************
* Owner/Modify by Name : Prashant
* @description: DeleteTaskWhenEventDeleted trigger is used to delete task when ever repespective event is deleted, this 
				trigger fires after the delete operation commits.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  14-Jan-2020
* *************************************************************** */
trigger DeleteTaskWhenEventDeleted on Event(after delete) {
   //get the Organization default Custom Settings for Event object
    DeleteTaskWhenEventIsDeleted_c__c spSetting =  DeleteTaskWhenEventIsDeleted_c__c.getOrgDefaults();
    //check IsActiveTrigger__c =true else it will InActive trigger
    if (spSetting.IsActive__c)
    {
    //if the event is after trigger and delete operation
    if(trigger.isAfter && trigger.isDelete){
        //intialize a set to store the id's.
        Set<id> delTaskIds = new Set<id>();
        //loop through the event
        for(Event e:trigger.old){
            //check if TaskIdReference__c is not null and not blank
            if(e.TaskIdReference__c!=null && e.TaskIdReference__c!=''){
                //add task to the set initialzed above
                delTaskIds.add(e.TaskIdReference__c);
            }
        }
        // if delTaskIds set is not empty
        if(!delTaskIds.isEmpty()){
            //fetch all the tasks of the corresponding event id's
            List<Task> taskList = [Select id,TaskIdReference__c from Task where Id IN:delTaskIds];
            //if taskList is not empty
            if(!taskList.isEmpty()){
                //delete task related to event.
                Database.delete(taskList,false);
            }
        }
    }
}
}