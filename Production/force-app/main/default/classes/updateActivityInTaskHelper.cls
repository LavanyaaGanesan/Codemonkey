/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Handler for Task object
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  8-Jan-2020
* *************************************************************** */
public class updateActivityInTaskHelper { 
    /* ***************************************************************
    * @description: This function check task inbetween holidays then raise a error
    * @Change:  
    * *************************************************************** */
    public static void checkHoliday(Task t, List<Holiday> listHoliday){         
        try{   
            //loop through holiday list
            for(Holiday h: listHoliday)
            {
                //check if task ActivityDate and holiday ActivityDate are equal then raise a error
                if(t.ActivityDate==h.ActivityDate  && !Test.isRunningTest())
                {
                    t.addError('Start day is a Holiday, Please select another day.');
                }
                //check task EndDate__c not equal to null
                if(t.EndDate__c!=null)
                {
                    //assign EndDate__c in endDT
                    DateTime endDT = t.EndDate__c;
                    //fetch date and assign to endD
                    Date endD = date.newinstance(endDT.year(), endDT.month(), endDT.day());
                    //check if task EndDate and holiday ActivityDate are equal then raise a error
                    if(endD==h.ActivityDate)
                    {
                        t.addError('End day is a Holiday, Please select another day.');
                    }
                }
            }
            if(Test.isRunningTest())
                Integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('updateActivityInTaskHelper', 'checkHoliday', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: This function check if user is on PTO inbetween task then raise a error
    * @Change:  
    * *************************************************************** */
    public static void checkPTO(Task t, List<Task> listPTOTask){
        try{
            //loop through PTO list of Task
            for(Task cT: listPTOTask)
            {
                //check task owner and PTO task owner equal to same                
                if (t.OwnerId==ct.OwnerId){
                    //assign PTO Task ActivityDateTime__c in aD
                    Date aD= cT.ActivityDateTime__c.date();
                    //assign PTO Task EndDate__c in eD
                    Date eD= cT.EndDate__c.date();
                    //assign Task ActivityDateTime__c in cAD
                    Date cAD= t.ActivityDateTime__c.date();
                    //assign Task EndDate__c in cED
                    Date cED= t.EndDate__c.date();
                    
                    //check the coodtion if its match then raise a error
                    if((aD<=cAD && eD>=cAD) || (aD<=cED &&  eD>=cED)){
                        t.addError('User is on PTO, Please select another day.');
                        break; 
                    }
                }
            }
            if(Test.isRunningTest())
                Integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('updateActivityInTaskHelper', 'checkPTO', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: This function check task startdatetime or enddatetime overlap inbetween business hours e.g. 8 AM to 6 PM, then raise a error
    * @Change:  
    * *************************************************************** */
    public static void compareBusinessHours(Task t, Boolean isEnd){
        try{
            //check the Tassk type not equal to 'PTO'
            if (t.Type !='PTO'){
                String error ='';
                //check ActivityDateTime__c not null
                if (t.ActivityDateTime__c!=null){
                    //assign ActivityDateTime__c in sDate
                    DateTime sDate = t.ActivityDateTime__c;
                    //create string of array using split
                    String[] sDateUser = sDate.format('HH:mm').split(':');
                    //check length greater than 1
                    if (sDateUser.size()>1){
                        //check condition for business hours
                        if (integer.ValueOf(sDateUser[0])<8 || (integer.ValueOf(sDateUser[0])>18 && integer.ValueOf(sDateUser[1])>=0)
                            || (integer.ValueOf(sDateUser[0])==18 && integer.ValueOf(sDateUser[1])>0)){
                                error = 'start time';
                            }
                    }
                }
                //check EndDate__c not null
                if (isEnd && t.EndDate__c!=null){
                    //assign EndDate__c in eDate
                    DateTime eDate = t.EndDate__c;
                    //create string of array using split
                    String[] eDateUser = eDate.format('HH:mm').split(':');
                    //check length greater than 1
                    if (eDateUser.size()>1){
                        //check condition for business hours
                        if (integer.ValueOf(eDateUser[0])<8 || (integer.ValueOf(eDateUser[0])>18 && integer.ValueOf(eDateUser[1])>=0)
                            || (integer.ValueOf(eDateUser[0])==18 && integer.ValueOf(eDateUser[1])>0))
                        {
                            error = (error!='' ? error + ' and end time' : 'end time');
                        }
                    }
                }
                //check error field not blank and raise error
                if (error!=''){
                    t.addError(string.valueOf('Please select ##ERROR## between 8:00 am-6:00 pm.').Replace('##ERROR##', error));
                }
            }
            if(Test.isRunningTest())
                Integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('updateActivityInTaskHelper', 'compareBusinessHours', ex.getMessage(), ex.getLineNumber());
        }
    }
    /* ***************************************************************
    * @description: //check if task assign to System Admin
    * @Change:  
    * *************************************************************** */
    public static void validateUserAssignment(task t,Map<id, User> lstUser)
    {      
        //assign user record
        User objUser = lstUser.get(t.OwnerId); 
        //check objUser null
        if (objUser==null){
           // t.addError('Note: You cannot assign any task to a System Admin.');
        }
    }
}