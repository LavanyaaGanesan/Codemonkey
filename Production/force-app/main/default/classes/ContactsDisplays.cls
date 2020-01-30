public class ContactsDisplays {
    
    @AuraEnabled
    public Static List<contact> getContacts(String SalesPlannerID)
    {
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        List<Contact> contacts = [select id, Title,Phone,email,Name,Primary_Contact__c,Status__c,Contact_Relationship__c,Role__c from contact where accountid =: salesPlanner.Account_Sales_Planner__c];
        
        return contacts;
    }

    @AuraEnabled
    public Static Sales_Planner__c getSalesPlanner(String SalesPlannerID)
    {
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        return salesPlanner;
    }
    
     @AuraEnabled
    public static String getIconName(String sObjectName){
        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }

        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sObjectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + sObjectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        return u;
    }
    
    
}