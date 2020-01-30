@isTest
public class test_updateActivityInTask_trg {
    public static Account acc;
    public static Contact con;
    public static void setupData(){
        acc = new Account(Name = 'TestAcc');
        insert acc;
        con = new Contact(FirstName= 'TestCont',LastName = 'LName',AccountId = acc.id);
        insert con;
	}
	@isTest     
    static void TestUpdateActivityInTask() {
        // Test data setup
        setupData();
        
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,
                                                   Sales_Planner_Year__c='2019');
        insert sp;        
            String myDtString;
        String timestart = '2016-09-02 09:15:26';
        Datetime dt = Datetime.valueOf(timestart);
        String timeend = '2016-09-03 09:15:26';
        Datetime dte = Datetime.valueOf(timeend);
        Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task',
                                ActivityDate = system.today().addDays(2),whatId = sp.Id,WhoId=con.Id,
                                OwnerId=UserInfo.getUserId(),EndDate__c=dte,
                                ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
        
        Task newTaskCom = new Task(CreateEventWhenTaskCreated__c = true,Status='Completed',Subject='Test task',
                                ActivityDate = system.today().addDays(2),whatId = sp.Id,WhoId=con.Id,
                                Product_Discussed__c=' Vivotif and Vaxchora',
                                OwnerId=UserInfo.getUserId(),Call_Stage__c='Meaningful Dialogue',
                                Vaxchora_Call_Stage__c='Meaningful Dialogue',EndDate__c=dte,
                                Resources_Left__c='IDSA Guide',Description='Test Completed',IsRecurrence=false,
                                ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
        
        Task newTask1 = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=null,RecurrenceDayOfWeekMask=16,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursWeekly',TaskIdReference__c=' ',
                                 Subject='Test task',whatId = sp.id,OwnerId=UserInfo.getUserId(),
                                 Call_Stage__c='Meaningful Dialogue',ActivityDateTime__c=system.today().addDays(2),
                                 ReminderDateTime=system.today().addDays(2),Product_Discussed__c='Vivotif',EndDate__c=system.today().addDays(4),
                                 Resources_Left__c='IDSA Guide',Description='Test Completed');
        
        
        Task newTask2 = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=1,RecurrenceDayOfWeekMask=null,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursMonthly',TaskIdReference__c=' '
                                 ,Subject='Test task',whatId = sp.id,OwnerId=UserInfo.getUserId(),Call_Stage__c='Meaningful Dialogue',
                                 ActivityDateTime__c=system.today().addDays(2),ReminderDateTime=system.today().addDays(2),
                                 Product_Discussed__c='Vivotif',EndDate__c=system.today().addDays(4),
                                 Resources_Left__c='IDSA Guide',Description='Test Completed');

        Task newTask3 = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task',
                                ActivityDate = null,whatId = sp.Id,WhoId=con.Id,IsRecurrence=false,
                                OwnerId=UserInfo.getUserId(),Call_Stage__c='Meaningful Dialogue',EndDate__c=dte,
                                ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
        // Perform test
        Test.startTest();
        insert newTask;
        insert newTask1;
        insert newTask2;
        insert newTask3;
        
        insert newTaskCom;
		
        newTaskCom.ActivityDateTime__c=dt;
        update newTaskCom;
        Test.stopTest();
        
    }
}