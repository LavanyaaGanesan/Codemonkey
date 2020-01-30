@isTest
private class QuarterlyChartsDisplay_Test {
    
    private static testMethod void chartsDisplay()
    {
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;
        system.debug('Acc Id = '+acc.Id);
        
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2019';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp; 

        Sales_Data__c saleda = new Sales_Data__c();
        saleda.Name ='VAXCHORA';
        saleda.Account__c=acc.id;
        saleda.Date__c=system.today().addyears(-1);
        insert saleda; 
        QuarterlyChartsDisplay.getVaxQuarterly(sp.id,'VAXCHORA,VIVOTIF BENERA');
    }
}