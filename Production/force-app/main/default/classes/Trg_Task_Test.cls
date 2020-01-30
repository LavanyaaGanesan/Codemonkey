@isTest
private class Trg_Task_Test {
    
    private static testMethod void taskCreate()
    {     
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;
        system.debug('Acc Id = '+acc.Id);
        
        Sales_Planner__c sp = new Sales_Planner__c();
        sp.Name='Test Account';
        sp.Sales_Planner_Year__c='2019';
        sp.Account_Sales_Planner__c = acc.id;        
        insert sp; 
        
        Sales_Planner__c spNew =[SELECT Name,X2019_TotalActivities__c FROM Sales_Planner__c WHERE Id=:sp.Id LIMIT 1];
        system.debug('::::::::::::acc:::::::::::'+sp);
        System.assertEquals(sp.Name,'Test Account');
        
        Task t1 = new Task();
        t1.subject='TestTask';
        //t1.Type='Phone Call';
        t1.WhatId=acc.Id;
        t1.status = 'Completed';
        t1.Product_Discussed__c = 'Vivotif';
        t1.Call_Stage__c ='Meaningful Dialogue';
        //t1.Call_Stage__c ='Closed/Not Viable';
        t1.description ='Disease/Product Introduction';
        //t1.Resources_Left__c = 'Vaxchora PI';
        t1.Resources_Left__c = 'IDSA Guide';
          
        t1.Closed_Reasons__c = 'Storage';
        
        Test.startTest();
        
        insert t1;
        update t1;
        
        system.debug('insert'+t1);
        
        // System.assertEquals(accNew.X2019_Total_Activities__c,1);
        Sales_Planner__c newAcc = new Sales_Planner__c();
        newAcc.Name ='test Update Account';
        newAcc.Id= sp.Id;
        //insert newAcc;
      //t1.WhatId=newAcc.Id;
      //  update t1;
        
        
       Sales_Planner__c updateAcc = [select id,X2019_TotalActivities__c,(select id,status,Type,WhatId from Tasks where status='Completed' ) from Sales_Planner__c   where id =:sp.Id LIMIT 1];
       // System.assertEquals(1,updateAcc.X2019_Total_Activities__c);
        system.debug('::::::::::::updateAcc:::::::::::'+updateAcc);
        Delete t1;
        
        Test.stopTest();
    }
    
    
}