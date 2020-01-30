@RestResource(urlMapping='/SalesPlanner/*')
global with sharing class SalesPlannerREST {
 
    @HttpGet
    global static List<Sales_Planner__c> doGet() {
        List<Sales_Planner__c> spList = [Select ID, Name from Sales_Planner__c limit 10];
        return spList;
    }    
}