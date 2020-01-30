@isTest
private class salesData_Tests {

    static testMethod void salesData_Helper_UnitTest(){
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Product2 testProduct = new Product2();
        testProduct.Name = 'Test Product';
        insert testProduct;

        Custom_Setting__c testSetting = Custom_Setting__c.getInstance('salesData_Helper');
        if ( testSetting == null || testSetting.Id == null ){
            testSetting = new Custom_Setting__c(Name='salesData_Helper');
        }
        testSetting.boolean__c = true;
        upsert testSetting;

        test.startTest();
            Sales_Data__c testSalesData = new Sales_Data__c();
            testSalesData.Account__c = testAccount.Id;
            testSalesData.Product__c = testProduct.Id;
            testSalesData.Date__c = Date.newInstance(2017,5,1);
            testSalesData.Sales_Category__c = '2';
            testSalesData.Data_Source__c = 'DDD';
            testSalesData.IDSalesDataExt__c = 'TESTTEST-1705';
            insert testSalesData;
        test.stopTest();
    }
}