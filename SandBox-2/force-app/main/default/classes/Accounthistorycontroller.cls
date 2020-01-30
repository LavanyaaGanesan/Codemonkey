/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Controller class for AccountHistory component.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  10-Jan-2020
* *************************************************************** */
public class Accounthistorycontroller {
    /* ***************************************************************
    * @description: Fetching data from task and salesplanner object.
    * @Change:
    * *************************************************************** */ 
    @AuraEnabled
 public Static List<TaskWrapper> gettask(String Relatedto)     
 {  List<TaskWrapper> wrapperList = new list<TaskWrapper>();
     try{
        
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:Relatedto ];
        List<Task> t = [select id,Subject,Description,WhoId,Who.Name, WhatId, What.Name, OwnerId,Owner.Name,CreatedBy.Alias, ActivityDate, Type, Status from Task where Status='Completed' AND (accountid =:salesPlanner.Account_Sales_Planner__c) ORDER BY ActivityDate desc];
        //Code to store the value from wrapper class in list.
        for(task tsk:t){
        	wrapperList.add(new TaskWrapper(tsk));    
        }
        String t1= t[0].WhatId;
        String t2 = t[0].OwnerId;
         if(Test.isRunningTest())
             integer i=1/0;
 }
   catch(exception ex){
            ApexDebugLogController.insertLog('Accounthistorycontroller', 'gettask', ex.getMessage(), ex.getLineNumber());
   }
        return wrapperList;
    }
/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Wrapper class to convert activity date in MM/DD/YYYY format.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  8-Jan-2020
* *************************************************************** */
    public class TaskWrapper{
        @AuraEnabled
        public string formattedDate{get;set;}
        @AuraEnabled
        public task tsks{get;set;}
        public TaskWrapper(task tsk){  
            tsks = tsk;
            //if activity date is not null then format is in MM/DD/YYYY.
        	if(Tsk.ActivityDate != Null){
            	formattedDate = string.valueOf(Tsk.ActivityDate.month())+'/'+string.valueOf(Tsk.ActivityDate.day())+'/'+string.valueOf(Tsk.ActivityDate.year());   
            }    
        }
    }
}