public class salesData_Helper {
    static Custom_Setting__c salesDataHelperSetting = Custom_Setting__c.getInstance('salesData_Helper');
    static Boolean hasAlreadyRun = false;

    static Map<Id,Product2> PRODUCT_MAP = new Map<Id,Product2>([SELECT Id, Name FROM Product2]);
    static List<String> FIELDS = new List<String>{
        'Doses_Month_0__c','Doses_Month_1__c','Doses_Month_2__c','Doses_Month_3__c','Doses_Month_4__c','Doses_Month_5__c'
        ,'Doses_Month_6__c','Doses_Month_7__c','Doses_Month_8__c','Doses_Month_9__c','Doses_Month_10__c'
        ,'Doses_Month_11__c','Doses_Month_12__c','Doses_Month_13__c','Doses_Month_14__c','Doses_Month_15__c'
        ,'Doses_Month_16__c','Doses_Month_17__c','Doses_Month_18__c','Doses_Month_19__c','Doses_Month_20__c'
        ,'Doses_Month_21__c','Doses_Month_22__c','Doses_Month_23__c'
    };

    public static void afterInsert(List<Sales_Data__c> newList){
        Map<String, Sales_Data__c> salesDataUpserts = new Map<String, Sales_Data__c>();
        for ( Integer i=0;i<newList.size();i++ ){
            salesDataUpserts.putAll(updatePriorMonths(newList[i]));
        }
        if ( hasAlreadyRun == FALSE && salesDataHelperSetting != null && salesDataHelperSetting.Boolean__c ){
            hasAlreadyRun = true;
            database.upsert(salesDataUpserts.values(), Sales_Data__c.IDSalesDataExt__c);
        }
    }
   
    public static Map<String,Sales_Data__c> updatePriorMonths(Sales_Data__c thisMonth){
        Map<String, Sales_Data__c> salesDataUpserts = new Map<String, Sales_Data__c>();
        if ( String.isNotBlank(thisMonth.IDSalesDataExt__c) ){
            String externalId = thisMonth.IDSalesDataExt__c.subStringBeforeLast('-');
            Integer year = Integer.valueOf(
                thisMonth.IDSalesDataExt__c.subStringAfterLast('-').left(2)
            );
            Integer month = Integer.valueOf(
                thisMonth.IDSalesDataExt__c.subStringAfterLast('-').right(2)
            );
            Date d = date.newInstance((2000+year),month,Date.daysInMonth((2000+year),month));
            for ( Integer j=1;j<FIELDS.size();j++ ){
                Date oldDate = d.addMonths(-1*j);
                Sales_Data__c priorMonth = new Sales_Data__c(
                    Name = PRODUCT_MAP.get(thisMonth.Product__c).Name,
                    Account__c = thisMonth.Account__c,
                    Product__c = thisMonth.Product__c,
                    Data_Source__c = thisMonth.Data_Source__c,
                    Sales_Category__c = thisMonth.Sales_Category__c,
                    Date__c = oldDate,
                    IDSalesDataExt__c=externalId+'-'+(''+oldDate.year()).right(2)+('0'+oldDate.month()).right(2)
                );
                for ( Integer k=0;k<fields.size();k++ ){
                    if ( (k+j) < fields.size() ){
                        priorMonth.put(fields[k],thisMonth.get(fields[k+j]));
                    }
                }
                salesDataUpserts.put(priorMonth.IDSalesDataExt__c, priorMonth);
            }
        }
        return salesDataUpserts;
    }
    
}