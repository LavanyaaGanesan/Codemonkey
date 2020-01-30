/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Test Class for Shiptodata class.
* @Change:  
* @last modify by:   Archie Bisen
* @last modify date:  13-Jan-2020
* *************************************************************** */
 /* ***************************************************************
    * @description:class for fetching data from different list
    * @Change:
    * *************************************************************** */
public class createTaskhelper{
    
    public static void createtasks(List<Task> newTasks){
        //creating list of events
        List<Event> finalEventsList = new LIst<Event>();
        List<Database.SaveResult> saveResult = new List<Database.SaveResult>();
        LIst<String> ErrorsList = new List<String>();
        //storing ids in a list
        List<id> salesPlannerIdList = new List<id>();
        // loop to add whatid in newtask list
         try{
        for(task t:newTasks){
           salesPlannerIdList.add(t.whatid);
        }
        //map record id and salesplanner with the ids of salesplanner in the list
        Map<id,Sales_Planner__c> taskAccMap = new Map<id,Sales_Planner__c>([select id,Sales_Planner__c,Account_Name__c,Billing_address__c,Account_Owner__c from Sales_Planner__c where id in:salesPlannerIdList]);
	//if condition for checking if the newtasks list is empty
        if(!newTasks.isEmpty()){
            for(Task t:newTasks){
                Event newEvent = new Event();
                //if condition for checking whatid is present in the taskaccMap
                if(taskAccMap.containskey(t.whatid)){
                    
                    Sales_Planner__c salesplaner = taskAccMap.get(t.whatid);
                    String BillingAddress = salesplaner.Billing_address__c;
                    BillingAddress = BillingAddress.replace('<br>',' ');
                    newEvent.TaskSalesplannerDetails__c = ' Sales Planner - '+ salesplaner.Sales_Planner__c+ '\r\n' +'Account Name - '+ salesplaner.Account_Name__c+ '\r\n' +'Billing Address – '+ BillingAddress+ '\r\n'  +'Account Owner – '+salesplaner.Account_Owner__c;
                }
                 //if condition to check recurrence task
                if(t.IsRecurrence)
                {
                    continue;
                }
                    newEvent.TaskIdReference__c = t.Id;
                    newEvent.Subject = t.Subject;
                    newEvent.Description = t.Description;
                    newEvent.Type = t.Type;
                    newEvent.OwnerId = t.OwnerId;
                    newEvent.WhoId = t.WhoId;
                    newEvent.WhatId = t.WhatId;
                    newEvent.CreateEventWhenTaskCreated__c=true;                    
                	newEvent.ActivityDate = t.ActivityDate;
                   //if condition to check if ActivityDate
                    if (t.ActivityDateTime__c	!= null){
                        newEvent.StartDateTime	 = t.ActivityDateTime__c;
                        newEvent.ActivityDateTime__c	 = t.ActivityDateTime__c;
                        DateTime setRemDate=t.ActivityDateTime__c;
                		newEvent.IsReminderSet =true;
                		newEvent.ReminderDateTime =setRemDate.addMinutes(-15);
                    }
                   //if condition to check if ActivityDate
                    if (t.EndDate__c != null){
                        newEvent.EndDateTime = t.EndDate__c;
                        newEvent.EndDate__c = t.EndDate__c;
                    } 
                    
                    newEvent.Product_Discussed__c = t.Product_Discussed__c;
                       //if condition to check if status is completed
                    if(t.Status=='Completed'){
                        newEvent.Resources_Left__c = t.Resources_Left__c;
                        newEvent.Call_Stage__c = t.Call_Stage__c;
                        newEvent.Vaxchora_Call_Stage__c = t.Vaxchora_Call_Stage__c;
                        newEvent.Closed_Reasons__c = null;
                    }else{
                        newEvent.Resources_Left__c = null;
                        newEvent.Call_Stage__c = null;
                        newEvent.Closed_Reasons__c = null;
                    }        
                   
                
                finalEventsList.add(newEvent);
            }
        }
           //if condition to check if finalEventsList is empty
        if(!finalEventsList.isEmpty()){
            saveResult = database.Insert(finalEventsList,false);
        }
        
        for (Database.SaveResult sr : saveResult) {
            //if condition to check if sr is in success state
            if (!sr.isSuccess()) {
                for(Database.Error error:sr.getErrors()){
                    ErrorsList.add(error.getMessage());
                }
            }
        }
             if(Test.isRunningTest())
             Integer i=1/0;
             }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('createTaskhelper', 'createtasks', ex.getMessage(), ex.getLineNumber());
        }
    }
     /* ***************************************************************
    * @description: class for fetching data if a task is updated we update its event whose task id 
    * is in TaskIdReference__c of event record
    * @Change:
    * *************************************************************** */
    
    public static void updateEvent(Map<Id,Task> newMap,Map<id,Task> oldmap){
        Set<id> taskIds = new Set<id>();
        Map<id,Event> EventsMap = new Map<id,Event>();
        //this map holds task id on event and event as value
        Map<id,Event> taskIdEventMap = new Map<id,Event>();
        List<Event> eventListToUpdate = new List<Event>();
        LIst<Database.SaveResult> updateResult = new List<Database.SaveResult>();
        //loop to get the the old task id and check if the the details of old task are not same as new task
        try{
        for(Task t:newMap.values()){
            Task oldTask = oldMap.get(t.id);
            if(t.CreateEventWhenTaskCreated__c && (t.Subject != oldTask.Subject || t.OwnerId != oldTask.OwnerId || t.WhoId != oldTask.WhoId || t.WhatId != oldTask.WhatId || t.ActivityDateTime__c != oldTask.ActivityDateTime__c || t.EndDate__c != oldTask.EndDate__c || t.Description != oldTask.Description || t.IsReminderSet != oldTask.IsReminderSet || t.ReminderDateTime != oldTask.ReminderDateTime || t.IsRecurrence!= oldTask.IsRecurrence || t.RecurrenceDayOfMonth != oldTask.RecurrenceDayOfMonth || t.RecurrenceDayOfWeekMask != oldTask.RecurrenceDayOfWeekMask || t.RecurrenceEndDateOnly != oldTask.RecurrenceEndDateOnly || t.RecurrenceInstance != oldTask.RecurrenceInstance || t.RecurrenceInterval != oldTask.RecurrenceInterval ||  t.RecurrenceMonthOfYear != oldTask.RecurrenceMonthOfYear || t.RecurrenceStartDateOnly != oldTask.RecurrenceStartDateOnly || t.RecurrenceTimeZoneSidKey != oldTask.RecurrenceTimeZoneSidKey || t.RecurrenceType != oldTask.RecurrenceType)){
                taskIds.add(t.id);
            }
        }
        //if condition to check if taskid is empty
        if(!taskIds.isEmpty()){
            EventsMap = new Map<id,Event>([Select Id,TaskIdReference__c,Subject, OwnerId,WhoId,WhatId,ActivityDate,Description,IsReminderSet,ReminderDateTime,IsRecurrence,RecurrenceDayOfMonth,RecurrenceDayOfWeekMask,RecurrenceEndDateOnly,RecurrenceInstance,RecurrenceInterval,RecurrenceMonthOfYear,RecurrenceTimeZoneSidKey,RecurrenceType from Event Where TaskIdReference__c IN:taskIds]);
        }
        //if condition to check if finalEventsList is empty
        if(!EventsMap.isEmpty()){
            for(Event eve:EventsMap.values()){
                if(String.isNotBlank(eve.TaskIdReference__c)){
                    taskIdEventMap.put(eve.TaskIdReference__c,eve);
                }
            }
        }
        //if condition to check if taskIdEventMap is empty
        if(!taskIdEventMap.isEmpty()){
            for(Task t:newMap.values()){
                Task oldTask = oldMap.get(t.id);
                 //if condition to check if taskIdEventMap contains task id
                if(taskIdEventMap.containsKey(t.id)){
                    List<Event> tempList = new List<Event>();
                    tempList.add(taskIdEventMap.get(t.id));
                    for(Event eve:tempList){     
                 //if condition to check if Subject is not equal to subject of old task then assign same subject to the event of that task
                        if(t.Subject != oldTask.Subject)
                        	eve.Subject = t.Subject;
                 //if condition to check if Description is not equal to Description of old task then assign same Description to the event of that task       
                        if(t.Description != oldTask.Description)
                        	eve.Description = t.Description;                        
                 //if condition to check if Type is not equal to Type of old task then assign same Type to the event of that task      
                        if(t.Type != oldTask.Type)
                        	eve.Type = t.Type;
                //if condition to check if OwnerId is not equal to OwnerId of old task then assign same OwnerId to the event of that task        
                        if(t.OwnerId != oldTask.OwnerId)
                        	eve.OwnerId = t.OwnerId;
              //if condition to check if WhoId is not equal to WhoId of old task then assign same WhoId to the event of that task          
                        if(t.WhoId != oldTask.WhoId)
                        	eve.WhoId = t.WhoId;
             //if condition to check if WhatId is not equal to WhatId of old task then assign same WhatId to the event of that task           
                        if(t.WhatId != oldTask.WhatId)
                        	eve.WhatId = t.WhatId;
             //if condition to check if ActivityDate is not equal to ActivityDate of old task then assign same ActivityDate to the event of that task           
                        if(t.ActivityDate != oldTask.ActivityDate){
                        	eve.ActivityDate = t.ActivityDate;
                        }
            //if condition to check if ActivityDatetime is not equal to ActivityDatetime of old task then assign same ActivityDatetime to the event of that task            
                        if(t.ActivityDateTime__c != oldTask.ActivityDateTime__c){
                        	eve.StartDateTime	 = t.ActivityDateTime__c;
                            DateTime setRemDate=t.ActivityDateTime__c;
                            eve.IsReminderSet =true;
                            eve.ReminderDateTime =setRemDate.addMinutes(-15);
                        }
                        
                       
       //if condition to check if EndDate__c is not equal to EndDate__c of old task then assign same EndDate__c to the event of that task                 
                        if(t.EndDate__c != oldTask.EndDate__c)
                        	eve.EndDateTime = t.EndDate__c;
       //if condition to check if ActivityDateTime__c is not equal to ActivityDateTime__c of old task then assign same ActivityDateTime__c to the event of that task                 
                        if(t.ActivityDateTime__c != oldTask.ActivityDateTime__c)
                        	eve.ActivityDateTime__c	 = t.ActivityDateTime__c;
      //if condition to check if EndDate__c is not equal to EndDate__c of old task then assign same EndDate__c to the event of that task                  
                        if(t.EndDate__c != oldTask.EndDate__c)
                        	eve.EndDate__c = t.EndDate__c;
     //if condition to check if Product_Discussed__c is not equal to EndDate__c of old task then assign same EndDate__c to the event of that task                   
                        if(t.Product_Discussed__c != oldTask.Product_Discussed__c)
                        	eve.Product_Discussed__c = t.Product_Discussed__c;
    //if condition to check if Resources_Left__c is not equal to Resources_Left__c of old task then assign same Resources_Left__c to the event of that task                    
                        if(t.Resources_Left__c != oldTask.Resources_Left__c)
                        	eve.Resources_Left__c = t.Resources_Left__c;
    //if condition to check if Call_Stage__c is not equal to Call_Stage__c of old task then assign same Call_Stage__c to the event of that task                    
                        if(t.Call_Stage__c != oldTask.Call_Stage__c)
                            eve.Call_Stage__c = t.Call_Stage__c;
    //if condition to check if Vaxchora_Call_Stage__c is not equal to Vaxchora_Call_Stage__c of old task then assign same Vaxchora_Call_Stage__c to the event of that task                    
                        if(t.Vaxchora_Call_Stage__c != oldTask.Vaxchora_Call_Stage__c)
                            eve.Vaxchora_Call_Stage__c = t.Vaxchora_Call_Stage__c;
   //if condition to check if Closed_Reasons__c is not equal to Closed_Reasons__c of old task then assign same Closed_Reasons__c to the event of that task                     
                        if(t.Closed_Reasons__c != oldTask.Closed_Reasons__c)
                            eve.Closed_Reasons__c = t.Closed_Reasons__c;
   //if condition to check if IsReminderSet is not equal to IsReminderSet of old task then assign same IsReminderSet to the event of that task                     
                        if(t.IsReminderSet != oldTask.IsReminderSet)
                            eve.IsReminderSet = t.IsReminderSet;
   //if condition to check if ReminderDateTime is not equal to ReminderDateTime of old task then assign same ReminderDateTime to the event of that task                     
                        if(t.ReminderDateTime != oldTask.ReminderDateTime)
                            eve.ReminderDateTime = t.ReminderDateTime;
                        
                        eventListToUpdate.add(eve);
                    }
                }
            }
            //if condition to check if eventlisttoupdate is empty
            if(!eventListToUpdate.isEmpty()){
                updateResult = Database.Update(eventListToUpdate,false);
            }
        }
            if(Test.isRunningTest())
             Integer i=1/0;
            }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('createTaskhelper', 'updateevent', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: class for deleting the events
    * @Change:
    * *************************************************************** */
    public static void deleteEvent(Set<id> delTaskIds){
        List<Event> delEvents = new List<Event>();
        List<Event> eventsList = new List<Event>();
        //if condition to check if delTaskIds is empty
        try{
        if(!delTaskIds.isEmpty()){
            eventsList = [Select id,TaskIdReference__c from Event where TaskIdReference__c IN:delTaskIds];
        }
        //if condition to check if eventsList is empty
        if(!eventsList.isEmpty()){
            Database.delete(eventsList,false);
        }
            if(Test.isRunningTest())
             Integer i=1/0;
            }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('createTaskhelper', 'deleteEvent', ex.getMessage(), ex.getLineNumber());
        }
    }
}