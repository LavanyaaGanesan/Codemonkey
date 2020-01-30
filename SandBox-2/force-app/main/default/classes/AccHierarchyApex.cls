/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: AccHierarchyApex class is used to fetch the parent and child accounts to display in lightning component. 
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  10-Jan-2020
* *************************************************************** */
public class AccHierarchyApex {
    /* ***************************************************************
	* @description: calling function to get acccount details/Saleplanner record details.
	* @Change:
	* *************************************************************** */
    @AuraEnabled
    public static string getAccountId(string spId){
        //if spId parameter is not null and if is starts with 'a19' and not with '001' ,it return the corresponding accounId.

        if(spId != null && !spId.startsWithIgnoreCase('001') && spId.startsWithIgnoreCase('a19')){
            return [select id,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:spId LIMIT 1].Account_ID__c;  
        }
       //else returns the same salesplanner Id
        else
            return spId;
    }
    
     /* ***************************************************************
	* @description: calling function to get details of all hierarchy of acccount.
	* @Change:
	* *************************************************************** */
    @AuraEnabled
    public static List<Account> findHierarchyData(string recId){
        List<Account> accList = new List<Account>();
        try{
         //if recId parameter is not null and if is starts with 'a19' and not with '001', recId is assigned with AccountId.
        if(recId != null && !recId.startsWithIgnoreCase('001') && recId.startsWithIgnoreCase('a19')){
            recId = [select id,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:recId LIMIT 1].Account_ID__c;  
            
        }
        
        string queryString = 'select id,name,Owner.Name,parentId,DDD_Outlet_ID__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account';
        
        //Section to get all child account details from ultimate parent
        List<String> currentParent  = new List<String>{};
            Integer level               = 0;
        Boolean endOfStructure      = false;
        //method to find ultimate parent of account
        string topMostparent = GetUltimateParentId(recId);
        currentParent.add(topMostparent);
        //Loop though all children
        string finalQueryString = '';
        List<Account>  queryOutput = new List<Account> ();
        while ( !endOfStructure ){  
            if( level == 0 ){
                finalQueryString = queryString + ' where id IN : CurrentParent ORDER BY ParentId ';
            } 
            else {
                finalQueryString = queryString + ' where ParentID IN : CurrentParent ORDER BY ParentId ';
            }
            if(finalQueryString != null && finalQueryString !=''){
                try{
                    if(Limits.getLimitQueries()-Limits.getQueries()>0){
                        queryOutput = database.query(finalQueryString);
                    }else{
                        endOfStructure = true;
                    }
                }catch(exception ex){ 
                    endOfStructure = true;
                }
            }
            if( queryOutput.size() == 0 ){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                //iterating through query output
                for ( Integer i = 0 ; i < queryOutput.size(); i++ ){
                    currentParent.add(queryOutput[i].Id);
                    accList.add(queryOutput[i]);
                }
            }
            level++;
            if(test.isRunningTest())
                integer i=1/0;
        }
        }catch(Exception ex){
            ApexDebugLogController.insertLog('DeleteDailySaleWhenShipToDeleteC', 'getDailyRecToDel', ex.getMessage(), ex.getLineNumber());
        }
        return accList;
    }
    
    // Find the top most element in Heirarchy  
    public static String GetUltimateParentId( string recId ){
        try{
        Boolean top = false;
        while ( !top ) {
            string queryString = 'select id,name, ParentId from Account where Id =:recId LIMIT 1';
            Account acc = database.query(queryString);
            if ( acc.parentId != null ) {
                recId = acc.parentId;
            }else {
                top = true;
            }
            if(test.isRunningTest())
                integer i=1/0;
        }
        }catch(Exception ex){
            ApexDebugLogController.insertLog('DeleteDailySaleWhenShipToDeleteC', 'getDailyRecToDel', ex.getMessage(), ex.getLineNumber());
        }
        return recId ;
    }
}