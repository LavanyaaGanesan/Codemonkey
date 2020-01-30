/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Test Class for Shiptodata class.
* @Change:  
* @last modify by:   Archie Bisen
* @last modify date:  13-Jan-2020
* *************************************************************** */
@isTest
 /* ***************************************************************
    * @description: test class for creating the task in calendar to test different scenarios
    * @Change:
    * *************************************************************** */
public class calendarControllerTest{
    @isTest static void testMethod1(){
    List<Account> accounts = new List<Account>{
         //create an account record and insert it
        new Account( Name = 'MyTestAccount' ) };
        insert accounts;
        Test.StartTest(); 

        //Test coverage for getTaskQuery() method
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=accounts.get(0).Id,Sales_Planner_Year__c='2020');
        insert sp;
        
        //Provide start and end date and start and end time
         String myDtString;
        String timestart = '2016-09-02 09:15:26';
        Datetime dt = Datetime.valueOf(timestart);
        String timeend = '2016-09-03 09:15:26';
        Datetime dte = Datetime.valueOf(timeend);
        
        //create a new tasks record and insert them 
        Task newTaskOpen = new Task(Ownerid = UserInfo.getUserId(),CreateEventWhenTaskCreated__c = true,
                                Subject='Test task',ActivityDate = system.today().addDays(2),whatId = sp.Id,
                                Status='Open', 
                                ActivityDateTime__c=dt,
                                TaskSalesplannerDetails__c='Address');
        Task newTask = new Task(Ownerid = UserInfo.getUserId(),CreateEventWhenTaskCreated__c = true,
                                Subject='Test task',ActivityDate = system.today().addDays(2),whatId = sp.Id,
                                Status='Completed', Product_Discussed__c='Vivotif',
                                Call_Stage__c='Meaningful Dialogue',
                                Resources_Left__c='IDSA Guide',
                                ActivityDateTime__c=dt,
                                TaskSalesplannerDetails__c='Address',
                               Description='Test Completed');
        Task newTask1 = new Task(Ownerid = UserInfo.getUserId(),CreateEventWhenTaskCreated__c = true,
                                Subject='Test task',ActivityDate = system.today().addDays(2),whatId = sp.Id,
                                Status='Completed', Product_Discussed__c='Vaxchora',
                                Vaxchora_Call_Stage__c='Meaningful Dialogue',
                                Resources_Left__c='IDSA Guide',
                                ActivityDateTime__c=system.today().addDays(2),
                                TaskSalesplannerDetails__c='Address',
                               Description='Test Completed');
        
        Task newTask2 = new Task(Ownerid = UserInfo.getUserId(),CreateEventWhenTaskCreated__c = true,
                                Subject='Test task',ActivityDate = system.today().addDays(2),whatId = sp.Id,
                                Status='Completed', Product_Discussed__c='Vivotif and Vaxchora',
                                Call_Stage__c='Meaningful Dialogue',
                                Vaxchora_Call_Stage__c='Meaningful Dialogue',
                                Resources_Left__c='Vaxchora Flashcard',
                                ActivityDateTime__c=system.today().addDays(2),
                                TaskSalesplannerDetails__c='Address',
                                Description='Test Completed');
        insert newTaskOpen;
        insert newTask;
       // insert newTask1;
      //  insert newTask2;
      
        //create new task lists to provide values to the parameters in methods of the class
        List<String> taskLIst = new List<string>();
        taskLIst.add(newTask.id);
        String taskStr = calendarController.getTaskQuery(taskLIst,newTask.OwnerId);
        List<Sobject> sobjectList = calendarController.getTaskSObjects(taskLIst,newTask.OwnerId);
        List<Sobject> sobjList1 = calendarController.getTaskSObjects(newTask.OwnerId);
        List<Sobject> sobjHoliday = calendarController.getHolidays();
        List<Sobject> sobjRelTask = calendarController.getTask(string.valueOf(newTask2.WhatId));
        
       //create new lists to add task and events
        List<String> sobjecttypes = new List<String>();
        sobjecttypes.add('Event');
        sobjecttypes.add('Task');

        Test.StopTest();
    }
}