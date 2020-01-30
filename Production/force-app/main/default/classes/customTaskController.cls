public with sharing class customTaskController {
    
    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String ObjectName, Boolean getAll) {
        String searchKey = '\'' + searchKeyWord + '%\'';
        String activeKey = 'Yes';
        Boolean isActive = true;               
        
        List <sObject> returnList = new List <sObject>();
        
        String sQuery ='SELECT Id, Name FROM ';
        if (ObjectName.toLowerCase()=='contact'){
            sQuery = sQuery + ObjectName + ' where Name LIKE ' +  searchKey  + ' and AccountId in (Select id from account) limit 5'; 
            //sQuery = sQuery + ObjectName + ' where Name LIKE :searchKey and AccountId in (Select id from account where Active__c=:activeKey) limit 5'; 
        }
        else if (ObjectName.toLowerCase()=='user'){  
            if (!getAll){
                id loggedInUser=UserInfo.getUserId(); 
                string idString='\'00e61000000cYcvAAE\',\'00e61000000Z6ykAAC\'';
                sQuery = sQuery + ObjectName + ' where UserType=\'Standard\' and (id =\'' + loggedInUser + '\' or ProfileID in ('+ idString +')) and IsActive =' + isActive + 
                    ' and Name LIKE '+ searchKey +' limit 5';
                //System.debug('User sQuery :: ' + sQuery);
                
                /*
                set<Id> roleIDs = new set<Id>();
                roleIDs=utilities.getMyChildRoles(UserInfo.getUserRoleId());
                string idString='';
                for(ID ids : roleIDs)
                {
                    idString += '\'' + ids +'\',';
                }
                if (idString=='')
                    idString='\'\''; 
                else            
                    idString = idString.substring(0, idString.length()-1);
                
                sQuery = sQuery + ObjectName + ' where UserType=\'Standard\' and (id =\'' + loggedInUser + '\' or Managerid =\'' + loggedInUser +
                    '\' or UserRoleID in ('+ idString +')) and IsActive =' + isActive + 
                    ' and Name LIKE '+ searchKey +' limit 5'; */
            }
            else
            {
                sQuery = sQuery + ObjectName + ' where UserType=\'Standard\' and IsActive =' + isActive + 
                    ' and Name LIKE '+ searchKey +' limit 5';
            }
        }
        else{
            sQuery = sQuery + ObjectName + ' where Name LIKE ' + searchKey +' limit 5';
        }  
        System.debug('fetchLookUpValues Query :' + sQuery);
        List <sObject> lstOfRecords = Database.query(sQuery);
        System.debug('fetchLookUpValues lstOfRecords :' + lstOfRecords);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List < sObject > fetchLookUpMultiSelectValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList, String AccountId) {
        String searchKey = '\'' + searchKeyWord + '%\'';
        List <sObject> returnList = new List <sObject>();
        
        string idString='';
        for(sObject item : ExcludeitemsList)
        {
            idString += '\'' + item.id +'\',';
        }
        if (idString=='')
            idString='\'\'';
        else            
            idString = idString.substring(0, idString.length()-1);
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery = '';
        if (AccountId!=null && AccountId!=''){
            List<Sales_Planner__c> objSalesPlanner = [Select Account_Id__c from sales_planner__c where Id=:AccountId limit 1];
            AccountId = objSalesPlanner[0].Account_Id__c;
            //sQuery ='select id, Name from ' + ObjectName + ' where AccountId=:AccountId and  Name LIKE: searchKey AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
            sQuery ='select id, Name from ' + ObjectName + ' where AccountId =\''+ AccountId + 
                '\' and  Name LIKE '+ searchKey +
                ' AND Id NOT IN ('+ idString +') order by createdDate DESC limit 5';
        }
        else{
            AccountId='';
            sQuery ='select id, Name from ' + ObjectName + 
                ' where AccountId!=\''+AccountId +'\' and Name LIKE '+ searchKey + 
                ' AND Id NOT IN ('+ idString +') order by createdDate DESC limit 5';
        }
        System.debug('MultiSelect Query : ' + sQuery);
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List <sObject> fetchLookUpMultiSelectValuesWithIds(String ObjectName,string Ids, String AccountId) {
        List <sObject> returnList = new List <sObject>();
        
        String[] aIds = Ids.split(',');
        List<string> lstExcludeitems = new List<string>();
        for(string aId : aIds ){
            lstExcludeitems.add(aId);
        }  
        string idString='';
        for(string aId : aIds)
        {
            idString += '\'' + aId +'\',';
        }
        if (idString=='')
            idString='\'\'';
        else            
            idString = idString.substring(0, idString.length()-1);
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery = '';
        if (AccountId!=null && AccountId!=''){
            List<sales_planner__c> objSalesPlanner = [Select Account_Id__c from sales_planner__c where Id=:AccountId limit 1];
            if (objSalesPlanner.size()>0)
                AccountId = objSalesPlanner[0].Account_Id__c;
            sQuery ='select id, Name from ' + ObjectName + ' where AccountId=\''+AccountId +'\'  AND Id IN ('+ idString +')';
            //sQuery ='select id, Name from ' + ObjectName + ' where AccountId=:AccountId  AND Id IN : lstExcludeitems';
        }
        System.debug('MultiSelect Query with IDs : ' + sQuery);
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List <sObject> selectedLookUpValues(Id id, String ObjectName) {        
        System.debug('ID : ' + id + ', Object Name : ' + ObjectName);
        Boolean isActive=true;
        String activeKey='Yes';
        
        List <sObject> returnList = new List <sObject>();
        
        String sQuery ='SELECT Id, Name FROM ';
        if (ObjectName.toLowerCase()=='contact'){
            sQuery = sQuery + ObjectName + ' where  AccountId in (Select id from account) limit 1'; 
            //sQuery = sQuery + ObjectName + ' where  AccountId in (Select id from account where Active__c=:activeKey) limit 1'; 
        }
        else if (ObjectName.toLowerCase()=='user'){    
            sQuery = sQuery + ObjectName + ' where Id =\'' + id +'\' and IsActive ='+ isActive + ' limit 1'; 
            //sQuery = sQuery + ObjectName + ' where Id =:id and IsActive =:isActive limit 1'; 
        }        
        else if (ObjectName.toLowerCase()=='sales_planner__c'){
            String shortId = String.valueOf(id).substring(0, 15);
            System.debug('selectedLookUpValues :: Short ID' + shortId +', ID :' + id);
            sQuery = sQuery + ObjectName + ' where Id =\'' + id +'\'  or Account_ID__c=\'' + shortId +'\' limit 1';
        } 
        else{
            sQuery = sQuery + ObjectName + ' where Id =\'' + id +'\' limit 1';
        } 
        System.debug('sQuery : ' +sQuery);
        
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static String getAccountNameBasedOnSPId(Id SPId) {
        string accountName='';
        List<Sales_Planner__c> spList = [SELECT ID, Account_Name__C From Sales_Planner__c where id =: SPId limit 1];
        if (spList!=null && spList.size()>0){
            accountName = spList[0].Account_Name__C;
        }
        return accountName;
    }
    
    @AuraEnabled
    public static list<String> fetchListViews(String strObjName) {
        list<String> lstListViews = new list<String>();
        if(strObjName != null && strObjName !=  ' ' && strObjName.length() != 0) {            
            list<ListView> lstViews = [Select DeveloperName,sobjectType From ListView where SobjectType =: strObjName order by Name];
            for(ListView iterator:lstViews) {
                lstListViews.add(iterator.DeveloperName);
            }
        }   
        return lstListViews;
    }
    
    @AuraEnabled
    public static Task getTask(Id taskId){
        Map<String,List<String>> fields = new Map<String,List<String>>();
        //SELECT 'Id','OwnerId', 'Subject', 'Description', 'ActivityDate', 'Type', 'Status',  
        //'WhoId', 'WhatId', 'WhoCount', 'WhatCount',  'IsClosed', 'CallType', 'CallDisposition', 
        // 'Product_Discussed__c', 'Resources_Left__c', RecurrenceType FROM Task
        fields.put('Task',new List<String>{
            'Id','OwnerId', 'Subject', 'Description', 'ActivityDate','ActivityDateTime__c','EndDate__c', 'Type', 'Status',
                'WhoId', 'WhatId', 'WhoCount', 'WhatCount',  'IsClosed',
                'Product_Discussed__c', 'Resources_Left__c', 'IsRecurrence','Priority','Is_MapAnything__c', 
                'RecurrenceType','isRecurTask__c','Call_Stage__c','Vaxchora_Call_Stage__c','Closed_Reasons__c'
                });
        fields.put('TaskRelations',new List<String>{'TaskId','IsWhat','RelationId'});
        
        Map<String,String> filters = new Map<String,String>();
        filters.put('Task',' WHERE IsRecurrence = false');
        if (taskId != null) {
            String inFilter = filters.get('Task');
            inFilter += ' AND Id =\''+taskId +'\'' ;
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
        return Database.query(queryString);
    }
    
    @AuraEnabled
    public static String[] picklist_values(String object_name, String field_name) {
        String[] values = new String[]{};
            String[] types = new String[]{object_name};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        return values;
    }
    @AuraEnabled
    public static String createTaskMapAnything(Task taskForm){
        System.debug('taskForm' + taskForm);
        return 'test';
    }
    
    @AuraEnabled
    public static String createTask(Task taskForm){
         
        String ptoCheck =checkPTOAvailable(taskForm);
        String nonPtoCheck =checkNonPTOAvailable(taskForm);
        if (ptoCheck.indexOf('PTOEXIST')>-1){
            return ptoCheck;
        }
        else{
            //Create New Task object from the Lightning Task object 
            Task objTask = createTaskObject(taskForm);
            
            List<Contact> contactList = new List<Contact>();
            
            //if (taskForm.WhoId!=null && taskForm.WhoId!=''){
            String[] conts= String.valueOf(TaskForm.WhoId).split(';'); 
            if (conts.size()>0){
                String IDs ='';
                for(Integer i=0;i<conts.size();i++){
                    IDs+= '\''  + conts[i].trim() + '\'' + (i!=conts.size()-1? ',' : '');
                }        
                String Query= 'select Id, name, accountid from Contact where Id in (' + IDs + ')' ;
                contactList = Database.query(Query); 
                system.debug('createTask:'+Query);
                if (contactList.size()>1){
                    objTask.WhoId = contactList[0].Id;
                }
            }
            else
            { 
                objTask.WhoId = taskForm.WhoId;
            }  
            //}
            
            Boolean up=false;
            if (objTask.Id!=null){
                up=true;
                update objTask;  
            }
            else{
                insert objTask;
            }
            
            //Insert Task Relation Data
            List<TaskRelation> listTRAll = [Select Id from TaskRelation where TaskId=:objTask.Id and IsWhat = false];
            delete listTRAll;  
            
            //Insert Task Relation Data
            if (contactList.size()>0){
                Integer c=0;
                for(Contact con : contactList){
                    TaskRelation tr = new TaskRelation();
                    tr.RelationId = con.Id;
                    tr.TaskId = objTask.Id;
                    tr.IsWhat = false;
                    insert tr;
                }
            }
            
            return 'SAVETASK ' + nonPtoCheck + '##' + objTask.Id;
        }
    }
    @AuraEnabled
    public static boolean deleteTask(id taskId){
        Task obj = [Select id, subject from Task where id=:taskId limit 1];
        //System.debug('Delete Object : ' + obj);
        try {
            delete obj;
            return true;
        } catch (DmlException e) {
            System.debug('Exception : ' + e);
            return false;
        }
    }
    @TestVisible
    public static String checkPTOAvailable(Task t){
        if (t.Type=='PTO'){
            return 'PTO';
        }else{
            String query = 'Select ID, Subject from Task where ActivityDateTime__c<=\'' + t.ActivityDateTime__c  
                + '\' and  EndDate__c>=\'' + t.EndDate__c + '\'';
            //System.debug('checkPTOAvailable query : ' + query);
            /*List<Task> listT = [Select ID, Subject from Task where type='PTO' and 
                                 (  (ActivityDateTime__c >= :t.ActivityDateTime__c AND EndDate__c <= :t.EndDate__c)
									OR (ActivityDateTime__c >= :t.ActivityDateTime__c AND ActivityDateTime__c <= :t.EndDate__c AND EndDate__c >= :t.EndDate__c)
									OR (ActivityDateTime__c <= :t.ActivityDateTime__c AND EndDate__c >= :t.EndDate__c)
									OR (ActivityDateTime__c <= :t.ActivityDateTime__c AND EndDate__c >= :t.ActivityDateTime__c AND EndDate__c <= :t.EndDate__c))
                                and OwnerId=: t.OwnerId];*/
            List<Task> listT = [Select ID, Subject from Task where type='PTO' and 
                                 (	(ActivityDateTime__c<=:t.ActivityDateTime__c and  EndDate__c>=:t.ActivityDateTime__c)  
                                 or (ActivityDateTime__c<=:t.EndDate__c and  EndDate__c>=:t.EndDate__c))
                                and OwnerId=: t.OwnerId];
            
            //System.debug('checkPTOAvailable List : ' + listT);
            if (listT!=null && listT.size()>0)
                return 'PTOEXIST';
            else
                return 'PTO';
        }
    }
    
    @AuraEnabled
    public static String checkNonPTOAvailable(Task t){
        if (t.Type=='PTO'){
            return 'PTO';
        }else{   
            
            DateTime sdt = t.ActivityDateTime__c;
            System.debug('checkNonPTOAvailable Start : ' + t.ActivityDateTime__c);
            /*if (t.TaskSubtype!='Call'){
                sdt = sdt.addMinutes(1);
            }*/
            
            DateTime edt = t.EndDate__c;
            System.debug('checkNonPTOAvailable End : ' + t.EndDate__c);
            /*if (t.TaskSubtype!='Call'){
                edt = edt.addMinutes(-1);
            } */
            
            String sID = (t.Id!=null? string.valueOf(t.Id):'');            
            
            List<Task> listT = new List<Task>();
            if (t.TaskSubtype=='Call'){
                listT= [Select ID, Subject, Type from Task 
                        where Id !=: sID and 
                        ((ActivityDateTime__c=:sdt and EndDate__c=:sdt) or 
                         (ActivityDateTime__c=:edt and EndDate__c=:edt))
                        and OwnerId=: t.OwnerId];
            }
            else{
                listT= [Select ID, Subject, Type from Task 
                        where Id !=: sID and 
                        ((ActivityDateTime__c<=:sdt and EndDate__c>=:sdt) or 
                         (ActivityDateTime__c<=:edt and EndDate__c>=:edt))
                        and OwnerId=: t.OwnerId];
            }
            
            System.debug('checkPTOAvailable List : ' + listT);
            if (listT!=null && listT.size()>0)
            {
                for (Task cT : listT){
                    if (cT.Type=='PTO')
                    {
                        return 'PTOEXIST';
                    }
                }
                return 'TASKEXIST';
            }
            else
                return 'NOTASK';
        }
    }
    
    @TestVisible
    private static Task createTaskObject(Task tsk) {
        system.debug('Passed Task object' + tsk);
        Task obj = new Task(); 
        if (tsk.Id!=null){
            obj.Id = tsk.Id;
        }
        obj.Subject = tsk.Subject;
        obj.Description = tsk.Description;
        obj.Status = tsk.Status;
        obj.Type = tsk.Type;
        obj.OwnerId = tsk.OwnerId;
        
        if (tsk.WhatId!=null){
            obj.WhatId = tsk.WhatId;
        }
        
        if (tsk.TaskSubtype!=null){
            obj.TaskSubtype = tsk.TaskSubtype;
        }
        if (tsk.Is_MapAnything__c!=null){
            obj.Is_MapAnything__c = tsk.Is_MapAnything__c;
        }
        
        obj.CreateEventWhenTaskCreated__c=true;
        obj.Priority=((tsk.Priority!=null && tsk.Priority!='')?tsk.Priority:'Normal');
        
        if (tsk.ActivityDateTime__c	!= null){
            System.debug('ActivityDateTime__c : 22222' + tsk.ActivityDateTime__c);
            Datetime sDate = tsk.ActivityDateTime__c;
            sDate = DateTime.newInstance(sDate.year(), sDate.month(), 
                                         sDate.day(), sDate.hour(), 
                                         sDate.minute(),0);            
            System.debug('Change ActivityDateTime__c 1111 : ' + sDate);            
            obj.ActivityDateTime__c	 = sDate;
            
            DateTime dt = tsk.ActivityDateTime__c;
            tsk.ActivityDate = Date.newinstance(dt.year(), dt.month(), dt.day());
        }
        if (tsk.EndDate__c	!= null){
            //System.debug('EndDate__c : ' + tsk.EndDate__c);
            Datetime eDate = tsk.EndDate__c;
            eDate = DateTime.newInstance(eDate.year(), eDate.month(), 
                                         eDate.day(), eDate.hour(), 
                                         eDate.minute(),0);            
            //System.debug('Change EndDate__c  : ' + eDate);  
            obj.EndDate__c	 = eDate;
        } 
        
        obj.Product_Discussed__c = tsk.Product_Discussed__c;
        if(tsk.Status=='Completed'){
            obj.Resources_Left__c = tsk.Resources_Left__c;
            obj.Call_Stage__c = tsk.Call_Stage__c;
            obj.Vaxchora_Call_Stage__c = tsk.Vaxchora_Call_Stage__c;
            obj.Closed_Reasons__c = null;
            /*if (obj.Product_Discussed__c!='Vivotif'){
obj.Call_Stage__c = tsk.Call_Stage__c;
obj.Closed_Reasons__c = null;
} else
{
obj.Call_Stage__c = tsk.Call_Stage__c;
obj.Closed_Reasons__c = null;
}*/
        }else{
            obj.Resources_Left__c = null;
            obj.Call_Stage__c = null;
            obj.Closed_Reasons__c = null;
        }        
        if (tsk.IsReminderSet){
            obj.IsReminderSet = tsk.IsReminderSet;
            obj.ReminderDateTime = tsk.ReminderDateTime;
        }
        if (!tsk.IsRecurrence){
            obj.ActivityDate = tsk.ActivityDate;
        }
        if (tsk.IsRecurrence){
            obj.isRecurTask__c=true;
            obj.IsRecurrence = tsk.IsRecurrence;
            obj.RecurrenceType = tsk.RecurrenceType;
            obj.RecurrenceType__c = tsk.RecurrenceType;
            
            obj.RecurrenceStartDateOnly = tsk.RecurrenceStartDateOnly;
            obj.RecurrenceEndDateOnly =  tsk.RecurrenceEndDateOnly;
            
            if (tsk.RecurrenceType=='RecursDaily'){
                obj.RecurrenceInterval = tsk.RecurrenceInterval;
            }
            else if (tsk.RecurrenceType=='RecursEveryWeekday'){
                obj.RecurrenceDayOfWeekMask = tsk.RecurrenceDayOfWeekMask;
            }
            else if (tsk.RecurrenceType=='RecursMonthly'){
                obj.RecurrenceInterval = tsk.RecurrenceInterval;
                obj.RecurrenceDayOfMonth = tsk.RecurrenceDayOfMonth;
            }
            else if (tsk.RecurrenceType=='RecursMonthlyNth'){
                obj.RecurrenceInterval = tsk.RecurrenceInterval;
                obj.RecurrenceInstance  = tsk.RecurrenceInstance;
                obj.RecurrenceDayOfWeekMask  = tsk.RecurrenceDayOfWeekMask;
            }
            else if (tsk.RecurrenceType=='RecursWeekly'){
                obj.RecurrenceInterval = tsk.RecurrenceInterval;
                obj.RecurrenceDayOfWeekMask  = tsk.RecurrenceDayOfWeekMask;
            }
        }  
        system.debug('New Task object' + tsk);
        return obj;        
    }
}