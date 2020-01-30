/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: It used to test HorizontalMonthlyChartsDisplay class 
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  10-Jan-2020
* *************************************************************** */
@isTest
public class HorizontalMonthlyChartsDisplayTest {
    /* ***************************************************************
    * @description: This function used for code coverage 
    * @Change:  
    * *************************************************************** */
    @isTest
    public static void testHorizontal()
    {
        //create a Account object with dummy data
        Account a = new Account(Name='TestViv123');
        //insert account record
        insert a;
        //create SP object with dummy data
        Sales_Planner__c s = new Sales_Planner__c(Name='Test123',Sales_Planner_Year__c='2020',
                                                  Account_Sales_Planner__c=a.id,
                                                  Account_Stage__c='Vivotif Supporter');
        //insert SP record
        insert s;
        //create Sales Data object with dummy data
        Sales_Data__c sd = new Sales_Data__c();
        sd.Name='testsd';
        sd.Account__c=a.id;
        //insert Sales Data
        insert sd;
        //check the assertion
        system.assertEquals(sd.Name, 'testsd');
        //start the code coverage execution
        test.startTest();
        //execute below methods with dummy data
        HorizontalMonthlychartsDisplay.getMonthlyData(s.id,'Vivotif');
        HorizontalMonthlychartsDisplay.getMonthlyDataReverse(s.id,'Vivotif');
        //stop the code coverage execution
        test.stopTest(); 
    }        
}