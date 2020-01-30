/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Apex class to capture the exception in Apex Debug Log custom object
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  7-Jan-2020
* *************************************************************** */
public class ApexDebugLogController {
    /* ***************************************************************
    * @description: Method to capture the exception info 
    * @Change:
    * *************************************************************** */
    //@future
    public static void insertLog(string className, string methodName, string errorMessage, Integer lineNo){
        try{
            //create Apex_Debug_Log object
            Apex_Debug_Log__c adl = new Apex_Debug_Log__c();
            //assign class name
            adl.class__c = className;
            //assign method name
            adl.method__c=methodName;
            //assign line no and error message
            adl.message__c= string.valueOf(lineNo) +' :- ' +errorMessage;
			//insert record            
            insert adl;}catch(exception ex){
            system.debug('ApexDebugLogController exception ::' + ex.getLineNumber() + ' :- ' + ex.getMessage());
        }
    }
}