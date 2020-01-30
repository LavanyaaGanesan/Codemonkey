/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: It used to test SPEmailBatch class 
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  10-Jan-2020
* *************************************************************** */
@isTest
public class SPEmailBatchTest
{
    /* ***************************************************************
    * @description: This function used for code coverage 
    * @Change:  
    * *************************************************************** */
    @isTest
    static public void TestMeth()
    {
        //declare variable with hardcoded OwnerID
        String iOwnerID = '005610000020lCoAAI';
        //Dummy Data addition code
        //fetch standard user profile based on the SOQL
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        //create user with standard profile
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
        //insert user record
        insert u;
        //create account object with dummy data        
        Account pAcc = new Account(Name='Parent TestAcc');
        //insert account data
        insert pAcc;
        //create a list of account object
        List<Account> lstAcc = new List<Account>();
        //create a multiple account using below loop
        for (Integer i=1;i<=10;i++){
            Account a = new Account(Name='TestAcc-' + string.valueOf(i), OwnerId = iOwnerID, ParentId = pAcc.Id);
            lstAcc.add(a);
        }
        //use below statement to avoid the Multiple DML execution exception
        system.runAs(u){
            //insert list of accounts
            insert lstAcc;
        }
        //create list of Sales Planner object
        List<Sales_Planner__c> lstSP = new List<Sales_Planner__c>();
        //create salesplanner record using loop
        for (Integer i=1;i<=10;i++){
            //create SalesPlanner record
            Sales_Planner__c sp = new Sales_Planner__c(Name='zensarTest-' + string.valueOf(i) ,Sales_Planner_Year__c='2020',
                                                       Account_Sales_Planner__c=lstAcc[i-1].Id);
            lstSP.add(sp);
        }
        //insert listo f Sales Planner records
        insert lstSP;
         
        //declare the Task List and event list object
        List<Task> lstTask = new List<Task>();
        List<Event> lstEvent = new List<Event>();
        //fetch SalesPlanner record using SOQL 
        List<Sales_Planner__c> splist = [select id,Account_Sales_Planner__c,name,Sales_Planner_Year__c,
                                         Account_Sales_Planner__r.OwnerId,Untouched_Days__c,Account_Owner__c,Account_Owner_ID__c from Sales_Planner__c where Id in: lstSP];
        //loop through the List of Sales Planner
         Date dt;
        for (Integer i=0;i<splist.size();i++){
            //check the i values
            if (i==0 || i==2 || i==4 || i==6 || i==8 || i==10){
                //create task record with dummy values               
                if (dt==null){
                    dt = system.today().addDays(-31);
                }
                else{
                    dt = dt.addDays(-31);
                }
                Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task-' + i,
                                        ActivityDate = dt,whatId = splist[i].Id,OwnerId=iOwnerID, type='In Person',
                                        ActivityDateTime__c=dt,TaskSalesplannerDetails__c='Address');
                //add task records in the list
                lstTask.add(newTask);
            }
            else{
                //declare variable with dynamic value
                DateTime eDate = system.today().addDays(-8*(i+1));
                //add 60 minutes
                eDate = eDate.addMinutes(60);
                //create event records with dummy values
                Event nEvent = new Event(Subject='Test Event -' + i,
                                         StartDateTime = system.today().addDays(-8*(i+1)),  type='In Person',
                                         EndDateTime = eDate,
                                         whatId = splist[i].Id, OwnerId=iOwnerID);
                //add events records in the list
                lstEvent.add(nEvent);
            }            
        }
        //loop through the List of Sales Planner
        for (Integer i=0;i<splist.size();i++){
            //create task record with dummy values
            Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task-' + i,
                                    ActivityDate = system.today().addDays(-75*(i+1)),whatId = splist[i].Id,OwnerId=iOwnerID, type='Email',
                                    ActivityDateTime__c=system.today().addDays(-75*(i+1)),TaskSalesplannerDetails__c='Address');
            //add task records in the list
            lstTask.add(newTask);
        }
        //insert task  list 
        insert lstTask;      
        //insert event list
        insert lstEvent;
        
        //**********************************
        //declare the BatchableContext 
        Database.BatchableContext BC;
        //start the code coverage execution
        Test.startTest();
        //create the SPEmailBatch object
        SPEmailBatch obj = new SPEmailBatch();
        //execute the SPEmailBatch class method
        DataBase.executeBatch(obj); 
        //stop the code coverage execution
        Test.stopTest();
    }
}