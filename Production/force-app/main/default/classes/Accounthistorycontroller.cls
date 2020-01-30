public class Accounthistorycontroller {

    @AuraEnabled
 public Static List<TaskWrapper> gettask(String Relatedto)     
    { 
        List<TaskWrapper> wrapperList = new list<TaskWrapper>();
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:Relatedto ];
        List<Task> t = [select id,Subject,Description,WhoId,Who.Name, WhatId, What.Name, OwnerId,Owner.Name,CreatedBy.Alias, ActivityDate, Type, Status from Task where Status='Completed' AND (accountid =:salesPlanner.Account_Sales_Planner__c) ORDER BY ActivityDate desc];
        for(task tsk:t){
        	wrapperList.add(new TaskWrapper(tsk));    
        }
        String t1= t[0].WhatId;
        String t2 = t[0].OwnerId;
        
        System.debug('SalePlanner:'+t1+',Owner:'+t2);
        return wrapperList;
    }
    
    public class TaskWrapper{
        @AuraEnabled
        public string formattedDate{get;set;}
        @AuraEnabled
        public task tsks{get;set;}
        public TaskWrapper(task tsk){  
            tsks = tsk;
        	if(Tsk.ActivityDate != Null){
            	formattedDate = string.valueOf(Tsk.ActivityDate.month())+'/'+string.valueOf(Tsk.ActivityDate.day())+'/'+string.valueOf(Tsk.ActivityDate.year());   
            }    
        }
    }
}