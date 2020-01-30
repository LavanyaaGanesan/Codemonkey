/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: This is test class of ApexDebugLogController
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  9-Jan-2020
* *************************************************************** */
@istest
public class ApexDebugLogControllerTest {
    /* ***************************************************************
    * @description: This function used to increase a code coverage of ApexDebugLogController class
    * @Change:  
    * *************************************************************** */
    @istest 
    static void test_insertLog(){
        //start the Test action
        test.startTest();
        //insert a record in 
        for(integer i=0 ;i<5 ;i++){
            ApexDebugLogController.insertLog('ApexDebugLogControllerTest' , 'test_insertLog', 
                                             'errorMessage : ' + string.valueOf(i), i+1);
        }
        //stop the test action
        test.stopTest();
    }
}