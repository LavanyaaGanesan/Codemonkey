/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Test Class for Shiptodata class.
* @Change:  
* @last modify by:   Archie Bisen
* @last modify date:  10-Jan-2020
* *************************************************************** */
@istest
 /* ***************************************************************
    * @description: test class for testing the task creation
    * @Change:
    * *************************************************************** */
public class createTaskhelperTest {
    @istest static void testcreateTaskHelper(){
        
        //create a record for account
        Account acc = new Account(Name = 'TestAcc');
        insert acc;
         Account acc1 = new Account(Name = 'TestAcc');
        insert acc1;
        //create a record for contact
        Contact con = new Contact(FirstName= 'TestCont',LastName = 'LName',AccountId = acc.id);
        insert con;

        String myDtString;
        String timestart = '2016-09-02 09:15:26';
        Datetime dt = Datetime.valueOf(timestart);
        String timeend = '2016-09-03 09:15:26';
        Datetime dte = Datetime.valueOf(timeend);
        
        Test.StartTest();
        //Create a record of SalesPlanner
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
        insert sp;
       
        Sales_Planner__c sp1 = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc1.Id,Sales_Planner_Year__c='2020');
        insert sp1;
        
        //create a new task
        Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',ActivityDate = system.today().addDays(2),
                                whatId = sp.Id,OwnerId=UserInfo.getUserId(), Status='Open',
                                ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
        insert newTask;
        
       /* Task newTask2 = new Task(IsRecurrence = true, CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=null,RecurrenceDayOfWeekMask=null,
                                 RecurrenceEndDateOnly=system.today().addDays(4),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,
                                 RecurrenceInterval=1,RecurrenceMonthOfYear=null,RecurrenceTimeZoneSidKey='America/Los_Angeles',
                                 RecurrenceType='RecursDaily',TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,
                                 OwnerId=UserInfo.getUserId(),Call_Stage__c='Disease/Product Introduction',
                                 Status='Open',ActivityDateTime__c=system.today().addDays(2));
        insert newTask2;*/
        
        //create a new task record
		List<Task> newTask3 = [select id from Task where id =:newTask.id];
		system.assertEquals(1,newTask3.size());
		//insert the data for all neccessary fields
        Task newTask1 = [select id from Task where id =:newTask.id];        
        newTask1.Subject = 'test sub Update';
        newTask1.ActivityDate = system.today().addDays(15);
        newTask1.OwnerId=UserInfo.getUserId();
        newTask1.WhoId=con.Id;
        newTask1.WhatId=sp.Id;
        newTask1.Description='sub updated';
        newTask1.ReminderDateTime=system.today().addDays(5);
        newTask1.IsReminderSet = true;
        newTask1.CreateEventWhenTaskCreated__c = true;
        newTask1.ActivityDateTime__c=dt;
		newTask1.WhatId=sp1.Id;
        newTask1.Call_Stage__c='Disease/Product Introduction';
        //Add all fields which we check in helper class		
        
        update newTask1;
        
        Test.StopTest();
    }
     /* ***************************************************************
    * @description: test class for creating the task with different data set to check validations
    * @Change:
    * *************************************************************** */
    @isTest static void testMethod1(){
    List<Account> accounts = new List<Account>{
        //create a record for account
        new Account( Name = 'MyTestAccount' ) };
        insert accounts;
        
                String myDtString;
        String timestart = '2016-09-02 09:15:26';
        Datetime dt = Datetime.valueOf(timestart);
        String timeend = '2016-09-03 09:15:26';
        Datetime dte = Datetime.valueOf(timeend);
        
        Test.StartTest();
        //insert salesplanner with relevant data
            Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=accounts.get(0).Id,Sales_Planner_Year__c='2020');
            insert sp;
            
        //create tasks with different details to test combination of scenarios
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
                                ActivityDateTime__c=dt,
                                TaskSalesplannerDetails__c='Address',
                               Description='Test Completed');
        
        Task newTask2 = new Task(Ownerid = UserInfo.getUserId(),CreateEventWhenTaskCreated__c = true,
                                Subject='Test task',ActivityDate = system.today().addDays(2),whatId = sp.Id,
                                Status='Completed', Product_Discussed__c='Vivotif and Vaxchora ',
                                Call_Stage__c='Meaningful Dialogue',
                                Vaxchora_Call_Stage__c='Meaningful Dialogue',
                                Resources_Left__c='IDSA Guide',
                                ActivityDateTime__c=dt,
                                TaskSalesplannerDetails__c='Address',
                               Description='Test Completed');
        insert newTaskOpen;
        insert newTask;
        insert newTask1;
        insert newTask2;
        
        //delete the tast for checking delete functionality
        	delete newTask;
    	Test.StopTest();
    }
}