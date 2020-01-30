/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Test class for Trg_Task trigger
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  17-Jan-2020
* *************************************************************** */
@isTest
private class Trg_Task_Test {
    //Method to create dummy task records.
    private static testMethod void taskCreate()
    {   
        //test record for custom setting
        Trg_Task_Setting__c spSetting =  Trg_Task_Setting__c.getOrgDefaults();
        spSetting.Is_Active__c=true;
        insert spSetting;
        //Creating new account records.
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        //Inserting Account records.
        insert acc;

        //Creating new salesplanner records.
        Sales_Planner__c sp = new Sales_Planner__c();
        sp.Name='Test Account';
        sp.Sales_Planner_Year__c='2019';
        sp.Account_Sales_Planner__c = acc.id;       
        //Inserting salesplanner records.
        insert sp; 
        
        Sales_Planner__c spNew =[SELECT Name,X2019_TotalActivities__c FROM Sales_Planner__c WHERE Id=:sp.Id LIMIT 1];

        System.assertEquals(sp.Name,'Test Account');
        //Creating new task records.
        Task t1 = new Task();
        t1.subject='TestTask';

        t1.WhatId=acc.Id;
        t1.status = 'Completed';
        t1.Product_Discussed__c = 'Vivotif';
        t1.Call_Stage__c ='Meaningful Dialogue';

        t1.description ='Disease/Product Introduction';

        t1.Resources_Left__c = 'IDSA Guide';
          
        t1.Closed_Reasons__c = 'Storage';
        //To start the execution of test class
        Test.startTest();
        
        insert t1;
        update t1;
        
        system.debug('insert'+t1);
        

        Sales_Planner__c newAcc = new Sales_Planner__c();
        newAcc.Name ='test Update Account';
        newAcc.Id= sp.Id;
        //Fetching task records related to salesplanner object.
       Sales_Planner__c updateAcc = [select id,X2019_TotalActivities__c,(select id,status,Type,WhatId from Tasks where status='Completed' ) from Sales_Planner__c   where id =:sp.Id LIMIT 1];

       //Delete task records
        Delete t1;
       ////To stop the execution of test class
        Test.stopTest();
    }
    
    
}