public class AssignTo {

    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String ObjectName, Boolean getAll) {
        String searchKey = '\'' + searchKeyWord + '%\'';
        String activeKey = 'Yes';
        Boolean isActive = true;               
        
        List <sObject> returnList = new List <sObject>();
        
        String sQuery ='SELECT Id, Name FROM ';
        if (ObjectName.toLowerCase()=='contact'){
            sQuery = sQuery + ObjectName + ' where Name LIKE ' +  searchKey  + ' and AccountId in (Select id from account)'; 
            //sQuery = sQuery + ObjectName + ' where Name LIKE :searchKey and AccountId in (Select id from account where Active__c=:activeKey)'; 
        }
        else if (ObjectName.toLowerCase()=='user'){  
            if (!getAll){
                id loggedInUser=UserInfo.getUserId(); 
                string idString='\'00e61000000cYcvAAE\',\'00e61000000Z6ykAAC\'';
                sQuery = sQuery + ObjectName + ' where UserType=\'Standard\' and (id =\'' + loggedInUser + '\' or ProfileID in ('+ idString +')) and IsActive =' + isActive + 
                    ' and Name LIKE '+ searchKey +' ';
                //System.debug('User sQuery :: ' + sQuery);
                
               
            }
            else
            {
                sQuery = sQuery + ObjectName + ' where UserType=\'Standard\' and IsActive =' + isActive + 
                    ' and Name LIKE '+ searchKey +'';
            }
        }
        else{
            sQuery = sQuery + ObjectName + ' where Name LIKE ' + searchKey +'';
        }  
        System.debug('fetchLookUpValues Query :' + sQuery);
        List <sObject> lstOfRecords = Database.query(sQuery);
        System.debug('fetchLookUpValues lstOfRecords :' + lstOfRecords);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
}