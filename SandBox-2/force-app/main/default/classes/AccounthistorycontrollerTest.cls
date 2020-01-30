/* ***************************************************************
* Owner/Modify by Name : Vishal Soni
* @description: Test Class for AccountHistory Controller.
* @Change:  
* @last modify by: Vishal Soni
* @last modify date:  8-Jan-2020
* *************************************************************** */
@isTest
private class AccounthistorycontrollerTest {
      /* ***************************************************************
    * @description: Method to create task related to SalesPlanner.
    * @Change:  
    * *************************************************************** */
    
    
    private static testMethod void createTask()
    {
        //Creating test data to insert account records.
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;
        
        //Creating test data to insert SalesPlanner records.
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2020';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp;
        //Creating test data to insert contact records.
        Contact cont = new Contact();
        cont.LastName='Test';
        cont.MobilePhone='1234567890';
        cont.Phone='123466789012';
        
        cont.Accountid= acc.id;
        insert cont;
        //Creating test data to insert Task records.
        Task t = new Task();
        t.Subject='Test';
        t.OwnerId= UserInfo.getUserId();
        t.ActivityDate= Date.newInstance(2019,04,01);
        t.Priority= 'Normal';
        t.Type= 'Email';
        t.Status= 'Completed';
        t.Description= 'this is for testing purpose';
        
        t.Product_Discussed__c='Business Related';
        t.Call_Stage__c='Adopting';
        
        t.WhoId= cont.id;
        insert t;
        
        
        
        
        Test.startTest();
        //Call gettask method from Accounthistorycontroller and pass test data as a parameter.
        Accounthistorycontroller.gettask(sp.id);
        
        Task[] ta = [select id,Subject,Description,WhoId,Who.Name, WhatId, What.Name, OwnerId,Owner.Name,CreatedById,CreatedBy.Alias, ActivityDate, Type, Status from Task where Status='Completed' AND accountid =: acc.id];
        
         //Call TaskWrapper method from Accounthistorycontroller and pass test data as a parameter.
        Accounthistorycontroller.TaskWrapper tw = new Accounthistorycontroller.TaskWrapper(t);
        
        system.assertEquals(1, ta.size());
        test.stopTest();
        
    }
    
    
}