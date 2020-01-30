/* ***************************************************************
* Owner/Modify by Name : Prashant
* @description: DeleteTaskWhenEventDeletedTest is used to provide test data for DeleteTaskWhenEventDeleted trigger for code coverage.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  14-Jan-2020
* *************************************************************** */
@isTest
public class DeleteTaskWhenEventDeletedTest {
    @isTest
    /* ***************************************************************
* @description: calling function to pass test data to DeleteTaskWhenEventDeleted trigger for code coverage
* @Change:
* *************************************************************** */
    public static void deletetask() {
         //test record for custom setting
        DeleteTaskWhenEventIsDeleted_c__c spSetting =  DeleteTaskWhenEventIsDeleted_c__c.getOrgDefaults();
        spSetting.IsActive__c=true;
        insert spSetting;
        //test data for account record
        Account acc = new Account(Name = 'TestAcc');
        //insert account
        insert acc;
        //test data for contact record
        Contact con = new Contact(FirstName= 'TestCont',LastName = 'LName',AccountId = acc.id);
        //insert contact
        insert con;
        //test data for salesplanner record
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
       	//insert salesplanner
        insert sp;
        //to provide the startTime
        String timestart = '2016-09-02 09:15:26';
        Datetime dt = Datetime.valueOf(timestart);
        //to provide the EndTime
        String timeend = '2016-09-03 09:15:26';
        Datetime dte = Datetime.valueOf(timeend);
        //test data for task Record related to test salesplanner and contact created above
        Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task',
                                ActivityDate = system.today().addDays(2),whatId = sp.Id,WhoId=con.Id,
                                OwnerId=UserInfo.getUserId(),EndDate__c=dte,
                                ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
        //insert task
        insert newTask;
        //test data for event.
        Event newEvent = new Event (TaskIdReference__c= newTask.id,DurationInMinutes=120,ActivityDateTime = dt);
        //insert event
        insert newEvent;
        
        test.startTest();
        //delte event
        delete newEvent;
        test.stopTest();
    }
    
}