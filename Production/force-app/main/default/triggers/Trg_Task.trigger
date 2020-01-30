trigger Trg_Task on Task (after delete, after insert, after undelete, after update) {   
    Set<Id> setids=new Set<Id>();
    if(trigger.isInsert && Trigger.IsAfter)
    {
        Trg_Task_Helper.afterinsert(trigger.New);       
    }
    if(trigger.isupdate && Trigger.IsAfter)
    {
        Trg_Task_Helper.afterUpdate(trigger.New);
    }
    if(trigger.isdelete && Trigger.IsAfter)
    {
        system.debug('in after delete');
        Trg_Task_Helper.afterDelete(trigger.old);
    }    
}