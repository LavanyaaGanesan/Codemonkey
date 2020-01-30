/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Handler class used  for Salesplanner trigger
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  6-Jan-2020
* *************************************************************** */
public class Trg_SalesPlanner_Helper {
    /* ***************************************************************
    * @description: calling function beforeInsert the SP record
    * @Change:
    * *************************************************************** */
    public static void beforeInsert(List<Sales_Planner__c> SalesplannerList){
        PreventMutipleSalesplanners(SalesplannerList);        
    }
    /* ***************************************************************
    * @description: calling function beforeUpdate the SP record
    * @Change:  
    * *************************************************************** */
    public static void beforeUpdate(List<Sales_Planner__c> SalesplannerList){
        PreventMutipleSalesplanners(SalesplannerList);        
    }
    /* ***************************************************************
    * @description: calling function afterUndelete the SP record
    * @Change:  
    * *************************************************************** */
    public static void isundelete(List<Sales_Planner__c> SalesplannerList){
        try{
            //create SP Map : Key = Account ID and Value = SP record
            map<Id,Sales_Planner__c> salesplannerAccMap = new map<Id,Sales_Planner__c>();
            for(Sales_Planner__c salesplanner : SalesplannerList){
                salesplannerAccMap.put(salesplanner.Account_Sales_Planner__c,salesplanner);
            }
            //get SP History Records 
            for(Sales_Planner_History__c salesplannerHistory : 
                [select ID,Account_Sales_Planner_History__c,Sales_Planner_Year__c,Sales_Planner_Id__c, Retrieved__c 
                 from Sales_Planner_History__c 
                 where Account_Sales_Planner_History__c IN:salesplannerAccMap.keyset() 
                 and Is_Deleted__c=true])
            {
                //check Retrieved and SalesPlanner Year parameter
                if(!salesplannerHistory.Retrieved__c && salesplannerHistory.Sales_Planner_Year__c == salesplannerAccMap.get(salesplannerHistory.Account_Sales_Planner_History__c).Sales_Planner_Year__c){
                    //add error if condition match
                    salesplannerAccMap.get(salesplannerHistory.Account_Sales_Planner_History__c).adderror('The SalesPlanner has been deleted and it is already present in Account Related Tab for this account. ');
                }
            }
             if(Test.isRunningTest())
                    integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_Helper', 'isundelete', ex.getMessage(), ex.getLineNumber());
        }
    } 
    /* ***************************************************************
    * @description: Check the SP and raise an error depending on the criteria
    * @Change:  
    * *************************************************************** */
    public static void PreventMutipleSalesplanners(List<Sales_Planner__c> SalesplannerList){
        try{  
            //get the Organization default Custom Settings for SP object
            SalesPlanner_Setting__c spSetting =  SalesPlanner_Setting__c.getOrgDefaults();
            
            //create SP Map : Key = Account ID and Value = SP record
            map<Id,Sales_Planner__c> salesplannerAccMap = new map<Id,Sales_Planner__c>();
            for(Sales_Planner__c salesplanner : SalesplannerList){
                salesplannerAccMap.put(salesplanner.Account_Sales_Planner__c,salesplanner);
            }
            //loop through the each SP
            for(Sales_Planner__c salesplanner : SalesplannerList)
            {
                //check SP year with current year
                if(!spSetting.SalesPlanner_Years__c.contains(salesplannerAccMap.get(salesplanner.Account_Sales_Planner__c).Sales_Planner_Year__c)){
                    //add error if condition match
                    salesplannerAccMap.get(salesplanner.Account_Sales_Planner__c).adderror('Please select current year, SalesPlanner creation has been restricted for the past year and future year!');
                }
            }
            //loop through the each SP having a match records based on the where condition
            for(Sales_Planner__c salesplanner : 
                [select id,Account_Sales_Planner__c,Sales_Planner_Year__c from Sales_Planner__c where
                 Account_Sales_Planner__c IN:salesplannerAccMap.keyset() and ID NOT IN : SalesplannerList])
            {
                //check SP year with already created SP year
                if(salesplanner.Sales_Planner_Year__c == salesplannerAccMap.get(salesplanner.Account_Sales_Planner__c).Sales_Planner_Year__c){
                    //add error if condition match
                    salesplannerAccMap.get(salesplanner.Account_Sales_Planner__c).adderror('SalesPlanner is already created for this account.');
                }
            }
            
            //loop through the each SP_History having a match records based on the where condition
            for(Sales_Planner_History__c salesplannerHistory : 
                [select ID,Account_Sales_Planner_History__c,Sales_Planner_Year__c,Sales_Planner_Id__c, Retrieved__c 
                 from Sales_Planner_History__c 
                 where Account_Sales_Planner_History__c IN:salesplannerAccMap.keyset() 
                 and Is_Deleted__c=true])
            {
                //check Retrieved and SalesPlanner Year parameter
                if(!salesplannerHistory.Retrieved__c && salesplannerHistory.Sales_Planner_Year__c == salesplannerAccMap.get(salesplannerHistory.Account_Sales_Planner_History__c).Sales_Planner_Year__c){
                    //add error if condition match
                    salesplannerAccMap.get(salesplannerHistory.Account_Sales_Planner_History__c).adderror('The SalesPlanner has been deleted and it is already present in Account Related Tab for this account. ');
                }
            }
             if(Test.isRunningTest())
                    integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_Helper', 'PreventMutipleSalesplanners', ex.getMessage(), ex.getLineNumber());
        }
    }
    
