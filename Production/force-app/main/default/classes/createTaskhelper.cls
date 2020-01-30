public class createTaskhelper{
    
    public static void createtasks(List<Task> newTasks){
        List<Event> finalEventsList = new LIst<Event>();
        List<Database.SaveResult> saveResult = new List<Database.SaveResult>();
        LIst<String> ErrorsList = new List<String>();

        List<id> salesPlannerIdList = new List<id>();
        for(task t:newTasks){
           salesPlannerIdList.add(t.whatid);
        }
        
        Map<id,Sales_Planner__c> taskAccMap = new Map<id,Sales_Planner__c>([select id,Sales_Planner__c,Account_Name__c,Billing_address__c,Account_Owner__c from Sales_Planner__c where id in:salesPlannerIdList]);
	
        if(!newTasks.isEmpty()){
            for(Task t:newTasks){
                Event newEvent = new Event();
                
                if(taskAccMap.containskey(t.whatid)){
                    Sales_Planner__c salesplaner = taskAccMap.get(t.whatid);
                    String BillingAddress = salesplaner.Billing_address__c;
                    BillingAddress = BillingAddress.replace('<br>',' ');
                    newEvent.TaskSalesplannerDetails__c = ' Sales Planner - '+ salesplaner.Sales_Planner__c+ '\r\n' +'Account Name - '+ salesplaner.Account_Name__c+ '\r\n' +'Billing Address – '+ BillingAddress+ '\r\n'  +'Account Owner – '+salesplaner.Account_Owner__c;
                }
                
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
                
                    if (t.ActivityDateTime__c	!= null){
                        newEvent.StartDateTime	 = t.ActivityDateTime__c;
                        newEvent.ActivityDateTime__c	 = t.ActivityDateTime__c;
                        DateTime setRemDate=t.ActivityDateTime__c;
                		newEvent.IsReminderSet =true;
                		newEvent.ReminderDateTime =setRemDate.addMinutes(-15);
                    }
                    if (t.EndDate__c != null){
                        newEvent.EndDateTime = t.EndDate__c;
                        newEvent.EndDate__c = t.EndDate__c;
                    } 
                    
                    newEvent.Product_Discussed__c = t.Product_Discussed__c;
                    
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
                    /*if (t.IsReminderSet){
                        newEvent.IsReminderSet = t.IsReminderSet;
                        newEvent.ReminderDateTime = t.ReminderDateTime;
                    }*/
                
                finalEventsList.add(newEvent);
            }
        }
        if(!finalEventsList.isEmpty()){
            saveResult = database.Insert(finalEventsList,false);
        }
        
        for (Database.SaveResult sr : saveResult) {
            if (!sr.isSuccess()) {
                for(Database.Error error:sr.getErrors()){
                    ErrorsList.add(error.getMessage());
                }
            }
        }
    }
    
    //If a task is updated we update its event whose task id is in TaskIdReference__c of event record
    public static void updateEvent(Map<Id,Task> newMap,Map<id,Task> oldmap){
        Set<id> taskIds = new Set<id>();
        Map<id,Event> EventsMap = new Map<id,Event>();
        Map<id,Event> taskIdEventMap = new Map<id,Event>();//this map holds task id on event and event as value
        List<Event> eventListToUpdate = new List<Event>();
        LIst<Database.SaveResult> updateResult = new List<Database.SaveResult>();
        for(Task t:newMap.values()){
            Task oldTask = oldMap.get(t.id);
            if(t.CreateEventWhenTaskCreated__c && (t.Subject != oldTask.Subject || t.OwnerId != oldTask.OwnerId || t.WhoId != oldTask.WhoId || t.WhatId != oldTask.WhatId || t.ActivityDateTime__c != oldTask.ActivityDateTime__c || t.EndDate__c != oldTask.EndDate__c || t.Description != oldTask.Description || t.IsReminderSet != oldTask.IsReminderSet || t.ReminderDateTime != oldTask.ReminderDateTime || t.IsRecurrence!= oldTask.IsRecurrence || t.RecurrenceDayOfMonth != oldTask.RecurrenceDayOfMonth || t.RecurrenceDayOfWeekMask != oldTask.RecurrenceDayOfWeekMask || t.RecurrenceEndDateOnly != oldTask.RecurrenceEndDateOnly || t.RecurrenceInstance != oldTask.RecurrenceInstance || t.RecurrenceInterval != oldTask.RecurrenceInterval ||  t.RecurrenceMonthOfYear != oldTask.RecurrenceMonthOfYear || t.RecurrenceStartDateOnly != oldTask.RecurrenceStartDateOnly || t.RecurrenceTimeZoneSidKey != oldTask.RecurrenceTimeZoneSidKey || t.RecurrenceType != oldTask.RecurrenceType)){
                taskIds.add(t.id);
            }
        }
        
        if(!taskIds.isEmpty()){
            EventsMap = new Map<id,Event>([Select Id,TaskIdReference__c,Subject, OwnerId,WhoId,WhatId,ActivityDate,Description,IsReminderSet,ReminderDateTime,IsRecurrence,RecurrenceDayOfMonth,RecurrenceDayOfWeekMask,RecurrenceEndDateOnly,RecurrenceInstance,RecurrenceInterval,RecurrenceMonthOfYear,RecurrenceTimeZoneSidKey,RecurrenceType from Event Where TaskIdReference__c IN:taskIds]);
        }
        if(!EventsMap.isEmpty()){
            for(Event eve:EventsMap.values()){
                if(String.isNotBlank(eve.TaskIdReference__c)){
                    taskIdEventMap.put(eve.TaskIdReference__c,eve);
                }
            }
        }
        if(!taskIdEventMap.isEmpty()){
            for(Task t:newMap.values()){
                Task oldTask = oldMap.get(t.id);
                if(taskIdEventMap.containsKey(t.id)){
                    List<Event> tempList = new List<Event>();
                    tempList.add(taskIdEventMap.get(t.id));
                    for(Event eve:tempList){                        
                        if(t.Subject != oldTask.Subject)
                        	eve.Subject = t.Subject;
                        
                        if(t.Description != oldTask.Description)
                        	eve.Description = t.Description;                        
                        
                        if(t.Type != oldTask.Type)
                        	eve.Type = t.Type;
                        
                        if(t.OwnerId != oldTask.OwnerId)
                        	eve.OwnerId = t.OwnerId;
                        
                        if(t.WhoId != oldTask.WhoId)
                        	eve.WhoId = t.WhoId;
                        
                        if(t.WhatId != oldTask.WhatId)
                        	eve.WhatId = t.WhatId;
                        
                        if(t.ActivityDate != oldTask.ActivityDate){
                        	eve.ActivityDate = t.ActivityDate;
                        }
                        
                        if(t.ActivityDateTime__c != oldTask.ActivityDateTime__c){
                        	eve.StartDateTime	 = t.ActivityDateTime__c;
                            DateTime setRemDate=t.ActivityDateTime__c;
                            eve.IsReminderSet =true;
                            eve.ReminderDateTime =setRemDate.addMinutes(-15);
                        }
                        
                        /*System.debug('StartDateTime New : ' + t.ActivityDateTime__c);
                        System.debug('StartDateTime Old : ' + oldTask.ActivityDateTime__c);
                        
                        System.debug('EndDate__c New : ' + t.EndDate__c);
                        System.debug('EndDate__c Old : ' + oldTask.EndDate__c);*/
                        
                        if(t.EndDate__c != oldTask.EndDate__c)
                        	eve.EndDateTime = t.EndDate__c;
                        
                        if(t.ActivityDateTime__c != oldTask.ActivityDateTime__c)
                        	eve.ActivityDateTime__c	 = t.ActivityDateTime__c;
                        
                        if(t.EndDate__c != oldTask.EndDate__c)
                        	eve.EndDate__c = t.EndDate__c;
                        
                        if(t.Product_Discussed__c != oldTask.Product_Discussed__c)
                        	eve.Product_Discussed__c = t.Product_Discussed__c;
                        
                        if(t.Resources_Left__c != oldTask.Resources_Left__c)
                        	eve.Resources_Left__c = t.Resources_Left__c;
                        
                        if(t.Call_Stage__c != oldTask.Call_Stage__c)
                            eve.Call_Stage__c = t.Call_Stage__c;
                        
                        if(t.Vaxchora_Call_Stage__c != oldTask.Vaxchora_Call_Stage__c)
                            eve.Vaxchora_Call_Stage__c = t.Vaxchora_Call_Stage__c;
                        
                        if(t.Closed_Reasons__c != oldTask.Closed_Reasons__c)
                            eve.Closed_Reasons__c = t.Closed_Reasons__c;
                        
                        if(t.IsReminderSet != oldTask.IsReminderSet)
                            eve.IsReminderSet = t.IsReminderSet;
                        
                        if(t.ReminderDateTime != oldTask.ReminderDateTime)
                            eve.ReminderDateTime = t.ReminderDateTime;
                        
                        eventListToUpdate.add(eve);
                    }
                }
            }
            if(!eventListToUpdate.isEmpty()){
                updateResult = Database.Update(eventListToUpdate,false);
            }
        }
    }
    
    public static void deleteEvent(Set<id> delTaskIds){
        List<Event> delEvents = new List<Event>();
        List<Event> eventsList = new List<Event>();
        if(!delTaskIds.isEmpty()){
            eventsList = [Select id,TaskIdReference__c from Event where TaskIdReference__c IN:delTaskIds];
        }
        if(!eventsList.isEmpty()){
            Database.delete(eventsList,false);
        }
    }
}