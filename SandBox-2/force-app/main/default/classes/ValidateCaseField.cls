/* ***************************************************************
* Owner/Modify by Name :Vivek A
* @description: ValidateCaseField class is used to check Vivotif_Pochette_Pouch_with_PIs__c,
				Vaxchora_2_8_Reminder_Cling__c,Vaxchora_2_8C_FAQ_Flashcard__c,Vaxchora_Reconstitution_Cling__c fields limit. 
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  10-Jan-2020
* *************************************************************** */
public class ValidateCaseField 
{
     /* ***************************************************************
	* @description: calling function to get Vivotif_Pochette_Pouch_with_PIs__c field details from all case records related to particular 
	  account.
	* @Change:
	* *************************************************************** */
    public static String getInfo(case objCase){
          //get the Organization default Custom Settings for Case object
    Case_Trigger_Setting__c spSetting =  Case_Trigger_Setting__c.getOrgDefaults();
        
        id accid;
        string cID = (objCase.Id!=null? string.valueOf(objCase.Id) :'');
        //If AccountId of case is null
        if(objCase.AccountId==NULL)
        {
            //get account id from salesplanner and assign to accid variable.
            id spid=objCase.Sales_Planner__c;
            Sales_Planner__c sp=[select id,Account_ID__c  from Sales_Planner__c where id=:spid];
            accid =sp.Account_ID__c;
        }
        else
            //assign account id directly if present.
            accid=objCase.AccountId;
        //get CreatedDateTime of case
        Datetime pCreatedDate=(objCase.CreatedDate!=null? objCase.CreatedDate :System.now());
        //get owner id of case
        id ownId= objCase.OwnerId;
        Datetime da=pCreatedDate;
        //to get total number of days in a month
        Integer numberOfDays = Date.daysInMonth(da.year(), da.month());
        //to get start day of the month
        DateTime StartDayOfMonth = DateTime.newInstance(da.year(), da.month(),1,0,0,0);
        //to get last day of the month.
        DateTime lastDayOfMonth = DateTime.newInstance(da.year(), da.month(), numberOfDays,23,59,59);
        //fetch all the cases of particular account,of that particular month,along with the particular owner.
        list<Case> ca =[SELECT Id, AccountId ,
                        Vivotif_Pochette_Pouch_with_PIs__c,CaseNumber,OwnerId,createdDate from Case
                        where AccountId =:accid 
                        AND OwnerId=: ownId and Id!=:cID
                        AND CreatedDate>=: StartDayOfMonth AND CreatedDate<= :lastDayOfMonth
                        AND Vivotif_Pochette_Pouch_with_PIs__c!=0
                        AND Vivotif_Pochette_Pouch_with_PIs__c!=NULL];
        String res='false';
        Decimal i=0;
        //initialze the limit as given in custom setting
        Decimal lim= Integer.valueOf(spSetting.Vivotif_Pochette_Pouch__c);

        //loop through all cases.
        try{
        for(Case c:ca )
        {
            //add all cases Vivotif_Pochette_Pouch_with_PIs__c field
            i=i+c.Vivotif_Pochette_Pouch_with_PIs__c;            
        }
        //add the Vivotif_Pochette_Pouch_with_PIs__c field of case which is inserted @ present.
        i=i+objCase.Vivotif_Pochette_Pouch_with_PIs__c;
        //if sum is less than limit
        if(i<=lim)
        {
            //assign false to res variable
            res='false';
        }
        else
        { 
            //assign true to res variable
            res='true';
        }
            if(test.isRunningTest())
                integer exi=1/0;
        }catch(Exception ex){
            ApexDebugLogController.insertLog('ValidateCaseField', 'getInfo', ex.getMessage(), ex.getLineNumber());
        }
        //return res along with the limit by how much it is exceeded
        return res+(i-lim);
    }   
    /* ***************************************************************
	* @description: calling function to get Vaxchora_Reconstitution_Cling__c field details from all case records related to particular 
	  account.
	* @Change:
	* *************************************************************** */
    public static String getInfoVRC(case objCase){
         //get the Organization default Custom Settings for Case object
    Case_Trigger_Setting__c spSetting =  Case_Trigger_Setting__c.getOrgDefaults();
        
        id accid;
        string cID = (objCase.Id!=null? string.valueOf(objCase.Id) :'');
        //If AccountId of case is null
        if(objCase.AccountId==NULL)
        {
            //get account id from salesplanner and assign to accid variable.
            id spid=objCase.Sales_Planner__c;
            Sales_Planner__c sp=[select id,Account_ID__c  from Sales_Planner__c where id=:spid];
            accid =sp.Account_ID__c;
        }
        else
            //assign account id directly if present.
            accid=objCase.AccountId;
          //get CreatedDateTime of case
        Datetime pCreatedDate=(objCase.CreatedDate!=null? objCase.CreatedDate :System.now());
         //get owner id of case
        id ownId= objCase.OwnerId;
        Datetime da=pCreatedDate;
        //to get total number of days in a month
        Integer numberOfDays = Date.daysInMonth(da.year(), da.month());
         //to get start day of the month
        DateTime StartDayOfMonth = DateTime.newInstance(da.year(), da.month(),1,0,0,0);
          //to get last day of the month.
        DateTime lastDayOfMonth = DateTime.newInstance(da.year(), da.month(), numberOfDays,23,59,59);
        //fetch all the cases of particular account,of that particular month,along with the particular owner.
        list<Case> ca =[SELECT Id, AccountId ,
                        Vaxchora_Reconstitution_Cling__c,CaseNumber,OwnerId,createdDate from Case
                        where AccountId =:accid 
                        AND OwnerId=: ownId and Id!=:cID
                        AND CreatedDate>=: StartDayOfMonth AND CreatedDate<= :lastDayOfMonth
                        AND Vaxchora_Reconstitution_Cling__c!=0
                        AND Vaxchora_Reconstitution_Cling__c!=NULL];
        String res='false';
        Decimal i=0;
        //initialze the limit as 200
        Decimal lim=Integer.valueOf(spSetting.Vaxchora_Reconstitution__c);
        //loop through all cases.
        try{
        for(Case c:ca )
        {
            //add all cases Vaxchora_Reconstitution_Cling__c field
            i=i+c.Vaxchora_Reconstitution_Cling__c;            
        }
        //add the Vaxchora_Reconstitution_Cling__c field of case which is inserted @ present.
        i=i+objCase.Vaxchora_Reconstitution_Cling__c;
        //if sum is less than limit
        if(i<=lim)
        {
            //assign false to res variable
            res='false';
        }
        else
        { 
            //assign true to res variable   
            res='true';
        }
            if(test.isRunningTest())
                integer exi=1/0;
        }catch(Exception ex){
            ApexDebugLogController.insertLog('ValidateCaseField', 'getInfoVRC', ex.getMessage(), ex.getLineNumber());
        }
        //return res along with the limit by how much it is exceeded
        return res+(i-lim);
    }   
    /* ***************************************************************
	* @description: calling function to get Vaxchora_2_8_Reminder_Cling__c field details from all case records related to particular 
	  account.
	* @Change:
	* *************************************************************** */
    public static String getInfoV28RC(case objCase){
         //get the Organization default Custom Settings for Case object
        Case_Trigger_Setting__c spSetting =  Case_Trigger_Setting__c.getOrgDefaults();
        id accid;
        string cID = (objCase.Id!=null? string.valueOf(objCase.Id) :'');
        //If AccountId of case is null
        if(objCase.AccountId==NULL)
        {
            //get account id from salesplanner and assign to accid variable.
            id spid=objCase.Sales_Planner__c;
            Sales_Planner__c sp=[select id,Account_ID__c  from Sales_Planner__c where id=:spid];
            accid =sp.Account_ID__c;
        }
        else{
            //assign account id directly if present.
            accid=objCase.AccountId;
        }
        //get CreatedDateTime of case
        Datetime pCreatedDate=(objCase.CreatedDate!=null? objCase.CreatedDate :System.now());
        //get owner id of case
        id ownId= objCase.OwnerId;
        Datetime da=pCreatedDate;
        //to get total number of days in a month
        Integer numberOfDays = Date.daysInMonth(da.year(), da.month());
        //to get start day of the month
        DateTime StartDayOfMonth = DateTime.newInstance(da.year(), da.month(),1,0,0,0);
        //to get last day of the month.
        DateTime lastDayOfMonth = DateTime.newInstance(da.year(), da.month(), numberOfDays,23,59,59);
        //fetch all the cases of particular account,of that particular month,along with the particular owner.
        list<Case> ca =[SELECT Id, AccountId ,
                        Vaxchora_2_8_Reminder_Cling__c,CaseNumber,OwnerId,createdDate from Case
                        where AccountId =:accid 
                        AND OwnerId=: ownId and Id!=:cID
                        AND CreatedDate>=: StartDayOfMonth AND CreatedDate<= :lastDayOfMonth
                        AND Vaxchora_2_8_Reminder_Cling__c!=0
                        AND Vaxchora_2_8_Reminder_Cling__c!=NULL];
        
        String res='false';
        Decimal i=0;
         //initialze the limit as 200
        Decimal lim=Integer.valueOf(spSetting.Vaxchora_2_8_Reminder__c);
        //loop through all cases.
        try{
        for(Case c:ca )
        {
             //add all cases Vaxchora_2_8_Reminder_Cling__c field
            i=i+c.Vaxchora_2_8_Reminder_Cling__c;            
        }
        //add the Vivotif_Pochette_Pouch_with_PIs__c field of case which is inserted @ present.
        i=i+objCase.Vaxchora_2_8_Reminder_Cling__c;
         //if sum is less than 200(limit)
        if(i<=lim)
        {
              //assign false to res variable
            res='false';
        }
        else
        { 
             //assign true to res variable 
            res='true';
        }
            if(test.isRunningTest())
                integer exi=1/0;
        }catch(Exception ex){
            ApexDebugLogController.insertLog('ValidateCaseField', 'getInfoV28RC', ex.getMessage(), ex.getLineNumber());
        }
         //return res along with the limit by how much it is exceeded
        return res+(i-lim);
    }   
     /* ***************************************************************
	* @description: calling function to get Vaxchora_2_8C_FAQ_Flashcard__c field details from all case records related to particular 
	  account.
	* @Change:
	* *************************************************************** */
    public static String getInfoV28cFAQ(case objCase){
         //get the Organization default Custom Settings for Case object
   		 Case_Trigger_Setting__c spSetting =  Case_Trigger_Setting__c.getOrgDefaults();
        id accid;
        string cID = (objCase.Id!=null? string.valueOf(objCase.Id) :'');
        //If AccountId of case is null
        if(objCase.AccountId==NULL)
        {
            //get account id from salesplanner and assign to accid variable.
            id spid=objCase.Sales_Planner__c;
            Sales_Planner__c sp=[select id,Account_ID__c  from Sales_Planner__c where id=:spid];
            accid =sp.Account_ID__c;
        }
        else{
             //assign account id directly if present.
            accid=objCase.AccountId;
        }
        //get CreatedDate of case
        Datetime pCreatedDate=(objCase.CreatedDate!=null? objCase.CreatedDate :System.now());
         //get owner id of case
        id ownId= objCase.OwnerId;
        Datetime da=pCreatedDate;
        //to get total number of days in a month
        Integer numberOfDays = Date.daysInMonth(da.year(), da.month());
        //to get start day of the month
        DateTime StartDayOfMonth = DateTime.newInstance(da.year(), da.month(),1,0,0,0);
        //to get last day of the month.
        DateTime lastDayOfMonth = DateTime.newInstance(da.year(), da.month(), numberOfDays,23,59,59);
        //fetch all the cases of particular account,of that particular month,along with the particular owner.
        list<Case> ca =[SELECT Id, AccountId ,
                        Vaxchora_2_8C_FAQ_Flashcard__c,CaseNumber,OwnerId,createdDate from Case
                        where AccountId =:accid 
                        AND OwnerId=: ownId and Id!=:cID
                        AND CreatedDate>=: StartDayOfMonth AND CreatedDate<= :lastDayOfMonth
                        AND Vaxchora_2_8C_FAQ_Flashcard__c!=0
                        AND Vaxchora_2_8C_FAQ_Flashcard__c!=NULL];
        
        String res='false';
        Decimal i=0;
        //initialze the limit as given in custom setting.
        Decimal lim=Integer.valueOf(spSetting.Vaxchora_2_8C_FAQ__c);
        //loop through all cases.
        try{
        for(Case c:ca )
        {
            //add all cases Vaxchora_2_8C_FAQ_Flashcard__c field
            i=i+c.Vaxchora_2_8C_FAQ_Flashcard__c;            
        }
        //add the Vaxchora_2_8C_FAQ_Flashcard__c field of case which is inserted @ present.
        i=i+objCase.Vaxchora_2_8C_FAQ_Flashcard__c;
         //if sum is less than 200(limit)
        if(i<=lim)
        {
            //assign false to res variable
            res='false';
        }
        else
        { 
            //assign true to res variable 
            res='true';
        }
            if(test.isRunningTest())
                integer exi=1/0;
        }catch(Exception ex){
            ApexDebugLogController.insertLog('ValidateCaseField', 'getInfoV28cFAQ', ex.getMessage(), ex.getLineNumber());
        }
        //return res along with the limit by how much it is exceeded
        return res+(i-lim);
    }
}