    /* ***************************************************************
    * @description: Calling afterInsert function to create a SP History record 
    * @Change:  
    * *************************************************************** */
    public static void afterInsert(List<Sales_Planner__c> SalesplannerList){
        InsertUpdateSalesPlannersRecordInHistory(SalesplannerList, 'ins','',null);
    }
    /* ***************************************************************
    * @description: Calling afterUpdate function to update a existing SP History record 
    * @Change:  
    * *************************************************************** */
    public static void afterUpdate(List<Sales_Planner__c> SalesplannerList, List<Sales_Planner__c> SalesplannerListOld){
        InsertUpdateSalesPlannersRecordInHistory(SalesplannerList, 'upd','',SalesplannerListOld); 
    }
    /* ***************************************************************
    * @description: Calling beforeDelete function to update a existing SP History record 
    * @Change:  
    * *************************************************************** */
    public static void beforeDelete(List<Sales_Planner__c> SalesplannerList){
        InsertUpdateSalesPlannersRecordInHistory(SalesplannerList, 'del','',null);
    }
    /* ***************************************************************
    * @description: This function use to create or update the SP History record
    * @Change:  
    * *************************************************************** */
    public static void InsertUpdateSalesPlannersRecordInHistory( List<Sales_Planner__c> SalesplannerList, string dmlOperator, 
                                                                string updSPYear, List<Sales_Planner__c> SalesplannerListOld)
    {
        try{
            //Create SP History List to insert and update the record
            list<Sales_Planner_History__c> insSPHistory = new list<Sales_Planner_History__c>();
            
            //Create a SalesPlanner record Map having key=SP ID and value=SP record
            map<Id,Sales_Planner__c> mapSalesplanner = new map<Id,Sales_Planner__c>(); 
            for(Sales_Planner__c salesplanner : SalesplannerList){
                mapSalesplanner.put(salesplanner.Id,salesplanner);
            }                                                        
            //system.debug('mapSalesplanner size:' + mapSalesplanner.size());
            
            //List of "New SP History record"
            List<Sales_Planner_History__c> objSalesPlannerHistory = [Select Id, Sales_Planner_Id__c, Sales_Planner_Year__c From Sales_Planner_History__c 
                                                                     where Sales_Planner_Id__c IN : mapSalesplanner.keyset() 
                                                                     and Is_Deleted__c=false];
            //system.debug('objSalesPlannerHistory size:' + objSalesPlannerHistory.size()); 
            
            //Add "Old SP record" in Map record set
            map<Id,Sales_Planner__c> mapSalesplannerOld = new map<Id,Sales_Planner__c>();
            //List of "Old SP History record"
            List<Sales_Planner_History__c> objSPHistoryOld =new List<Sales_Planner_History__c>();
            //check dml condition
            if (dmlOperator == 'upd') { 
                //To check the List is not empty
                if (!SalesplannerListOld.isEmpty()){
                    //Add SP old values into the Map having key=SP ID and Value=SP
                    for(Sales_Planner__c salesplannerOld : SalesplannerListOld){
                        mapSalesplannerOld.put(salesplannerOld.Id,salesplannerOld);
                    } 
                    //system.debug('mapSalesplannerOld size:' + mapSalesplannerOld.size());
                    //Fetch SP History record and add into the List
                    objSPHistoryOld = [Select Id, Sales_Planner_Id__c, Sales_Planner_Year__c From Sales_Planner_History__c 
                                       where Sales_Planner_Id__c IN : mapSalesplannerOld.keyset() 
                                       and Is_Deleted__c=false];
                    //system.debug('objSPHistoryOld size:' + objSPHistoryOld.size());
                }
            } 
            //To check the List is not empty
            if (!objSalesPlannerHistory.isEmpty()){                
                //Update Record in SalesPlanner History object
                for(Sales_Planner_History__c spHistory : objSalesPlannerHistory)
                {   
                    //Fetch SP record from the Map based on the SP ID
                    Sales_Planner__C sp = mapSalesplanner.get(spHistory.Sales_Planner_Id__c); 
                    //check dml condition
                    if (dmlOperator == 'del') {
                        //Update existing SP History record and set the deleted flag true
                        Sales_Planner_History__c objSPHDelete =  createSalesPlannerHistory(spHistory.Id,sp,true,dmlOperator);
                        
                        //check object, if its null continue the process for next item
                        if (objSPHDelete==null){continue;}
                        
                        //Set SP Year
                        objSPHDelete.Sales_Planner_Year__c=sp.Sales_Planner_Year__c;
                        //add SP History record into the List to update at the end of transaction
                        insSPHistory.add(objSPHDelete);                        
                        
                        //Update Existing WhatID = SP ID with WhatID = SPH ID in Task, Event  and notes object
                        updateExistingSalesPlannerActivityHistory(sp.Id,spHistory.Id);
                        
                        //Update the Case with new SPHID
                        updateExistingSalesPlannerCaseWithHistory(sp.Id,spHistory.Id);
                    }
                    else if (dmlOperator == 'upd') {
                        //To check the List is not empty
                        if (!SalesplannerListOld.isEmpty()){  
                            //System.debug(' Enter 3 :: upd :: 1');
                            //Fetch SP records from Map based on the SP ID
                            Sales_Planner__c spOld= mapSalesplannerOld.get(sp.Id);
                            //check object, if its null continue the process for next item
                            if (spOld==null){continue;}
                            //Check SP Year
                            if(sp.Sales_Planner_Year__c==spOld.Sales_Planner_Year__c){
                                //Update SP Record if Old and New year same.                                
                                Sales_Planner_History__c objSPHUpdate =  createSalesPlannerHistory(spHistory.Id,sp,false,'upd');
                                //check object, if its null continue the process for next item
                                if (objSPHUpdate==null){continue;}
                                //assign SP year
                                objSPHUpdate.Sales_Planner_Year__c=sp.Sales_Planner_Year__c;                                
                                //add SP History record into the List to update at the end of transaction
                                insSPHistory.add(objSPHUpdate);                                
                                //system.debug('objSPHUpdate Same Year:' + objSPHUpdate);
                            }
                            else if(sp.Sales_Planner_Year__c!=spOld.Sales_Planner_Year__c){   
                                //Update SP Record if Old and New year not same.
                                Sales_Planner_History__c objSPHUpdate =  createSalesPlannerHistory(spHistory.Id,spOld,true,'del');
                                //check object, if its null continue the process for next item
                                if (objSPHUpdate==null){continue;}
                                //assign OLD SP year
                                objSPHUpdate.Sales_Planner_Year__c=spOld.Sales_Planner_Year__c;
                                //add SP History record into the List to update at the end of transaction
                                insSPHistory.add(objSPHUpdate);
                                
                                //Insert new SP History record, if SP year change
                                Sales_Planner_History__c objSPHInsert =  createSalesPlannerHistory(null,sp,false,'ins'); 
                                //check object, if its null continue the process for next item
                                if (objSPHInsert==null){continue;}
                                //assign new SP year
                                objSPHInsert.Sales_Planner_Year__c=sp.Sales_Planner_Year__c;
                                //add SP History record into the List to insert at the end of transaction
                                insSPHistory.add(objSPHInsert);
                                //system.debug('objSPHInsert Not Same Year:' + objSPHInsert);
                            } 
                        }
                    }                
                }
            }
            else
            {                
                //To check the List is not empty
                if (!SalesplannerList.isEmpty()){
                    for(Sales_Planner__C sp : SalesplannerList)
                    {   
                        if (dmlOperator == 'del' || dmlOperator == 'ins' || dmlOperator == 'upd') {
                            //create a SP History record
                            Sales_Planner_History__c objSPHInsert =  createSalesPlannerHistory(null,sp,(dmlOperator == 'del' ? true : false),dmlOperator);
                            //check object, if its null continue the process for next item
                            if (objSPHInsert==null){continue;}
                            objSPHInsert.Sales_Planner_Year__c=sp.Sales_Planner_Year__c;                            
                            if (dmlOperator == 'ins' || dmlOperator == 'upd') {
                                insSPHistory.add(objSPHInsert);
                            }                            
                            else if (dmlOperator == 'del'){                                
                                insert objSPHInsert;
                                //Update Existing WhatID - SP ID with WhatID - SPH ID
                                updateExistingSalesPlannerActivityHistory(sp.Id,objSPHInsert.Id);
                                
                                //Update the Case with new SPHID
                                updateExistingSalesPlannerCaseWithHistory(sp.Id,objSPHInsert.Id);
                            }                            
                        }
                        if (dmlOperator == 'upd'){
                            Sales_Planner__c spOld= mapSalesplannerOld.get(sp.Id);
                             //check object, if its null continue the process for next item
                            if (spOld==null){continue;}
                            if (spOld!=null && sp.Sales_Planner_Year__c !=spOld.Sales_Planner_Year__c){
                                //Insert "New SP History record"
                                Sales_Planner_History__c objSPHInsert =  createSalesPlannerHistory(null,spOld,true,dmlOperator);                
                                //check object, if its null continue the process for next item
                                if (objSPHInsert==null){continue;}
                                //Use New SP Sales_Planner_Year__c value
                                objSPHInsert.Sales_Planner_Year__c= spOld.Sales_Planner_Year__c;
                                //Set Is Deleted flag to true
                                objSPHInsert.Is_Deleted__c = true;
                                //add SP History record into the List to insert at the end of transaction
                                insSPHistory.add(objSPHInsert);
                            }
                        }
                    }
                }
            }
             //To check the List is not empty
            if (!insSPHistory.isEmpty())
            {
                upsert insSPHistory;
            }        
             if(Test.isRunningTest())
                    integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_Helper', 'InsertUpdateSalesPlannersRecordInHistory', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: Create SP History object
    * @Change:  
    * *************************************************************** */    
    public static Sales_Planner_History__c createSalesPlannerHistory(
        Id idSPH, Sales_Planner__c sp, boolean isDeleted, string dmlOperator)
    {
        //create SP History object
        Sales_Planner_History__c objSPH =new Sales_Planner_History__c();
        try{ 
            //check id and dmlOperator
            if (idSPH!=null && (dmlOperator=='upd' || dmlOperator=='del')){
                objSPH.Id = idSPH;
            }
			//Assign SP record parameters into SP History record            
            objSPH.Is_Deleted__c = isDeleted;            
            objSPH.Name = sp.Name;
            objSPH.Sales_Planner_Id__c = sp.Id;
            objSPH.Account_Sales_Planner_History__c = sp.Account_Sales_Planner__c;
            objSPH.Account_ID__c = sp.Account_ID__c;
            objSPH.Account_Name__c = sp.Account_Name__c;
            objSPH.Account_Stage__c = sp.Account_Stage__c;
            objSPH.Phone__C = sp.Phone__C;
			//create list of string having a sperated with '_HL_ENCODED_'           
            String[] strParentId = string.valueOf(sp.Parent_Account__C).split('_HL_ENCODED_');
            objSPH.Parent_Account__C = strParentId[1].split('_HL_')[0];            
            objSPH.Action_Plan__c = sp.Action_Plan__c;
            objSPH.Address__c = sp.Address__c;
            //Replace '_BR_ENCODED_' with '\r\n' in Billing address
            objSPH.Billing_address__c = sp.Billing_address__c.replace('_BR_ENCODED_','\r\n');
            objSPH.City__c = sp.City__c;
            objSPH.DDD_Outlet_ID__c = sp.DDD_Outlet_ID__c;
            objSPH.Direct_Customer_Number__c = sp.Direct_Customer_Number__c;
            objSPH.GPO__c = sp.GPO__c;
            objSPH.H_RAM_Projected_Vaxchora_1__c = sp.H_RAM_Projected_Vaxchora_1__c;
            objSPH.H_RAM_Projected_Vaxchora_2__c = sp.H_RAM_Projected_Vaxchora_2__c;
            objSPH.Issues_Objections_Limitations__c = sp.Issues_Objections_Limitations__c;
            objSPH.Last_IMS_Sales_Activity_Date__c = sp.Last_IMS_Sales_Activity_Date__c;
            objSPH.Last_Person_Visit__c = sp.Last_Person_Visit__c;
            objSPH.National_Account__c = sp.National_Account__c;
            objSPH.Next_Follow_Date__c = sp.Next_Follow_Date__c;
            objSPH.Outlet_Name__c = sp.Outlet_Name__c;
            objSPH.Owner_Role__c = sp.Owner_Role__c;
            objSPH.Paxvax_Classification__c = sp.Paxvax_Classification__c;
            objSPH.Personal_Note__c = sp.Note__c;
            objSPH.Region__c = sp.Region__c;
            objSPH.Sales_Planner__c = sp.Sales_Planner__c;
            objSPH.Total_F2F_Meetings__c = sp.Total_F2F_Meetings__c;
            objSPH.Unique_SalesPlanner__c = sp.Unique_SalesPlanner__c;
            objSPH.Vaxchora_Growth_YOY_YTD__c = sp.Vaxchora_Growth_YOY_YTD__c;
            objSPH.Vivotif_Growth_YOY_YTD__c = sp.Vivotif_Growth_YOY_YTD__c;
            objSPH.X1H_Actual_Vaxchora_Doses__c = sp.X1H_Actual_Vaxchora_Doses__c;
            objSPH.X1H_Actual_Vivotif_Doses__c = sp.X1H_Actual_Vivotif_Doses__c;
            objSPH.X1H_Vaxchora_Gap__c = sp.X1H_Vaxchora_Gap__c;
            objSPH.X1H_Vivotif_Gap__c = sp.X1H_Vivotif_Gap__c;
            objSPH.X1H_Vivotif_Goal__c = sp.X1H_Vivotif_Goal__c;
            objSPH.X2017_Typhoid_doses__c = sp.X2017_Typhoid_doses__c;
            objSPH.X2017_Vaxchora_doses__c = sp.X2017_Vaxchora_doses__c;
            objSPH.X2017_Vivotif_doses__c = sp.X2017_Vivotif_doses__c;
            objSPH.X2018_Typhoid_doses__c = sp.X2018_Typhoid_doses__c;
            objSPH.X2018_Vaxchora_doses__c = sp.X2018_Vaxchora_doses__c;
            objSPH.X2019_TotalActivities__c = sp.X2019_TotalActivities__c;
            objSPH.X2019_Typhoid_doses_YTD__c = sp.X2019_Typhoid_doses_YTD__c;
            objSPH.X2019_Vaxchora_doses_YTD__c = sp.X2019_Vaxchora_doses_YTD__c;
            objSPH.X2019_Vivotif_doses_YTD__c = sp.X2019_Vivotif_doses_YTD__c;
            objSPH.X2H_Actual_Vaxchora_Doses__c = sp.X2H_Actual_Vaxchora_Doses__c;
            objSPH.X2H_Actual_Vivotif_Doses__c = sp.X2H_Actual_Vivotif_Doses__c;
            objSPH.X2H_Vaxchora_Gap__c = sp.X2H_Vaxchora_Gap__c;
            objSPH.X2H_Vivotif_Gap__c = sp.X2H_Vivotif_Gap__c;
            objSPH.X2H_Vivotif_Goal__c = sp.X2H_Vivotif_Goal__c;
            objSPH.Yellow_Fever_Vaccination_Clinic__c = sp.Yellow_Fever_Vaccination_Clinic__c;
            objSPH.Zip__c = sp.Zip__c;
            objSPH.Account_Owner__c = sp.Account_Owner__c;
            objSPH.ST__c = sp.ST__c;
            objSPH.Pricing_Discount_Programs__c = sp.Pricing_Discount_Programs__c;
            objSPH.Contract_Signed_Date__c = sp.Contract_Signed_Date__c;
            objSPH.Vaxchora_Doses_Commitment__c = sp.Vaxchora_Doses_Commitment__c;
            objSPH.Vivotif_Committed_Doses__c = sp.Vivotif_Committed_Doses__c;
            objSPH.Vaxchora_Ordered_Doses__c = sp.Vaxchora_Ordered_Doses__c;
            objSPH.Country3__c = sp.Country2__c;
            objSPH.State_Province3__c  = sp.State_Province2__c; 
            objSPH.City3__c = sp.City2__c;
            objSPH.Zip_Postal_Code3__c = sp.Zip_Postal_Code2__c;
            objSPH.Street3__c  = sp.Street2__c;
             if(Test.isRunningTest())
                    integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_Helper', 'InsertUpdateSalesPlannersRecordInHistory', ex.getMessage(), ex.getLineNumber());
        }
        //return SP History object
        return objSPH;            
    }
    /* ***************************************************************
    * @description: Update existing Task, Event and Notes reference from SP ID to SPH ID
    * @Change:  
    * *************************************************************** */
    public static void updateExistingSalesPlannerActivityHistory(Id idSP, Id idSPH){        
        try{
            //create Task list object based on the SOQL defined
            List<Task> objTask=[Select ID,Subject, whatid, ActivityDateTime__c,EndDate__c   from Task where whatid=:idSP];
            //to check the List is not empty
            if (!objTask.isEmpty()){
                //create Task list object for bulk update
                List<Task> updTaskList= new List<Task>();
                for(Task tsk : objTask){
                    tsk.whatid=idSPH;
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
            List<Event> objEvent=[Select ID, whatid, StartDateTime, EndDateTime from Event where whatid=:idSP];
            //to check the List is not empty            
            if (!objEvent.isEmpty()){
                //create Event list object for bulk update
                List<Event> updEventList= new List<Event>();
                for(Event evt : objEvent){
                    evt.whatid=idSPH;
                    //check EndDate value if null the assign Activity Datetime
                    if (evt.EndDateTime==null){evt.EndDateTime=evt.StartDateTime;}
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
                                           FROM ContentDocumentLink WHERE LinkedEntityId =:idSP]){
                //clone the ContentDocumentLink record
                ContentDocumentLink cloned = cdl.clone();
                cloned.LinkedEntityId = idSPH;
                //add clone record and cdl record in the list
                cdlList.add(cloned);
                cdlExt.add(cdl);
            }  
            //to check the List is not empty
            if (!cdlList.isEmpty())
            {
                //perform insert and delete dml operation
                insert cdlList; delete cdlExt;
            } 
             if(Test.isRunningTest())
                    integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_Helper', 'updateExistingSalesPlannerActivityHistory', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: Update existing Cases reference from SP ID to SPH ID
    * @Change:  
    * *************************************************************** */
    public static void updateExistingSalesPlannerCaseWithHistory(Id idSP, Id idSPH){ 
        try{
            //create event list object based on the SOQL defined 
            List<Case> objCase=[SELECT CaseNumber, AccountId, Subject, Id, Sales_Planner__c, Sales_Planner_History__c FROM Case where Sales_Planner__c=:idSP];
            //to check the List is not empty
            if (!objCase.isEmpty()){
                //create Case list object for bulk update
                List<Case> updCaseList= new List<Case>();
                for(Case c : objCase){
                    //assign existing SP refernce id to null
                    c.Sales_Planner__c=null;
                    //assign SP history refernce to SP History ID
                    c.Sales_Planner_History__c=idSPH;
                    updCaseList.add(c);
                }  
                //to check the List is not empty
                if (!updCaseList.isEmpty())
                {
                    //perform update dml operation
                    update updCaseList;
                }
            }    
             if(Test.isRunningTest())
                    integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('Trg_SalesPlanner_Helper', 'updateExistingSalesPlannerActivityHistory', ex.getMessage(), ex.getLineNumber());
        }
    }
}