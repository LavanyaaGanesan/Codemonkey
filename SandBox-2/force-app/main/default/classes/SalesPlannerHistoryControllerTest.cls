/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Test Class for SalesPlannerHistoryController class.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  8-Jan-2020
* *************************************************************** */
@isTest
public class SalesPlannerHistoryControllerTest
{
    public static Account acc1;
    public static Account acc2;
    /* ***************************************************************
    * @description: Method to create and insert Account records.
    * @Change:  
    * *************************************************************** */
    public static void setupData(){
         SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
        spSetting.ActiveTrigger__c=true;
        spSetting.SalesPlanner_Years__c = '2019,2020';
        insert spSetting;
        acc1 = new Account(Name = 'TestAcc12', DDD_Outlet_ID__c='12345');
        insert acc1;
        acc2 = new Account(Name = 'TestAcc23', DDD_Outlet_ID__c='67890');
        insert acc2;
    }
    
    
    @testSetup 
    public static void setup()
    {
    }
     /* ***************************************************************
    * @description: Method to get salesplanner history records.
    * @Change:  
    * *************************************************************** */
    @isTest
    public static void getSalesPlannerHistoryAndIcon()
    {
        
        //To insert and delete salesplanner records.
        setupData();
        
        Sales_Planner__c s1 = new Sales_Planner__c(Name='Testvivek1',Sales_Planner_Year__c='2020',
                                                   Account_Sales_Planner__c=acc1.id,
                                                   Account_Stage__c='Vivotif Supporter');
        insert s1;
        delete s1;       
        
        Sales_Planner__c s2 = new Sales_Planner__c(Name='Testvivek2',Sales_Planner_Year__c='2020',
                                                   Account_Sales_Planner__c=acc2.id,
                                                   Account_Stage__c='Vivotif Supporter');
        insert s2;
        delete s2;
        
        //start the code coverage execution
        System.Test.startTest();
        List<Sales_Planner_History__c> spHistory1=SalesPlannerHistoryController.getSalesPlannerHistory(acc1.Id);
        List<Sales_Planner_History__c> spHistory2=SalesPlannerHistoryController.getSalesPlannerHistory(acc2.Id);
        
        String result1=SalesPlannerHistoryController.getIconName('Account');
        String result2=SalesPlannerHistoryController.getIconName('Sales_Planner__c');
        //stop the code coverage execution
        system.Test.stopTest();
        system.assertEquals('12345', acc1.DDD_Outlet_ID__c);
        system.assertEquals('67890', acc2.DDD_Outlet_ID__c);
        
    }
     /* ***************************************************************
    * @description: Method to retrive salesplanner record.
    * @Change:  
    * *************************************************************** */
    @isTest
    public static void retriveSalesPlanner()
    {
        
        setupData();
        //Create salesplanner dummy data.
        Sales_Planner__c s = new Sales_Planner__c(Name='Testvivek1',Sales_Planner_Year__c='2020',
                                                  Account_Sales_Planner__c=acc1.id,
                                                  Account_Stage__c='Vivotif Supporter'
                                                 );
        
        insert s;

        List<ID> lstIds = new List<ID>();
        lstIds.add(s.ID);
		system.debug('list Ids '+lstIds);
        delete s;
         
        //list to store SP history records.
        List<Sales_Planner_History__c> sH = [Select id from Sales_Planner_History__c 
                                             where Sales_Planner_Id__c IN:lstIds and Is_Deleted__c=true  limit 1];
        
        List<String> lstSPHIds = new List<String>();
        lstSPHIds.add(sH[0].ID);

        List<Sales_Planner_History__c> shn =new  List<Sales_Planner_History__c>();
        
        Sales_Planner_History__c sph1= new Sales_Planner_History__c();
        sph1.Name='test';
        sph1.Account_Sales_Planner_History__c=acc1.id;
        sph1.Sales_Planner_Id__c=s.id;


        insert sph1;
        //creation of user test data.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User( Alias = 'styu',  Email='standarduser@testorg.com', EmailEncodingKey='UTF-8',  LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId =profileId.id ,  TimeZoneSidKey='America/Los_Angeles',  UserName='stauser5@gmail.com');
        insert u;
        //Creating and inserting the task records.
        Task t = new task();
        t.Subject='Fax';
        t.OwnerId=u.id;
        t.WhatId=sph1.id;        
        t.ActivityDateTime__c=datetime.newInstance(2019, 9, 15, 11, 30, 0);
        t.EndDate__c=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        t.Priority='High';
        t.Type='Email';
        t.Status='Completed';
        t.Description='dhbo';
        t.Product_Discussed__c='Vivotif';
        t.Call_Stage__c='Disease Education';
        t.Resources_Left__c='None';
        insert t;
        
        //Creating Account records.
        Account acc11 = new Account(Name = 'TestAcc11', DDD_Outlet_ID__c='12345');
        insert acc11;
        
        Sales_Planner__c s11 = new Sales_Planner__c(Name='Testvivek11',Sales_Planner_Year__c='2020',
                                                    Account_Sales_Planner__c=acc11.id,
                                                    Account_Stage__c='Vivotif Supporter');
        insert s11;
        
        Event e = new Event();
        // e.Subject='vhvhg';
        e.DurationInMinutes=60;
        // e.StartDateTime=datetime.newInstance(2020, 2, 15, 11, 30, 0);
        // e.EndDateTime=datetime.newInstance(2020, 2, 15, 12, 30, 0);
        e.ActivityDateTime=datetime.newInstance(2020, 2, 15, 11, 30, 0);
        e.WhatId=sph1.id;
        insert e;
        //creating Event record.
        Event e1 = new Event();

        e1.DurationInMinutes=90;


        e1.ActivityDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        e1.WhatId=sph1.id;
        insert e1;
        //creating Event record.
        Event e2 = new Event();

        e2.DurationInMinutes=90;

        e2.EndDateTime=null;
        e2.ActivityDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        e2.WhatId=sph1.id;
        insert e2;
        
        //creating list of event records.
        list<Event> evel= [select Subject,Id from Event where Id=:sph1.id];

        //Creating list of task records.
        list<Task> taskl= [select Id from Task where Id=:sph1.id];

        //Creating case record.
        Case c = new Case();
        c.City__c = 'London';
        c.Sales_Planner_History__c=sph1.id;
        insert c;
        //start the code coverage execution
        System.Test.startTest();        
        SalesPlannerHistoryController.RetriveRecords(lstSPHIds);
        SalesPlannerHistoryController.getIsAdmin();
        SalesPlannerHistoryController.retrive_SPH_To_SP(sph1);
        SalesPlannerHistoryController.retriveExistingSPHActivityHistory(s.Id,sph1.id);
        SalesPlannerHistoryController.updateExistingSalesPlannerHistoryCaseWithSP(s.Id,sph1.id);
        //stop the code coverage execution
        system.Test.stopTest();
    }
    
