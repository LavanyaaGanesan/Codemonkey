@isTest
public class HorizontalMonthlyChartsDisplayTest {
    @isTest
    public static void testHorizontal()
    {
        Account a = new Account(Name='TestViv123');
        insert a;
         
        Sales_Planner__c s = new Sales_Planner__c(Name='Test123',Sales_Planner_Year__c='2019',
                                                  Account_Sales_Planner__c=a.id,
                                                  Account_Stage__c='Vivotif Supporter');
        insert s;
        
        Sales_Data__c sd = new Sales_Data__c();
        sd.Name='testsd';
        sd.Account__c=a.id;
        
        insert sd;
           
        system.assertEquals(sd.Name, 'testsd');
        test.startTest();
        HorizontalMonthlychartsDisplay.getMonthlyData(s.id,'Vivotif');
         HorizontalMonthlychartsDisplay.getMonthlyDataReverse(s.id,'Vivotif');
 		test.stopTest();   
       
    }        
}