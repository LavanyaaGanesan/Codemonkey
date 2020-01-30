public class calendarController {
    
    @TestVisible
    public static String getTaskQuery(List<String> recordIds, ID id) {
        Map<String,List<String>> fields = new Map<String,List<String>>();
        fields.put('Task',new List<String>{
            'ID', 'Subject','ActivityDate','ActivityDateTime__c','EndDate__c','ReminderDateTime','OwnerId', 
            'Status','AccountId','Account.Name','WhatCount','WhatId','WhoCount','WhoId','TaskSubType',
            'Resources_Left__c','Product_Discussed__c','isRecurTask__c','Call_Stage__c','Is_MapAnything__c', 
             'Vaxchora_Call_Stage__c', 'Closed_Reasons__c','Type'
        });
        fields.put('TaskRelations',new List<String>{'TaskId','IsWhat','RelationId'});

        //SELECT Subject,StartDateTime,EndDateTime,IsAllDayEvent,Location,ShowAs,OwnerId,WhatCount,WhatId,
        //WhoCount,WhoId,(SELECT EventId,IsWhat,RelationId FROM EventRelations WHERE IsDeleted = false) 
        //FROM Event WHERE IsRecurrence = false AND IsChild = false AND 
        //Id IN {00Um0000003L8JPEA0} 
        //inFilter += ' AND Id =\''+taskId +'\'';
        //
        Map<String,String> filters = new Map<String,String>();
        filters.put('Task',' WHERE IsRecurrence = false and (what.type=\'sales_planner__c\' or type=\'PTO\') and OwnerId=\'' + id + '\'');
        if (recordIds != null && !recordIds.isEmpty()) {            
            string idString='';
            for(string aId : recordIds)
            {
                idString += '\'' + aId +'\',';
            }
            if (idString=='')
                idString='\'\'';
            else            
                idString = idString.substring(0, idString.length()-1);
                
            String inFilter = filters.get('Task');
            inFilter += ' AND Id IN (' + idString +')';
            filters.put('Task', inFilter);
        }
        filters.put('TaskRelations',' WHERE IsDeleted = false');

        String parent = 'Task';
        String child = 'TaskRelations';
        String queryString = '';
        queryString += 'SELECT ' + String.join(fields.get(parent),',');
        queryString += ',(SELECT ' + String.join(fields.get(child),',') + ' FROM ' + child + filters.get(child) + ')';
        queryString += ' FROM ' + parent + filters.get(parent);
        System.debug('queryString: ' + queryString);
        return queryString;

    }
    
    @AuraEnabled
    public static List<sObject> getTaskSObjects (List<String> recordIds, Id id) {
        System.debug('Task Query (getTaskSObjects) with  recordIds: ');
        string taskQuery=getTaskQuery(recordIds, id);
        System.debug('Task Query (getTaskSObjects) without  recordIds: ' + taskQuery);
        return Database.query(taskQuery);
    }
    
    // TODO: Make this dynamic
    @AuraEnabled
    public static List<sObject> getTaskSObjects (Id id) { 
        System.debug('Task Query (getTaskSObjects) with  null: ');       
        string taskQuery=getTaskQuery(null, id);
        System.debug('Task Query (getTaskSObjects) without  null: ' + taskQuery);
        return Database.query(taskQuery);
    }
    
    @AuraEnabled
    public static List<sObject> getHolidays() {
        return Database.query(System.Label.pvHolidaysQuery);
    }
    // to fetch the task list
     @AuraEnabled
    public static list<Task> getTask(String Relatedto){
        
         Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:Relatedto];
        List<Task> t = [select id,Subject,ActivityDate, ActivityDateTime__c, EndDate__c,Account.Name, Type, Status from Task];
    return t;
    }
}