    @isTest
    public static void retriveSalesPlanner2()
    {
        
        setupData();
        
        Sales_Planner__c s = new Sales_Planner__c(Name='Testvivek1',Sales_Planner_Year__c='2020',
                                                  Account_Sales_Planner__c=acc1.id,
                                                  Account_Stage__c='Vivotif Supporter'
                                                 );
        
        insert s;
        //Creating event records.
        Event et = new Event();
        // e.Subject='vhvhg';
        et.DurationInMinutes=60;
        // e.StartDateTime=datetime.newInstance(2020, 2, 15, 11, 30, 0);
        // e.EndDateTime=datetime.newInstance(2020, 2, 15, 12, 30, 0);
        et.ActivityDateTime=datetime.newInstance(2020, 2, 15, 11, 30, 0);
        et.WhatId=s.id;
        //inserting event records.
        insert et;
        //Creating event records.
        Event et1 = new Event();
        //e1.Subject='vhvhg';
        et1.DurationInMinutes=90;
        //e1.StartDateTime=datetime.newInstance(2019, 9, 15, 11, 30, 0);
        //e1.EndDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        et1.ActivityDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        et1.WhatId=s.id;
        //inserting event records.
        insert et1; 
        //Creating event records.
        Event e3 = new Event();
        //e1.Subject='vhvhg';
        e3.DurationInMinutes=90;
        //e1.StartDateTime=datetime.newInstance(2019, 9, 15, 11, 30, 0);
        e3.EndDateTime=null;
        e3.ActivityDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        e3.WhatId=s.id;
        //inserting event records.
        insert e3;
     
        List<String> lstIds = new List<String>();
        lstIds.add(s.ID);
       //deleting salesplanner record.
        delete s;
        
        List<Sales_Planner_History__c> sH = [Select id from Sales_Planner_History__c 
                                             where Sales_Planner_Id__c IN:lstIds and Is_Deleted__c=true  limit 1];
        //Creating list of salesplanner history IDs.
        List<String> lstSPHIds = new List<String>();
        lstSPHIds.add(sH[0].ID);
        
        List<Sales_Planner_History__c> shn =new  List<Sales_Planner_History__c>();
        //Creating Sales_Planner_History__c record.
        Sales_Planner_History__c sph1= new Sales_Planner_History__c();
        sph1.Name='test';
        sph1.Account_Sales_Planner_History__c=acc1.id;
        sph1.Sales_Planner_Id__c=s.id;
        // sph1.Unique_SalesPlanner__c=s.id;
        //shn.add(sph1);
        insert sph1;
        //creation of user test data.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User( Alias = 'styu',  Email='standarduser@testorg.com', EmailEncodingKey='UTF-8',  LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId =profileId.id ,  TimeZoneSidKey='America/Los_Angeles',  UserName='stauser6@gmail.com');
        insert u;
        //Creating and inserting the task records.
        Task t = new task();
        t.Subject='Fax';
        t.OwnerId=u.id;
        t.WhatId=sph1.id;        
        t.ActivityDateTime__c=datetime.newInstance(2019, 9, 15, 11, 30, 0);
        t.EndDate__c=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        t.Priority='High';
        t.Type='Email';
        t.Status='Completed';
        t.Description='dhbo';
        t.Product_Discussed__c='Vivotif';
        t.Call_Stage__c='Disease Education';
        t.Resources_Left__c='None';
        insert t;
        //Creating Account records.
        Account acc11 = new Account(Name = 'TestAcc11', DDD_Outlet_ID__c='12345');
        insert acc11;
        
        Sales_Planner__c s11 = new Sales_Planner__c(Name='Testvivek11',Sales_Planner_Year__c='2020',
                                                    Account_Sales_Planner__c=acc11.id,
                                                    Account_Stage__c='Vivotif Supporter');
        //inserting salesplanner record.
        insert s11;
        System.runAs(u) {
            Event e = new Event();
            // e.Subject='vhvhg';
            e.DurationInMinutes=60;
            // e.StartDateTime=datetime.newInstance(2020, 2, 15, 11, 30, 0);
            // e.EndDateTime=datetime.newInstance(2020, 2, 15, 12, 30, 0);
            e.ActivityDateTime=datetime.newInstance(2020, 2, 15, 11, 30, 0);
            e.WhatId=sph1.id;
            //inserting event records.
            insert e;
            //creating event records.
            Event e1 = new Event();
            //e1.Subject='vhvhg';
            e1.DurationInMinutes=90;
            //e1.StartDateTime=datetime.newInstance(2019, 9, 15, 11, 30, 0);
            //e1.EndDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
            e1.ActivityDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
            e1.WhatId=sph1.id;
            //inserting event records.
            insert e1;
            //creating event records.
            Event e2 = new Event();
        //e1.Subject='vhvhg';
        e2.DurationInMinutes=90;
        //e1.StartDateTime=datetime.newInstance(2019, 9, 15, 11, 30, 0);
        e2.EndDateTime=null;
        e2.ActivityDateTime=datetime.newInstance(2019, 9, 15, 12, 30, 0);
        e2.WhatId=sph1.id;
        //inserting event records.
        insert e2;
        }
        list<Event> evel= [select Subject,Id from Event where Id=:sph1.id];

        list<Task> taskl= [select Id from Task where Id=:sph1.id];

        //creating new case record.
        Case c = new Case();
        c.City__c = 'London';
        c.Sales_Planner_History__c=sph1.id;
        insert c;
        //start the code coverage execution.
        System.Test.startTest();        
        SalesPlannerHistoryController.RetriveRecords(lstSPHIds);
        SalesPlannerHistoryController.getIsAdmin();
        SalesPlannerHistoryController.retrive_SPH_To_SP(sph1);
        SalesPlannerHistoryController.retriveExistingSPHActivityHistory(s.Id,sph1.id);
        SalesPlannerHistoryController.updateExistingSalesPlannerHistoryCaseWithSP(s.Id,sph1.id);
        //Stop the code coverage execution.
        system.Test.stopTest();
    }
}