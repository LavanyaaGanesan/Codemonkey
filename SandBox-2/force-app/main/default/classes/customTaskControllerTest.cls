/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Test Class for Shiptodata class.
* @Change:  
* @last modify by:   Archie Bisen
* @last modify date:  13-Jan-2020
* *************************************************************** */
@isTest
public class customTaskControllerTest {
    public static Account acc;
    public static Contact con;
    public static void setupData(){
         //create an account record and insert it
        acc = new Account(Name = 'TestAcc');
        insert acc;
         //create an contact record and insert it
        con = new Contact(FirstName= 'TestCont',LastName = 'LName',AccountId = acc.id);
        insert con;
	}
    
	@isTest static void TestMethod1(){
        setupData();
        Test.StartTest();
         //create new account list
        List<Sobject> accListTemp = new List<Sobject>();
        accListTemp.add(acc);
        //provide salesplanner data and insert it
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
        insert sp;
         //create new contact lists to provide values to the parameters in methods of the class
        List<Sobject> contList = customTaskController.fetchLookUpValues('General', 'contact', false);
        List<Sobject> contList1 = customTaskController.fetchLookUpValues('Vivotif', 'user', false);
        List<Sobject> contList2 = customTaskController.fetchLookUpValues('Vivotif', 'user', true);
        
        List<Sobject> contListfl = customTaskController.fetchLookUpMultiSelectValues('TestCont LName','Contact',accListTemp,null);
        List<Sobject> contListfl1 = customTaskController.fetchLookUpMultiSelectValues('TestCont LName','Contact',accListTemp,sp.Id);
        
        List<Sobject> contListMulti = customTaskController.fetchLookUpMultiSelectValuesWithIds('Contact',con.Id,acc.Id);
        
        List<Sobject> contListLookUp = customTaskController.selectedLookUpValues(con.Id,'Contact');
        List<Sobject> contListLookUp1 = customTaskController.selectedLookUpValues(UserInfo.getUserId(),'User');
        List<Sobject> contListLookUp2 = customTaskController.selectedLookUpValues(sp.Id,'sales_planner__c');
        List<Sobject> contListLookUp3 = customTaskController.selectedLookUpValues(acc.Id,'Account');
        
        List<String> contListfetch = customTaskController.fetchListViews('Sales_Data__c');
        String[] picklistValues = customTaskController.picklist_values('Sales_Planner__c', 'Account_Stage__c');
        //Provide start and end date and start and end time
        String myDtString;
        String timestart = '2016-09-02 09:15:26';
        Datetime dt = Datetime.valueOf(timestart);
        String timeend = '2016-09-03 09:15:26';
        Datetime dte = Datetime.valueOf(timeend);
        
        
        //craete a new task record and insert it
        Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task',ActivityDate = system.today().addDays(2),EndDate__c=dte,whatId = sp.Id,WhoId=con.Id,OwnerId=UserInfo.getUserId(),ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
        insert newTask;
        String objId = customTaskController.createTask(newTask);
        boolean boolValue = customTaskController.deleteTask(newTask.Id);
        Test.StopTest();
	}
    
    @isTest static void TestMethod2(){
        setupData();
        //create new account list
        List<Sobject> accListTemp = new List<Sobject>();
        accListTemp.add(acc);
        //provide salesplanner data and insert it
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
                insert sp;
          //Provide start and end date and start and end time
               String myDtString;
        String timestart = '2016-09-02 09:15:26';
        Datetime dt = Datetime.valueOf(timestart);
        String timeend = '2016-09-03 09:15:26';
        Datetime dte = Datetime.valueOf(timeend);
        
        
  //create a new task record and insert it        
        Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',Status='Open',ActivityDate = system.today().addDays(2),whatId = sp.Id,OwnerId=UserInfo.getUserId(),ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
        insert newTask;
        Test.StartTest();
        Task tsk = customTaskController.getTask(newTask.Id);
        Test.StopTest();
	}
   
    @isTest static void TestMethod3(){
        setupData();
        //create new account list
        List<Sobject> accListTemp = new List<Sobject>();
        accListTemp.add(acc);
         //provide salesplanner data and insert it
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
                insert sp;
        
        //create a new tasks record  
        Task newTask = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=null,RecurrenceDayOfWeekMask=null,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursDaily',TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,OwnerId=UserInfo.getUserId(),Call_Stage__c='Disease/Product Introduction',ActivityDateTime__c=system.today().addDays(2),EndDate__c=system.today().addDays(4),ReminderDateTime=system.today().addDays(2),Product_Discussed__c='Vivotif',Resources_Left__c='MMWR',Description='Test Completed');
		Task newTask1 = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=null,RecurrenceDayOfWeekMask=16,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursWeekly',TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,OwnerId=UserInfo.getUserId(),Call_Stage__c='Disease/Product Introduction',ActivityDateTime__c=system.today().addDays(2),ReminderDateTime=system.today().addDays(2),Product_Discussed__c='Vivotif',Resources_Left__c='MMWR',Description='Test Completed');
        Task newTask2 = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=1,RecurrenceDayOfWeekMask=null,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursMonthly',TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,OwnerId=UserInfo.getUserId(),Call_Stage__c='Disease/Product Introduction',ActivityDateTime__c=system.today().addDays(2),ReminderDateTime=system.today().addDays(2),Product_Discussed__c='Vivotif',Resources_Left__c='MMWR',Description='Test Completed');
        Task newTask3 = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=null,RecurrenceDayOfWeekMask=16,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursEveryWeekday',TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,OwnerId=UserInfo.getUserId(),Call_Stage__c='Disease/Product Introduction',ActivityDateTime__c=system.today().addDays(2),ReminderDateTime=system.today().addDays(2),Product_Discussed__c='Vivotif',Resources_Left__c='MMWR',Description='Test Completed');
        Task newTask4 = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=1,RecurrenceDayOfWeekMask=null,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursMonthlyNth',TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,OwnerId=UserInfo.getUserId(),Call_Stage__c='Disease/Product Introduction',ActivityDateTime__c=system.today().addDays(2),ReminderDateTime=system.today().addDays(2),Product_Discussed__c='Vivotif',Resources_Left__c='MMWR',Description='Test Completed');
        //insert newTask;
        Test.StartTest();
        Task tsk = customTaskController.createTaskObject(newTask);
        Task tsk1 = customTaskController.createTaskObject(newTask1);
        Task tsk2 = customTaskController.createTaskObject(newTask2);
        Task tsk3 = customTaskController.createTaskObject(newTask3);
        Task tsk4 = customTaskController.createTaskObject(newTask4);
        Test.StopTest();
	}
}