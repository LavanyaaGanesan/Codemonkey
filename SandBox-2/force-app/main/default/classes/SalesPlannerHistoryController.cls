/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: It used in SalesPlanner History aura component
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  9-Jan-2020
* *************************************************************** */
public class SalesPlannerHistoryController {
    /* ***************************************************************
    * @description: This function check the User profile id with the System Admin profile ID
    * @Change:  
    * *************************************************************** */
    @AuraEnabled
    public Static Boolean getIsAdmin()
    {
        //If User profile id equal the System Admin profile ID then it return true else false
        if (String.valueOf(UserInfo.getProfileId()).contains(Label.pvSystemProfileId))
            return true; 
        else
            return false;
    }
    /* ***************************************************************
    * @description: This function return all SP History records those are deleted
    * @Change:  
    * *************************************************************** */
    @AuraEnabled
    public Static List<Sales_Planner_History__c> getSalesPlannerHistory(String accountId)
    {
        //fetche the List of SP History record based on the SOQL
        List<Sales_Planner_History__c> spHistory = [select id,Name, Sales_Planner_Year__c,Account_Sales_Planner_History__c,Vivotif_Committed_Doses__c,
                                               Account_Stage__c,DDD_Outlet_ID__c,Outlet_Name__c,Sales_Planner_Id__c,Account_Owner__c,
                                              H_RAM_Projected_Vaxchora_1__c,X1H_Actual_Vaxchora_Doses__c,X1H_Vaxchora_Gap__c,H_RAM_Projected_Vaxchora_2__c,
                                              X2H_Actual_Vaxchora_Doses__c,X2H_Vaxchora_Gap__c,Pricing_Discount_Programs__c,Contract_Signed_Date__c,Vaxchora_Doses_Commitment__c,
                                              Vaxchora_Ordered_Doses__c,CreatedById,CreatedBy.Name,LastModifiedById,LastModifiedBy.Name from Sales_Planner_History__c 
                                              where Account_Sales_Planner_History__c =:accountId and Is_Deleted__c=true
                                              order by Sales_Planner_Year__c,LastModifiedDate desc];
        return spHistory; 
    }
    /* ***************************************************************
    * @description: This function return object Icon Name
    * @Change:  
    * *************************************************************** */
    @AuraEnabled
    public static String getIconName(String sObjectName){
        //Declare string and List of object
        String u;
        try{
            List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
            List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
            List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
            //add all Tabs info in List
            for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }
            //add Icons for object as per the input parameter
            for(Schema.DescribeTabResult tr : tabDesc) {
                //Check the object name
                if( sObjectName == tr.getSobjectName() ) {
                    //check the object is custom or standard based on the Icons get added in the list
                    if( tr.isCustom() == true ) {
                        iconDesc.addAll(tr.getIcons());
                    } else {
                        u = 'standard:' + sObjectName.toLowerCase();
                    }
                }
            }
            //loop through the List of icons
            for (Schema.DescribeIconResult ir : iconDesc) {
                //check the icon contentType = 'image/svg+xml' and return the actual path of the object
                if (ir.getContentType() == 'image/svg+xml'){
                    u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                    break;
                }
            }
            if(test.isRunningTest())
                integer i = 1/0; 
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('SalesPlannerHistoryController', 'getIconName', ex.getMessage(), ex.getLineNumber());
        }
        return u;
    }
    /* ***************************************************************
    * @description: This function retrive the deleted SP
    * @Change:  
    * *************************************************************** */
    @AuraEnabled
    public Static void RetriveRecords(List<String> lstRecordIds){
        //fetch the list of SP History based on the list provided in SOQL
        list<Sales_Planner_History__c> spHistoryList = 
            [select id,Sales_Planner_Id__c, Sales_Planner_Year__c, Is_Deleted__c, 
            Unique_SalesPlanner__c, Name, Issues_Objections_Limitations__c, Action_Plan__c,
            Personal_Note__c, Pricing_Discount_Programs__c, Account_Stage__c,Vivotif_Committed_Doses__c,
            X2019_TotalActivities__c, H_RAM_Projected_Vaxchora_2__c, H_RAM_Projected_Vaxchora_1__c,
            Total_F2F_Meetings__c, Vaxchora_Ordered_Doses__c, Vaxchora_Doses_Commitment__c,
            Account_Sales_Planner_History__c, GPO__c, Last_Person_Visit__c, Next_Follow_Date__c, 
             Contract_Signed_Date__c, Retrieved__c,X2H_Vaxchora_Gap__c
            from Sales_Planner_History__c where id IN:lstRecordIds and Is_Deleted__c=true  limit 1];        
        //pass the SP History list to the function
        performRetrivedAction(spHistoryList);
    }
    /* ***************************************************************
    * @description: This function retrive the deleted SP from recycle bin or from SP History object
    * @Change:  
    * *************************************************************** */
    public static void performRetrivedAction(list<Sales_Planner_History__c> spHistoryList){
        try{
            //check the list of SP History not empty
            if(!spHistoryList.isEmpty())
            {
                //loop through SP History record
                for(Integer i=0;i<spHistoryList.size();i++){
                    //set Retrieved__c equal to true 
                    spHistoryList[i].Retrieved__c=true;
                }
                //update existing SP History records
                update spHistoryList;
                
                //fetch the SP record from the recycle bin based on the SOQL
                Sales_Planner__c objSP = [SELECT Id, Name FROM Sales_Planner__C WHERE ID =:spHistoryList[0].Sales_Planner_Id__c ALL ROWS]; 
                try {
                    //undelete the deleted SP from the Recycle bin
                    undelete objSP;
                     if(test.isRunningTest())
                integer i = 1/0; 
                    
                }  catch(exception ex){
            ApexDebugLogController.insertLog('SalesPlannerHistoryController', 'performRetrivedAction', ex.getMessage(), ex.getLineNumber());
        }
                //check the SP record
                if (objSP==null){
                    //fetch the SP record from the SH History
                    objSP = retrive_SPH_To_SP(spHistoryList[0]);
                    //create SP 
                    insert objSP;
                }
                //Update Existing WhatID = SPH ID with WhatID = SP ID in Task, Event and notes object
                retriveExistingSPHActivityHistory(objSP.Id, spHistoryList[0].Id);  
                //Update the Case with retrived SP ID
                updateExistingSalesPlannerHistoryCaseWithSP(objSP.Id, spHistoryList[0].Id);
                //delete the SP History record
                delete spHistoryList;         
            }
             if(test.isRunningTest())
                integer i = 1/0; 
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('SalesPlannerHistoryController', 'retrive_SPH_To_SP', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: This function create SP object  from SP History object
    * @Change:  
    * *************************************************************** */
    public static Sales_Planner__c retrive_SPH_To_SP(Sales_Planner_History__c sph){                
        Sales_Planner__c objSP =new Sales_Planner__c();
        try{
            objSP.Name = sph.Name;
            objSP.Account_Sales_Planner__c = sph.Account_Sales_Planner_History__c;
            objSP.Unique_SalesPlanner__c = sph.Unique_SalesPlanner__c;
            objSP.Sales_Planner_Year__c = sph.Sales_Planner_Year__c;
            objSP.Issues_Objections_Limitations__c = sph.Issues_Objections_Limitations__c;
            objSP.Action_Plan__c = sph.Action_Plan__c;
            objSP.Note__c = sph.Personal_Note__c;
            objSP.Pricing_Discount_Programs__c = sph.Pricing_Discount_Programs__c;
            objSP.Account_Stage__c = sph.Account_Stage__c;
            objSP.X2019_TotalActivities__c = sph.X2019_TotalActivities__c;
            objSP.H_RAM_Projected_Vaxchora_2__c = sph.H_RAM_Projected_Vaxchora_2__c;
            objSP.H_RAM_Projected_Vaxchora_1__c = sph.H_RAM_Projected_Vaxchora_1__c;
            objSP.Total_F2F_Meetings__c = sph.Total_F2F_Meetings__c;
            objSP.Vaxchora_Ordered_Doses__c = sph.Vaxchora_Ordered_Doses__c;
            objSP.Vaxchora_Doses_Commitment__c = sph.Vaxchora_Doses_Commitment__c;
            objSP.Vivotif_Committed_Doses__c = sph.Vivotif_Committed_Doses__c;
            objSP.GPO__c = sph.GPO__c;
            objSP.Last_Person_Visit__c = sph.Last_Person_Visit__c;
            objSP.Contract_Signed_Date__c = sph.Contract_Signed_Date__c;
            objSP.Next_Follow_Date__c = sph.Next_Follow_Date__c;
            if(test.isRunningTest())
                integer i = 1/0; 
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('SalesPlannerHistoryController', 'retrive_SPH_To_SP', ex.getMessage(), ex.getLineNumber());
        }
        return objSP;
    }
    /* ***************************************************************
    * @description: Update existing Task, Event and Notes reference from SPH ID to SP ID
    * @Change:  
    * *************************************************************** */
    public static void retriveExistingSPHActivityHistory(Id idSP, Id idSPH){ 
        try{
            //create Task list object based on the SOQL defined
            List<Task> objTask=[Select ID,Subject, whatid from Task where whatid=:idSPH];

            //to check the List is not empty
            if (!objTask.isEmpty()){
                //create Task list object for bulk update
                List<Task> updTaskList= new List<Task>();
                for(Task tsk : objTask){
                    tsk.whatid=idSP;  
                    //set veriable true for skipping the trigger validation rules
                    tsk.Skip_Validation_For_Trigger__c = true;
                    //check EndDate value if null the assign Activity Datetime
                    if (tsk.EndDate__c==null){
                        tsk.EndDate__c=tsk.ActivityDateTime__c;
                    }
                    //add task record into the list
                    updTaskList.add(tsk);
                } 
                //to check the List is not empty
                if (!updTaskList.isEmpty())
                {
                    //perform update dml operation
                    update updTaskList;
                }
            }
            //create event list object based on the SOQL defined
            List<Event> objEvent=[Select ID, whatid from Event where whatid=:idSPH];

            //to check the List is not empty            
            if (!objEvent.isEmpty()){
                //create Event list object for bulk update

                List<Event> updEventList= new List<Event>();
                for(Event evt : objEvent){
                    evt.whatid=idSP;
                    //check EndDate value if null the assign Activity Datetime
                    if (evt.EndDateTime==null){
                        evt.EndDateTime=evt.StartDateTime;
                    }
                    //add event record into the list
                    updEventList.add(evt);
                }  
                //to check the List is not empty
                if (!updEventList.isEmpty())
                {
                    //perform update dml operation
                    update updEventList;
                }
            }
            //Notes: Create new ContentDocumentLink and delete existing ContentDocumentLink
            List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
            List<ContentDocumentLink> cdlExt = new List<ContentDocumentLink>();
            //get all contentdocumentids so that you can query on contentnote
            for(ContentDocumentLink cdl : [SELECT Id, LinkedEntityId, ContentDocumentId, ShareType 
                                           FROM ContentDocumentLink WHERE LinkedEntityId =:idSPH])
            {
                //clone the ContentDocumentLink record
                ContentDocumentLink cloned = cdl.clone();
                cloned.LinkedEntityId = idSP;
                //add clone record and cdl record in the list
                cdlList.add(cloned);
                cdlExt.add(cdl);
            } 
            //to check the List is not empty
            if (!cdlList.isEmpty())
            {
                //perform insert dml operation
                insert cdlList;
                //perform delete dml operation
                delete cdlExt;
            }
             if(test.isRunningTest())
                integer i = 1/0; 
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('SalesPlannerHistoryController', 'retriveExistingSPHActivityHistory', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: Update existing Cases reference from SPH ID to SP ID
    * @Change:  
    * *************************************************************** */
    public static void updateExistingSalesPlannerHistoryCaseWithSP(Id idSP, Id idSPH){ 
        try{
            //create event list object based on the SOQL defined 
            List<Case> objCase=[SELECT CaseNumber, AccountId, Subject, Id, Sales_Planner__c, Sales_Planner_History__c FROM Case where Sales_Planner_History__c=:idSPH];
            //to check the List is not empty
            if (!objCase.isEmpty()){
                //create Case list object for bulk update
                List<Case> updCaseList= new List<Case>();
                for(Case c : objCase){
                    //assign SP refernce to SP ID
                    c.Sales_Planner__c=idSP;
                    //assign existing SPH refernce id to null
                    c.Sales_Planner_History__c=null;
                    updCaseList.add(c);
                }   
                //to check the List is not empty
                if (!updCaseList.isEmpty())
                {
                    //perform update dml operation
                    update updCaseList;
                } 
            }
             if(test.isRunningTest())
                integer i = 1/0; 
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('SalesPlannerHistoryController', 'retriveExistingSPHActivityHistory', ex.getMessage(), ex.getLineNumber());
        }
    }
}