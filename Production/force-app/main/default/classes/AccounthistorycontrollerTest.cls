@isTest
private class AccounthistorycontrollerTest {
	
   
    
      private static testMethod void createTask()
    {
        
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;
        system.debug('Acc Id = '+acc.Id);
        
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2019';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp;
        
         Contact cont = new Contact();
        cont.LastName='Test';
        cont.MobilePhone='1234567890';
        cont.Phone='123466789012';
        // cont.Account ='CARNEGIE MELLON UNIV';
        cont.Accountid= acc.id;
        insert cont;
    
         /*User us = new User();
        us.Username = 'test@samp.com';
       us.Email = 'test@samp.com';
       us.Alias = 'tsamp';
       
       //us.UserRoleId = 'user_role_id_goes_here';
       //us.ProfileId = 'user_profile_id_goes_here';
        us.CommunityNickname = 'te';
       us.IsActive = false;
       insert us;*/
        
        
        Task t = new Task();
        t.Subject='Test';
        t.OwnerId= UserInfo.getUserId();
        t.ActivityDate= Date.newInstance(2019,04,01);
        t.Priority= 'Normal';
        t.Type= 'Email';
        t.Status= 'Completed';
        t.Description= 'this is for testing purpose';
        t.Resources_Left__c='None';
        t.Call_Stage__c='Adopting';
        // cont.Account ='CARNEGIE MELLON UNIV';
        t.WhoId= cont.id;
        insert t;
        system.debug('::::t.Accountid::::::'+t.Accountid);
        System.debug(':::t::::::;'+t);
        
      
        Test.startTest();
        //ContactsDisplay cD=new ContactsDisplay();
        Accounthistorycontroller.gettask(sp.id);
       
        Task[] ta = [select id,Subject,Description,WhoId,Who.Name, WhatId, What.Name, OwnerId,Owner.Name,CreatedById,CreatedBy.Alias, ActivityDate, Type, Status from Task where Status='Completed' AND accountid =: acc.id];
       // String formattedDate = string.valueOf(ta.ActivityDate.month())+'-'+string.valueOf(ta.ActivityDate.day())+'-'+string.valueOf(ta.ActivityDate.year());   

        Accounthistorycontroller.TaskWrapper tw = new Accounthistorycontroller.TaskWrapper(t);
        system.debug('::::::::::ta:::::::::'+ta);
        system.assertEquals(1, ta.size());
        test.stopTest();
        
    }
    
    
}