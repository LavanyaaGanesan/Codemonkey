@isTest
public class SalesPlannerEmailHelperTest 
{    
    @isTest
    public static void SalesPlannerEmailHelperTestAllCondition()
    {
        String iOwnerID = '005610000020lCoAAI';
        //Dummy Data addition code
        //
        Account pAcc = new Account(Name='Parent TestAcc');
        insert pAcc;
        
        List<Account> lstAcc = new List<Account>();
        for (Integer i=1;i<=6;i++){
            Account a = new Account(Name='TestAcc-' + string.valueOf(i), OwnerId = iOwnerID, ParentId = pAcc.Id);
            lstAcc.add(a);
        }
        insert lstAcc;
        
        List<Sales_Planner__c> lstSP = new List<Sales_Planner__c>();
        for (Integer i=1;i<=6;i++){
            
            Sales_Planner__c sp = new Sales_Planner__c(Name='zensarTest-' + string.valueOf(i) ,Sales_Planner_Year__c='2019',
                                                       Account_Sales_Planner__c=lstAcc[i-1].Id);
            lstSP.add(sp);
        }
        insert lstSP;
        
        List<Task> lstTask = new List<Task>();
        List<Event> lstEvent = new List<Event>();
        
        List<Sales_Planner__c> splist = [select id,Account_Sales_Planner__c,name,Sales_Planner_Year__c,
                                         Account_Sales_Planner__r.OwnerId,Untouched_Days__c,Account_Owner__c from Sales_Planner__c where Id in: lstSP];
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
        
        //******************************************        
        
        // global variables
        List<pvEmailBatchConf__mdt> b_EmailBatchConf =  Database.query(System.Label.pvEmailBatchConfQuery);
        List<User> b_UserList;
        List<Sales_Planner__c> b_SPList;
        List<Task> b_TaskList;
        List<Event> b_EventList;
        List<pvSalesPlannerEmailFormats__mdt> b_EmailFormatMetaData;
        //List<csvBatchFormat> b_CsvBatchFormat =  new List<csvBatchFormat>();
        List<Messaging.SingleEmailMessage> b_EmailList = new List<Messaging.SingleEmailMessage>();
        
        //Get User List
        b_UserList = Database.query(b_EmailBatchConf[0].UserQuery__c);
        //***********************************************************
        //Start : Getting UserIDs in string 
        //***********************************************************
        String userID ='';
        Integer c = 0;
        Integer cTotal = b_UserList.size();
        for (User u : b_UserList){
            c++;
            userID += '\'' + u.Id + '\'' + (c<ctotal ? ',':'');
        }
        System.debug('userID :' + userID +' End');
        //***********************************************************
        //End : Getting UserIDs in string 
        //***********************************************************
        
        String spQuery = b_EmailBatchConf[0].SalesPlannerQuery__c;
        spQuery = spQuery.replace('##USERIDS##',userID);
        System.debug('spQuery :' + spQuery);
        System.debug('TaskQuery__c :' + b_EmailBatchConf[0].TaskQuery__c);
        System.debug('EventQuery__c :' + b_EmailBatchConf[0].TaskQuery__c);
        System.debug('EmailFormatMetadataQuery__c :' + b_EmailBatchConf[0].EmailFormatMetadataQuery__c);
        
        b_SPList = Database.query(spQuery);
        
        b_TaskList = Database.query(b_EmailBatchConf[0].TaskQuery__c);
        b_EventList = Database.query(b_EmailBatchConf[0].EventQuery__c);
        b_EmailFormatMetaData = Database.query(b_EmailBatchConf[0].EmailFormatMetadataQuery__c);
        
        
        Messaging.sendEmail(b_EmailList);
        //******************************************
        
        system.Test.startTest();
        b_EmailList = SalesPlannerEmailHelper.setEmailsToSPOwnerAndManager(b_SPList, b_UserList, b_TaskList, b_EventList, b_EmailFormatMetaData,b_EmailBatchConf );
        system.Test.stopTest();
    }
}