public class HorizontalMonthlychartsDisplay {
  @AuraEnabled    
    public Static Map<string,List<AggregateResult>> getMonthlyData(String SalesPlannerID,String productName)
    { 
        system.debug('::::SalesPlannerID'+SalesPlannerID);
        system.debug('::::productName' +productName); 
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        List<AggregateResult> saldata;
        List<AggregateResult> saldata2; 
        List<String> prdList = productName.split(',');
        system.debug(':::salesPlanner.Account_Sales_Planner__c'+salesPlanner.Account_Sales_Planner__c);
        Map<string,List<AggregateResult>> prodQuarResult = new Map<string,List<AggregateResult>>();
        saldata = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =last_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c)];
        prodQuarResult.put('Lastyear', saldata);
        saldata2 = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =this_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c)];    
        //List<Sales_Data__c> saledata = [SELECT id FROM Sales_Data__c where Account__c =: salesPlanner.Account_Sales_Planner__c and Date__c = LAST_YEAR];
        System.debug('saledata ::: '+saldata);
        prodQuarResult.put('Thisyear', saldata2);
        //saldata.addAll(saldata2);
        system.debug('prodQuarResult final result'+prodQuarResult);
        return prodQuarResult;
     

        //CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c)
    }
    @AuraEnabled    
    public Static Map<string,List<AggregateResult>> getMonthlyDataReverse(String SalesPlannerID,String productName)
    { 
        system.debug('::::SalesPlannerID'+SalesPlannerID);
        system.debug('::::productName' +productName); 
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        List<AggregateResult> saldata;
        List<AggregateResult> saldata2; 
        List<String> prdList = productName.split(',');
        system.debug(':::salesPlanner.Account_Sales_Planner__c'+salesPlanner.Account_Sales_Planner__c);
        Map<string,List<AggregateResult>> prodQuarResult = new Map<string,List<AggregateResult>>();
        saldata = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =last_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c) desc];
        prodQuarResult.put('Lastyear', saldata);
        saldata2 = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =this_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c) desc];    
        //List<Sales_Data__c> saledata = [SELECT id FROM Sales_Data__c where Account__c =: salesPlanner.Account_Sales_Planner__c and Date__c = LAST_YEAR];
        System.debug('saledata ::: '+saldata);
        prodQuarResult.put('Thisyear', saldata2);
        //saldata.addAll(saldata2);
        system.debug('prodQuarResult final result'+prodQuarResult);
        return prodQuarResult;
     

        //CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c)
    }
}