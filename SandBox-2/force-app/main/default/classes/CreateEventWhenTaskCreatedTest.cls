/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Test Class for Shiptodata class.
* @Change:  
* @last modify by:   Archie Bisen
* @last modify date:  10-Jan-2020
* *************************************************************** */
@istest
public class CreateEventWhenTaskCreatedTest {
    
 @istest static void testcreateTaskHelper(){
      //test record for custom setting
        Trg_Task_Setting__c spSetting =  Trg_Task_Setting__c.getOrgDefaults();
        spSetting.Is_Active__c=true;
        insert spSetting;

     //create a record of account
        Account acc = new Account(Name = 'TestAcc');
        insert acc;
        Contact con = new Contact(FirstName= 'TestCont',LastName = 'LName',AccountId = acc.id);
        insert con;
     
        Test.StartTest();
        //Create a record of SalesPlanner
        Sales_Planner__c sp = new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=acc.Id,Sales_Planner_Year__c='2020');
        insert sp;
     //craete a new tasks 
	  List<task> tskList = new List<Task>();
     
        Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task',ActivityDate = system.today().addDays(2),
                                whatId = sp.Id,OwnerId=UserInfo.getUserId(), Status='Open',
                                ActivityDateTime__c=datetime.newInstance(2019, 9, 15, 11, 30, 0),TaskSalesplannerDetails__c='Address');
         tskList.add(newTask);
     
     Task newTask2 = new Task(CreateEventWhenTaskCreated__c = true,Subject='Test task2',ActivityDate = system.today().addDays(4),
                                whatId = sp.Id,OwnerId=UserInfo.getUserId(), Status='Open',
                                ActivityDateTime__c=datetime.newInstance(2019, 9, 15, 11, 30, 0),TaskSalesplannerDetails__c='Address');
         tskList.add(newTask2);
     
     insert tskList;
     //perform update operation on a task
     newTask.Subject='testupdate';
     update newtask;
     //perform delete operation on a task
     	delete newTask;
      
     
     
 }}