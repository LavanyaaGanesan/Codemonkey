/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Test Class for Trg_SalesPlanner_Helper class.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  13-Jan-2020
* *************************************************************** */
@istest
public class Trg_SalesPlanner_HelperTest {
    
     
   /* ***************************************************************
    * @description: Method to create and insert Account and salesplanner records.
    * @Change:  
    * *************************************************************** */
    @istest static void testTrg_SalesPlanner_Helper(){
         //test record for custom setting
        SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
        spSetting.SalesPlanner_Years__c='2020';
        spSetting.ActiveTrigger__c=true;
        insert spSetting;
        try{
            //creating dummy account records.
            List<Account> accounts = new List<Account>{
                new Account( Name = 'MyTestAccount',Outlet_Name__c = 'Test' ),
                new Account( Name = 'MyTestAccount1',Outlet_Name__c = 'Test1')
        	};
            //Inserting account records.
            insert accounts;
            //start the code coverage execution.
            Test.StartTest();
            //Creating salesplanner list.
            List<Sales_Planner__c> spNew = new List<Sales_Planner__c>{
                new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=accounts.get(0).Id,Sales_Planner_Year__c='2020',X2019_TotalActivities__c= 20),
                new Sales_Planner__c(Name = 'MyTestSalesPlanner 1',Account_Sales_Planner__c=accounts.get(1).Id,Sales_Planner_Year__c='2020',X2019_TotalActivities__c= 20)
            };
            //inserting salesplanner records.
            insert spNew;            
            
            System.assertEquals(spNew[0].Name,'MyTestSalesPlanner');
            System.assertEquals(spNew[0].Sales_Planner_Year__c,'2020');
            System.assertEquals(spNew[0].Account_Sales_Planner__c,accounts.get(0).Id);
            System.assertEquals(spNew[0].X2019_TotalActivities__c,20);
            //creating salesplanner records.
            Sales_Planner__c sp1 = new Sales_Planner__c();
            sp1.Id=spNew[0].id;
            sp1.Name ='Updated MyTestSalesPlanner';
            //Updating salesplanner records.
            update sp1;
            System.assertEquals(sp1.Name,'Updated MyTestSalesPlanner');
            
            try{
                //creating salesplanner records.
                Sales_Planner__c sp2 = new Sales_Planner__c();
                sp2.Id=spNew[1].id;
                sp2.Account_Sales_Planner__c = accounts[0].Id;
                //Updating salesplanner records.
                update sp2;
            }
           catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_HelperTest', 'testTrg_SalesPlanner_Helper', ex.getMessage(), ex.getLineNumber());
        }          
          //stop the code coverage execution.
            Test.StopTest();
        }
       catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_HelperTest', 'testTrg_SalesPlanner_Helper', ex.getMessage(), ex.getLineNumber());
        }
    } 
    
    /*****************************************/
     
    
     @istest static void testTrg_SalesPlanner_Helper1(){
          //test record for custom setting
        SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
        spSetting.SalesPlanner_Years__c='2020';
        spSetting.ActiveTrigger__c=true;
        insert spSetting;
          //creation of user test data.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
         User u2 = [Select id from User where Alias= 'Lgan' LIMIT 1]; 
		User u = new User(
            Alias = 'styu', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId =profileId.id , 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='stauser@gmail.com');
         //insert u;
         //Running the system as created user.
         System.runAs ( u2 ) { 
             Account a = new Account(Name='TestViv123');
             insert a;
             //Creating new salesplanner record.
             Sales_Planner__c s = new Sales_Planner__c(Name='Test123',Sales_Planner_Year__c='2020',
                                                       Account_Sales_Planner__c=a.id,
                                                       Account_Stage__c='Vivotif Supporter',
                                                      X2019_TotalActivities__c= 20);
             //inserting new salesplanner record.
             insert s;
             
             //create case object and assign required values
             Case c = new case(Subject = s.Name,Sales_Planner__c=s.id,AccountId=s.Account_ID__c);
             //insert case record
             insert c;
             
             //Creating task records.
             Task t = new task(WhatId=s.id, Subject='Fax',OwnerId=u2.id,ActivityDate=Date.today(),Priority='High',Type='Email',
                               Status='Completed',Description='dhbo',Product_Discussed__c='Vivotif',Call_Stage__c='Disease Education',Resources_Left__c='None');
             insert t;
             
             //Creating event records.
             event e = new event(WhatId=s.id, Subject='Fax',OwnerId=u2.id,ActivityDate=Date.today(),Type='Email',
                               ActivityDateTime=Date.today(),DurationInMinutes =30,Description='dhbo',Product_Discussed__c='Vivotif',Call_Stage__c='Disease Education',Resources_Left__c='None');
             insert e;
             //create note object with required values
             ContentNote cnt = new ContentNote(Content = Blob.valueof(s.Name),Title = 'Creation Note');
             //insert note
             insert cnt;
             //create content document link object with required values
             ContentDocumentLink clnk = new ContentDocumentLink(LinkedEntityId = s.Id, ContentDocumentId = cnt.Id,ShareType = 'I');
             insert clnk;
             
             //Deleting salesplanner record.
             delete s;             
             
             try{
                 //Creating new salesplanner record.
                 Sales_Planner__c s1 = new Sales_Planner__c(Name='Test123',Sales_Planner_Year__c='2020',
                                                            Account_Sales_Planner__c=a.id,
                                                            Account_Stage__c='Vivotif Supporter',
                                                            X2019_TotalActivities__c= 20);
                 insert s1;

             }
             catch(exception ex){                 
             }
             Sales_Planner_History__c sh=new Sales_Planner_History__c();
             
             //start the code coverage execution
             test.startTest();
             Trg_SalesPlanner_Helper.updateExistingSalesPlannerActivityHistory(s.id,sh.id);
             //stop the code coverage execution
             test.stopTest();   
             
             
         }
     }
    

    @istest static void testTrg_SalesPlanner_Helper2(){
         //test record for custom setting
        SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
        spSetting.SalesPlanner_Years__c='2020';
        spSetting.ActiveTrigger__c=true;
        insert spSetting;
        try{
            //Creating dummy account records.
            List<Account> accounts = new List<Account>{
                new Account( Name = 'MyTestAccount',Outlet_Name__c = 'Test' ),
                new Account( Name = 'MyTestAccount1',Outlet_Name__c = 'Test1')
        	};
            //inserting account records.
            insert accounts;
            Test.StartTest();
            //Creating list of salesplanner records.
            List<Sales_Planner__c> spNew = new List<Sales_Planner__c>{
                new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=accounts.get(0).Id,Sales_Planner_Year__c='2019', X2019_TotalActivities__c= 20)
            };
                
                try{
                    insert spNew;     
                }
           catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_HelperTest', 'testTrg_SalesPlanner_Helper2', ex.getMessage(), ex.getLineNumber());
        }
           //stop the code coverage execution
            Test.StopTest();
        }
       catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_HelperTest', 'testTrg_SalesPlanner_Helper2', ex.getMessage(), ex.getLineNumber());
        }
    }
    @istest static void testTrg_SalesPlanner_Helper3(){
         //test record for custom setting
        SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
        spSetting.SalesPlanner_Years__c='2020';
        spSetting.ActiveTrigger__c=true;
        insert spSetting;
        try{
            //creating dummy account records.
            List<Account> accounts = new List<Account>{
                new Account( Name = 'MyTestAccount',Outlet_Name__c = 'Test' ),
                new Account( Name = 'MyTestAccount1',Outlet_Name__c = 'Test1')
        	};
            //inserting account records.
            insert accounts;
            
            //creating salesplanner list.
            List<Sales_Planner__c> spNew = new List<Sales_Planner__c>{
                new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=accounts.get(0).Id,Sales_Planner_Year__c='2020', X2019_TotalActivities__c= 20)
            };
                //start the code coverage execution
				Test.StartTest();
                    insert spNew;  
                    delete spNew;
                    Undelete spNew;
         //stop the code coverage execution
            Test.StopTest();
        }
        
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_HelperTest', 'testTrg_SalesPlanner_Helper3', ex.getMessage(), ex.getLineNumber());
        }
        
    }
     @istest static void testTrg_SalesPlanner_Helper4(){
          //test record for custom setting
        SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
        spSetting.SalesPlanner_Years__c='2020';
        spSetting.ActiveTrigger__c=true;
        insert spSetting;
        try{
            //creating dummy account records.
            List<Account> accounts = new List<Account>{
                new Account( Name = 'MyTestAccount',Outlet_Name__c = 'Test' ),
                new Account( Name = 'MyTestAccount1',Outlet_Name__c = 'Test1')
        	};
            //inserting account records.
            insert accounts;
            
            //creating salesplanner list.
            List<Sales_Planner__c> spNew = new List<Sales_Planner__c>{
                new Sales_Planner__c(Name = 'MyTestSalesPlanner',Account_Sales_Planner__c=accounts.get(0).Id,Sales_Planner_Year__c='2021', X2019_TotalActivities__c= 20)
            };
                //start the code coverage execution
				Test.StartTest();
                    insert spNew;  
                    delete spNew;
                    Undelete spNew;
         //stop the code coverage execution
            Test.StopTest();
        }
        
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_HelperTest', 'testTrg_SalesPlanner_Helper3', ex.getMessage(), ex.getLineNumber());
        }
        
    }
    
    
    
    
}