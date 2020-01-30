@istest
public class updateActivityInTaskHelperTest
{
    @istest
    public static list<Holiday> HOlidayListTest()
    {
        //create a holiday record for testing and perform insert operation
        list<Holiday> listHoli= new list<Holiday>();
        Date todayDate = system.today();
        for(integer i=0;i<10 ;i++){
            Holiday h1= new Holiday();
            date aD =todayDate.addDays(10);
            h1.ActivityDate=aD;
            h1.Name='Holiday ' + string.valueOf(i+1);
            listHoli.add(h1);
            todayDate = aD;
        }
        insert listHoli;
        return listHoli;
    }
    @istest
    public static void checkHolidayTest()
    {
        
        Trg_Task_Setting__c ts= Trg_Task_Setting__c.getOrgDefaults();
        ts.Is_Active__c=true;
        insert ts;
        //select a standard user profile and user using the query
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u2 = [Select id from User where Alias= 'Lgan' LIMIT 1];        
       
        System.runAs ( u2 ) {
            //create an account record and insert it
            Account acc = new Account(Name = 'TestAcc');
            insert acc;
             //create an contact record and insert it
            Contact con = new Contact(FirstName= 'TestCont',LastName = 'LName',AccountId = acc.id);
            insert con;
             //create an salesplanner record and insert it
            Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
            insert sp;
            
            //assign holiday data to holiday list
            List<Holiday> HOL=updateActivityInTaskHelperTest.HOlidayListTest();
            
            
        	Datetime dt = Datetime.valueOf('2020-08-01 08:15:26');
            // create and insert tasks with different details to test combination of scenarios 
            List<Task> TaskLi= new  List<Task>();            
            Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',
                                    whatId = sp.Id,OwnerId=u2.id, Status='Open',
                                    ActivityDateTime__c=system.today().addDays(6),TaskSalesplannerDetails__c='Address');
            
            Task newTask1 = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',
                                     ActivityDate = system.today().addDays(5),
                                     whatId = sp.Id,OwnerId=u2.id, Status='Open',
                                     ActivityDateTime__c=system.today().addDays(5),TaskSalesplannerDetails__c='Address');
            newTask1.EndDate__c=system.today().addDays(5);
            
            Task newTask2 = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',
                                    whatId = sp.Id,OwnerId=u2.id, Status='Open',
                                    ActivityDateTime__c=dt.addDays(7),TaskSalesplannerDetails__c='Address', EndDate__c=dt.addDays(10));
            
            TaskLi.add(newTask);
            TaskLi.add(newTask1);
            TaskLi.add(newTask2);
            insert TaskLi;
            
           
        }
    }
    
    @istest
    public static void checkHolidayTest1()
    {
        
        Trg_Task_Setting__c ts= Trg_Task_Setting__c.getOrgDefaults();
        ts.Is_Active__c=true;
        insert ts;
        //select a standard user profile and user using the query
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        list<user> listUser= new list<user>();
        User u2 = [Select id from User where Alias= 'Lgan' LIMIT 1];       
        System.runAs ( u2 ) {
             //create an account record and insert it
            Account acc = new Account(Name = 'TestAcc');
            insert acc;
             //create an contact record and insert it
            Contact con = new Contact(FirstName= 'TestCont',LastName = 'LName',AccountId = acc.id);
            insert con;
             //create an salesplanner record and insert it
            Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
            insert sp;
            
            DateTime aD =  system.today().addDays(2);
            DateTime eD =  system.today().addDays(3);
            // create and insert task with different details to test combination of scenarios
            Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',
                                    ActivityDate =aD.date(),
                                    whatId = sp.Id,OwnerId=u2.id, Status='Open',
                                    ActivityDateTime__c=aD,TaskSalesplannerDetails__c='Address');
            newTask.EndDate__c=eD;
            insert newTask;
            
            DateTime aD1 =  system.today().addDays(3);
            DateTime eD1 =  system.today().addDays(4);
            // create and insert task with different details to test combination of scenarios
            List<Task> TaskLi= new  List<Task>();
            Task newTask1 = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',
                                     ActivityDate =aD1.date(),
                                     whatId = sp.Id,OwnerId=u2.id, Status='Open',
                                     ActivityDateTime__c=aD1,TaskSalesplannerDetails__c='Address');
            newTask1.EndDate__c=eD1;
                      
            TaskLi.add(newTask1);
            
            insert TaskLi;
            // create and insert task with different details to test combination of scenarios
            Task newTask3 = new Task(IsRecurrence = true,IsReminderSet=true,Status='Completed', CreateEventWhenTaskCreated__c = true,RecurrenceDayOfMonth=null,RecurrenceDayOfWeekMask=null,RecurrenceEndDateOnly=system.today().addDays(15),RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                     RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursDaily',TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,OwnerId=u2.id,Call_Stage__c='Disease/Product Introduction',ActivityDateTime__c=system.today().addDays(2),EndDate__c=system.today().addDays(4),ReminderDateTime=system.today().addDays(2),Product_Discussed__c='Vivotif',Resources_Left__c='IDSA Guide',Description='Test Completed');
            insert newTask3;
            // create and insert task with different details to test combination of scenarios
            Task newTask4 = new Task(IsRecurrence = true,IsReminderSet=true,
                                     Status='Completed', CreateEventWhenTaskCreated__c = true,
                                     RecurrenceDayOfMonth=null,RecurrenceDayOfWeekMask=null,
                                     RecurrenceEndDateOnly=system.today().addDays(15),
                                     RecurrenceStartDateOnly=system.today().addDays(2),RecurrenceInstance=null,
                                     RecurrenceInterval=1,RecurrenceMonthOfYear=null,
                                     RecurrenceTimeZoneSidKey='America/Los_Angeles',RecurrenceType='RecursDaily',
                                     TaskIdReference__c=' ',Subject='Test task',whatId = sp.id,OwnerId=u2.id,
                                     Call_Stage__c='Disease/Product Introduction',ActivityDateTime__c=system.today().addDays(2),
                                     EndDate__c=system.today().addDays(4),ReminderDateTime=system.today().addDays(2),
                                     Product_Discussed__c='Vivotif',Resources_Left__c='IDSA Guide',
                                     Description='Test Completed');
            
            insert newTask4;
            // create and insert task with different details to test combination of scenarios
            Task newTask5 = new Task(OwnerId=u2.id,	ActivityDateTime__c=system.today().addDays(2),
                                     EndDate__c=system.today().addDays(4),
                                     Priority='High',
                                     Type='Email',
                                     Status='open',
                                     whatId = sp.Id,
                                     Subject='Test task'
                                     
                                    );
            insert newTask5;
            // create and insert task with different details to test combination of scenarios
            Task newTask6 = new Task(OwnerId=u2.id,	ActivityDateTime__c=system.today().addDays(2),
                                     EndDate__c=system.today().addDays(4),
                                     Priority='High',
                                     Type='PTO',
                                     Status='open',
                                     whatId = sp.Id,
                                     Subject='Test task'
                                     
                                    );
            insert newTask6;
            newTask6.Subject='test';
            try{
                update newTask6;
            }
            catch(exception e)
            {
                system.debug(e.getMessage());
            }            
        }
    }
}