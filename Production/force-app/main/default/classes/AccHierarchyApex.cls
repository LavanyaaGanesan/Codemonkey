public class AccHierarchyApex {

    @AuraEnabled
    public static string getAccountId(string spId){
        if(spId != null && !spId.startsWithIgnoreCase('001') && spId.startsWithIgnoreCase('a19')){
          return [select id,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:spId LIMIT 1].Account_ID__c;  
        }
        else
            return spId;
    }
    @AuraEnabled
    public static List<Account> findHierarchyData(string recId){
        if(recId != null && !recId.startsWithIgnoreCase('001') && recId.startsWithIgnoreCase('a19')){
          recId = [select id,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:recId LIMIT 1].Account_ID__c;  
            
        }
        List<Account> accList = new List<Account>();
        string queryString = 'select id,name,Owner.Name,parentId,DDD_Outlet_ID__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account';
        
        //Section to get all child account details from ultimate parent starts-------------------------
        List<String> currentParent  = new List<String>{};
        Integer level               = 0;
        Boolean endOfStructure      = false;
        system.debug('*******RecordId--:'+recId);
        //method to find ultimate parent of account
        string topMostparent = GetUltimateParentId(recId);
        system.debug('*******topMostparent:'+topMostparent);
        currentParent.add(topMostparent);
        system.debug('**********topMostparent:'+ currentParent);
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
            system.debug('********finalQueryString:'+finalQueryString);
            if(finalQueryString != null && finalQueryString !=''){
                try{
                    if(Limits.getLimitQueries()-Limits.getQueries()>0){
                        queryOutput = database.query(finalQueryString);
                        system.debug('***hierarchy level:'+level);
                    }else{
                        system.debug('****endOfStructure is true as SOQL limit reaches:');
                        endOfStructure = true;
                    }
                }catch(exception ex){ 
                    endOfStructure = true;
                }
            }
            system.debug('**123queryOutput size:'+queryOutput);
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
        }
        system.debug('**********accList:'+accList);
        return accList;
    }
      
	// Find the tom most element in Heirarchy  
    // @return objId
    public static String GetUltimateParentId( string recId ){
        Boolean top = false;
        while ( !top ) {
            string queryString = 'select id,name, ParentId from Account where Id =:recId LIMIT 1';
            Account acc = database.query(queryString);
            if ( acc.parentId != null ) {
                recId = acc.parentId;
            }else {
                top = true;
            }
        }
        return recId ;
    }
    
    /*@AuraEnabled
    public static boolean getobj(string recId){
        boolean res= false;
        
       if(recId.startsWithIgnoreCase('001')) 
           return res;
        else {
              res= true;
            return res; 
        }
    
    }*/
    /* public static List<Sales_Planner__c> findHierarchyDatasp(string recId){
        List<Sales_Planner__c> spList = new List<Sales_Planner__c>();
        string queryString = 'select id,name,Account_Owner__c,State_Province2__c,Parent_Account__c from Sales_Planner__c';
         
    //Section to get all child account details from ultimate parent starts-------------------------
        List<String> currentParent  = new List<String>{};
        Integer level               = 0;
        Boolean endOfStructure      = false;
        //method to find ultimate parent of account
        string topMostparent = GetUltimateParentIdsp(recId);
        system.debug('*******topMostparent:'+topMostparent);
        currentParent.add(topMostparent);
        system.debug('**********topMostparent:'+ currentParent);
        //Loop though all children
        string finalQueryString = '';
        List<Sales_Planner__c>  queryOutput = new List<Sales_Planner__c> ();
        while ( !endOfStructure ){  
            if( level == 0 ){
                finalQueryString = queryString + ' where id IN : CurrentParent ORDER BY ParentId  Limit 1';
            } 
            else {
                finalQueryString = queryString + ' where ParentID IN : CurrentParent ORDER BY ParentId Limit 1';
            }
            system.debug('********finalQueryString:'+finalQueryString);
            if(finalQueryString != null && finalQueryString !=''){
                try{
                    if(Limits.getLimitQueries()-Limits.getQueries()>2){
                        queryOutput = database.query(finalQueryString);
                        system.debug('***hierarchy level:'+level);
                    }else{
                        system.debug('****endOfStructure is true as SOQL limit reaches:');
                        endOfStructure = true;
                    }
                }catch(exception ex){ 
                    endOfStructure = true;
                }
            }
            system.debug('**queryOutput size:'+queryOutput);
            if( queryOutput.size() == 0 ){
                endOfStructure = true;
           }
            else{
                currentParent.clear();
                //iterating through query output
                for ( Integer i = 0 ; i < queryOutput.size(); i++ ){
                    currentParent.add(queryOutput[i].Id);
                    spList.add(queryOutput[i]);
                 }
            }
            level++;
        }
        system.debug('**********accList:'+spList);
        return spList;
     }
    public static String GetUltimateParentIdsp( string recId ){
        Boolean top = false;
        while ( !top ) {
            string queryString = 'select id ,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where Account_ID__c =:recId LIMIT 1';
            Account acc = database.query(queryString);
            if ( acc.parentId != null ) {
                recId = acc.parentId;
            }else {
                top = true;
            }
        }
        return recId ;
    }
    @AuraEnabled
    public static id getAccountIds(string recId){
    	system.debug('recId --'+recId);
        system.debug('***'+[select id ,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:recId LIMIT 1].Account_ID__c);
        return  [select id ,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:recId LIMIT 1].Account_ID__c;   
        
    }*/
    
}