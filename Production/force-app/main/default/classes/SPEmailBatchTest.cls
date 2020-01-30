@isTest
public class SPEmailBatchTest
{
    @isTest
	 static public void TestMeth()
    {
        String iOwnerID = '005610000020lCoAAI';
        //Dummy Data addition code
        
         Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
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
       insert u;
        
        
        Account pAcc = new Account(Name='Parent TestAcc');
        insert pAcc;
       
        List<Account> lstAcc = new List<Account>();
        for (Integer i=1;i<=6;i++){
            Account a = new Account(Name='TestAcc-' + string.valueOf(i), OwnerId = iOwnerID, ParentId = pAcc.Id);
            lstAcc.add(a);
        }
        system.runAs(u){
        insert lstAcc;
            system.debug(lstAcc);
        }
        
        List<Sales_Planner__c> lstSP = new List<Sales_Planner__c>();
        for (Integer i=1;i<=6;i++){
            
            Sales_Planner__c sp = new Sales_Planner__c(Name='zensarTest-' + string.valueOf(i) ,Sales_Planner_Year__c='2019',
                                                       Account_Sales_Planner__c=lstAcc[i-1].Id);
            lstSP.add(sp);
        }
        insert lstSP;
        system.debug(lstSP);
        
        
        List<Task> lstTask = new List<Task>();
        List<Event> lstEvent = new List<Event>();
        
        List<Sales_Planner__c> splist = [select id,Account_Sales_Planner__c,name,Sales_Planner_Year__c,
                                         Account_Sales_Planner__r.OwnerId,Untouched_Days__c,Account_Owner__c,Account_Owner_ID__c from Sales_Planner__c where Id in: lstSP];
        for (Integer i=0;i<splist.size();i++){
            if (i==0 || i==2 || i==4 || i==6){
                system.debug('Each Record values : '+ splist[i]);
                Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task-' + i,
                                        ActivityDate = system.today().addDays(-65*(i+1)),whatId = splist[i].Id,OwnerId=iOwnerID, type='In Person',
                                        ActivityDateTime__c=system.today().addDays(-65*(i+1)),TaskSalesplannerDetails__c='Address');
                lstTask.add(newTask);
            }
            else{
                DateTime eDate = system.today().addDays(-8*(i+1));
                eDate = eDate.addMinutes(60);
                
                Event nEvent = new Event(Subject='Test Event -' + i,
                                         StartDateTime = system.today().addDays(-8*(i+1)),  type='In Person',
                                         EndDateTime = eDate,
                                         whatId = splist[i].Id, OwnerId=iOwnerID);
                lstEvent.add(nEvent);
            }            
        }
        
        for (Integer i=0;i<splist.size();i++){
                system.debug('Each Record values : '+ splist[i]);
                Task newTask = new Task(CreateEventWhenTaskCreated__c = true,Status='Open',Subject='Test task-' + i,
                                        ActivityDate = system.today().addDays(-75*(i+1)),whatId = splist[i].Id,OwnerId=iOwnerID, type='Email',
                                        ActivityDateTime__c=system.today().addDays(-75*(i+1)),TaskSalesplannerDetails__c='Address');
                lstTask.add(newTask);
        }
        
        insert lstTask;        
        insert lstEvent;
        
        //**********************************
        Database.BatchableContext BC;
        
        Test.startTest();
            SPEmailBatch obj = new SPEmailBatch();
            DataBase.executeBatch(obj); 
        	//obj.execute(BC, lstSP);
        Test.stopTest();
    }
}