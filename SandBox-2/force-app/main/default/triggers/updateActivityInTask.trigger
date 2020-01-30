/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Trigger for Task object
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  8-Jan-2020
* *************************************************************** */
trigger updateActivityInTask on Task (before insert, before update) {
    
    //declare variables those are using while Task saving
    Static String recType; 
    //Static integer Count = 0;
    Static integer valAddDays = 0;
    //list of Holiday object, fetches the records using SOQL query mention in the Custom Label
    Static List<Holiday> listHoliday = Database.query(System.Label.pvHolidaysQuery);
    //fetch the userid
    //
    
    
    id loggedInUser=UserInfo.getUserId(); 
    //custom label contains RAM and ISR profile ID with "," seperated, its converted into string array
    string[] idString=System.Label.Profileid_RAM_ISR.Split(',');
    //create a Map of user, that fetches  all RAM and ISR user using SOQL 
    Map<id, User> lstUser =   new Map<Id, User>([SELECT Id, Name FROM User  where UserType='Standard' 
                                                 and (id =: loggedInUser or ProfileID in: idString ) and IsActive =true]);
    
    //create set of OwnerIDs
    Set<id> taskOwnerIds = new Set<id>(); 
    for (Task t: Trigger.new){
        taskOwnerIds.add(t.OwnerId);
    } 
    //create a list of PTO task base on the OwnerIDs for current year and next year
    Static List<Task> listPTOTask = [Select ID, Subject,ActivityDateTime__c, EndDate__c, OwnerId from Task where type='PTO' 
                                     and  OwnerId IN: taskOwnerIds and (ActivityDate= THIS_YEAR or  ActivityDate=NEXT_YEAR)
                                     order by OwnerId, ActivityDateTime__c ];
    
    //get the Organization default Custom Settings for task object
    Trg_Task_Setting__c spSetting =  Trg_Task_Setting__c.getOrgDefaults();
    //check IsActiveTrigger__c =true else it will InActive trigger
    if (spSetting.Is_Active__c){
        //loop for buld of task
        for (Task t: Trigger.new){
            if (Trigger.isBefore && Trigger.isInsert)
            { 
                try{            
                    //start: code block for beforeInsert
                    //check IsRecurrence = true 
                    if(t.IsRecurrence){
                        //set custom isRecurTask__c field to true
                        t.isRecurTask__c=true;
                    }
                    //check isRecurTask__c = true and set recType
                    if (t.isRecurTask__c)
                        recType = t.RecurrenceType__c;
                    //check ActivityDate and ActivityDateTime__c not null
                    if(t.ActivityDate!=null && t.ActivityDateTime__c!=null ){ 
                        //check isRecurTask__c=true and IsRecurrence=false
                        if(t.isRecurTask__c && !t.IsRecurrence){
                            //assign RecurrenceType__c into the recType variable
                            recType = t.RecurrenceType__c;
                            //set ActivityDate
                            DateTime adt = t.ActivityDate;
                            //set user timezone in interger
                            integer timezone= UserInfo.getTimezone().getOffset(System.now());
                            //check timezone contains "-"                    
                            if (string.valueOf(timezone).contains('-')){
                                //check recType, if condition match set valAddDays=1 else valAddDays=-1 
                                if (recType=='RecursDaily' || recType=='RecursWeekly' ||  
                                    recType=='RecursMonthly' || recType=='RecursMonthlyNth'){ valAddDays=1;}
                                else{valAddDays=-1;} 
                                //add days based on the valAddDays
                                adt= adt.addDays(valAddDays);
                            }
                            
                            //set ActivityDateTime__c
                            DateTime sti = t.ActivityDateTime__c;
                            //create start date time                     
                            DateTime startDateTime = Datetime.newInstance(adt.year(), adt.month(), adt.day(), sti.hour(), sti.minute(), 0);
                            //assign startDateTime in ActivityDateTime__c
                            t.ActivityDateTime__c = startDateTime;
                            //assign EndDate__c in eti
                            DateTime eti = t.EndDate__c;
                            //declare variable
                            DateTime endDateTime;
                            //calculate the time difference                    
                            integer diff =sti.date().daysBetween(eti.date());
                            //check start date and end date not equal
                            if (sti.date()!=eti.date()){
                                //add days in adt
                                adt= adt.addDays(diff);
                            }
                            //create end date time
                            endDateTime = Datetime.newInstance(adt.year(), adt.month(), adt.day(), eti.hour(), eti.minute(), 0);
                            //assign endDateTime in EndDate__c
                            t.EndDate__c = endDateTime;
                        }
                        else
                        {
                            //assign ActivityDateTime__c in dt
                            DateTime dt = t.ActivityDateTime__c;
                            //create the date and assign in ActivityDate
                            t.ActivityDate = Date.newInstance(dt.year(), dt.month(), dt.day());
                            //declare variable
                            Boolean isEnd = true;
                            //check EndDate__c is null
                            if(t.EndDate__c==null){
                                //assign ActivityDateTime__c in EndDate__c
                                t.EndDate__c=t.ActivityDateTime__c;
                                //set isEnd to false
                                isEnd= false;
                            }                    
                            //check if task inbetween holidays then raise a error
                            updateActivityInTaskHelper.checkHoliday(t,listHoliday);
                            //check if user is on PTO inbetween task then raise a error
                            updateActivityInTaskHelper.checkPTO(t,listPTOTask);
                            //check if task startdatetime or enddatetime not overlap inbetween business hours e.g. 8 AM to 6 PM, then raise a error
                            updateActivityInTaskHelper.compareBusinessHours(t,isEnd);
                            //check if task assign to System Admin
                            updateActivityInTaskHelper.validateUserAssignment(t, lstUser);
                        }
                    }
                    else if(t.ActivityDate==null && t.ActivityDateTime__c!=null && !t.IsRecurrence){
                        //assign ActivityDateTime__c in dt
                        DateTime dt = t.ActivityDateTime__c;
                        //create date and assign into ActivityDate
                        t.ActivityDate = Date.newInstance(dt.year(), dt.month(), dt.day());
                        //declare variable
                        Boolean isEnd = true;
                        //check EndDate__c is equal to null
                        if(t.EndDate__c==null){
                            //assign ActivityDateTime__c in EndDate__c
                            t.EndDate__c=t.ActivityDateTime__c;
                            //set isEnd = false
                            isEnd= false;
                        }
                        //check if task inbetween holidays then raise a error
                        updateActivityInTaskHelper.checkHoliday(t,listHoliday);
                        //check if user is on PTO inbetween task then raise a error
                        updateActivityInTaskHelper.checkPTO(t,listPTOTask);
                        //check if task startdatetime or enddatetime not overlap inbetween business hours e.g. 8 AM to 6 PM, then raise a error
                        updateActivityInTaskHelper.compareBusinessHours(t,isEnd);
                        //check if task assign to System Admin
                        updateActivityInTaskHelper.validateUserAssignment(t, lstUser);
                    }
                    //end: code block for beforeInsert
                }
                catch(exception ex){ ApexDebugLogController.insertLog('updateActivityInTask trigger', 'beforeInsert', ex.getMessage(), ex.getLineNumber()); }
            }
            else if (Trigger.isUpdate) {
                try{
                    //start: code block for beforeUpdate
                    //check ActivityDateTime__c not null and IsRecurrence=false
                    if(t.ActivityDateTime__c!=null && !t.IsRecurrence){
                        //assign ActivityDateTime__c in dt
                        DateTime dt = t.ActivityDateTime__c;
                        //create date and assign in ActivityDate
                        t.ActivityDate = Date.newinstance(dt.year(), dt.month(), dt.day());
                        //declare variable
                        Boolean isEnd = true;
                        //check EndDate__c is equal to null
                        if(t.EndDate__c==null){
                            //assign ActivityDateTime__c in EndDate__c
                            t.EndDate__c=t.ActivityDateTime__c;
                            //set isEnd = false
                            isEnd= false;
                        } 
                        //skip validation for existing Task, if  Skip_Validation_For_Trigger__c=false. This value coming from Trg_SalesPlanner_Helper and SalesPlannerHistoryController
                        if (!t.Skip_Validation_For_Trigger__c){
                            //check if task inbetween holidays then raise a error
                            updateActivityInTaskHelper.checkHoliday(t,listHoliday);
                            //check if user is on PTO inbetween task then raise a error
                            updateActivityInTaskHelper.checkPTO(t,listPTOTask);
                            //check if task startdatetime or enddatetime not overlap inbetween business hours e.g. 8 AM to 6 PM, then raise a error
                            updateActivityInTaskHelper.compareBusinessHours(t,isEnd);
                            //check if task assign to System Admin
                            updateActivityInTaskHelper.validateUserAssignment(t, lstUser);
                        }
                        //check Skip_Validation_For_Trigger__c=true
                        if (t.Skip_Validation_For_Trigger__c){
                            //set Skip_Validation_For_Trigger__c = false
                            t.Skip_Validation_For_Trigger__c =!t.Skip_Validation_For_Trigger__c;
                        }
                    }
                    //end: code block for beforeUpdate
                }
                catch(exception ex){ ApexDebugLogController.insertLog('updateActivityInTask trigger', 'beforeUpdate', ex.getMessage(), ex.getLineNumber());}
            }
        }
    }
}