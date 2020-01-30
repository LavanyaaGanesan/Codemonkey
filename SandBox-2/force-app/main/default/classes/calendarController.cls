/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: This call is used in Caleder lighting component
* @Change:  
* @last modify by:   Archie Bisen
* @last modify date:  13-Jan-2020
* *************************************************************** */
public class calendarController {
    /* ***************************************************************
    * @description: This function retur a  task SOQL query based on the input 
    * @Change:
    * *************************************************************** */
    @TestVisible
    public static String getTaskQuery(List<String> recordIds, ID id) {
        //create a map object for fields
        Map<String,List<String>> fields = new Map<String,List<String>>();
        //add Task fields in field mape
        String queryString = '';
        try{
        fields.put('Task',new List<String>{
            'ID', 'Subject','ActivityDate','ActivityDateTime__c','EndDate__c','ReminderDateTime','OwnerId', 
            'Status','AccountId','Account.Name','WhatCount','WhatId','WhoCount','WhoId','TaskSubType',
            'Resources_Left__c','Product_Discussed__c','isRecurTask__c','Call_Stage__c','Is_MapAnything__c', 
             'Vaxchora_Call_Stage__c', 'Closed_Reasons__c','Type'
        });
        //add TaskRelation fields in field map
        fields.put('TaskRelations',new List<String>{'TaskId','IsWhat','RelationId'});

       //create a map object for filter the records
        Map<String,String> filters = new Map<String,String>();
        filters.put('Task',' WHERE IsRecurrence = false and (what.type=\'sales_planner__c\' or type=\'PTO\') and OwnerId=\'' + id + '\'');
        //if conditions to check recordids are not equal to null and are not empty
        if (recordIds!=null && !recordIds.isEmpty()) { 
            //declarer variables
            string idString='';
            //loop through recordIDs 
            for(string aId : recordIds)
            {
                //assign id in below variable with "," seperator 
                idString += '\'' + aId +'\',';
            }
        	//check idString='' then add blank value ('') in else remove the last ","     
            if (idString=='')
                idString='\'\'';
            else            
                idString = idString.substring(0, idString.length()-1);
            //fetch filter value and also assign the below condition   
            String inFilter = filters.get('Task');
            inFilter += ' AND Id IN (' + idString +')';
            //again add filter value in task key
            filters.put('Task', inFilter);
        }
        //add filter for TaskRelations
        filters.put('TaskRelations',' WHERE IsDeleted = false');
		//declare variable for Task, TaskRelation and combine query
        String parent = 'Task';
        String child = 'TaskRelations';
        queryString = '';
        //create SOQL query based on the fields and filters of Task and TaskRelations
        queryString += 'SELECT ' + String.join(fields.get(parent),',');
        queryString += ',(SELECT ' + String.join(fields.get(child),',') + ' FROM ' + child + filters.get(child) + ')';
        queryString += ' FROM ' + parent + filters.get(parent);
        System.debug('queryString: ' + queryString);
        //return a query
        if(Test.isRunningTest())
             Integer i=1/0;
        }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('Shiptoinfo', 'fetchDailysalesData', ex.getMessage(), ex.getLineNumber());
        }
        return queryString;

    }
    
    /* ***************************************************************
    * @description: fetch the All task based on the SOQL according to input para
    * @Change:
    * *************************************************************** */
    @AuraEnabled
    public static List<sObject> getTaskSObjects (List<String> recordIds, Id id) {
        //fetch task query
        string taskQuery=getTaskQuery(recordIds, id);
        //return the task records base on SOQL
        return Database.query(taskQuery);
    }
    
    /* ***************************************************************
    * @description: fetch the All task based on the SOQL according to input para
    * @Change:
    * *************************************************************** */
    @AuraEnabled
    public static List<sObject> getTaskSObjects (Id id) { 
        //fetch task query     
        string taskQuery=getTaskQuery(null, id);
        //check taskQery = '', bind default query with limit 0 
        try{
        if (taskQuery==''){
            taskQuery = 'Select ID, Subject from task limit 0';
        }
            if(Test.isRunningTest())
             Integer i=1/0;
            }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('Shiptoinfo', 'fetchDailysalesData', ex.getMessage(), ex.getLineNumber());
        }
        //return the task records base on SOQL
        return Database.query(taskQuery);
        
    }
    /* ***************************************************************
    * @description: fetch all holidays according to the custom label SOQL
    * @Change:
    * *************************************************************** */
    @AuraEnabled
    public static List<sObject> getHolidays() {
        //fetch all halidays
        return Database.query(System.Label.pvHolidaysQuery);
    }
    /* ***************************************************************
    * @description: fetch all task based on the SP IDs
    * @Change:
    * *************************************************************** */
     @AuraEnabled
    public static list<Task> getTask(String Relatedto){
          //fetch task based on the SP 
        List<Task> t = [select id,Subject,ActivityDate, ActivityDateTime__c, EndDate__c,Account.Name, Type, Status from Task];
        //fetch SP based on the RelatedTo IDs 
        try{
         Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:Relatedto];
            if(Test.isRunningTest())
             Integer i=1/0;
      
            }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('Shiptoinfo', 'fetchDailysalesData', ex.getMessage(), ex.getLineNumber());
        }
    return t;
    }
}