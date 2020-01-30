/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: ValidateCaseFieldTest is used to provide test data for ValidateCaseField for code coverage.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  14-Jan-2020
* *************************************************************** */

@istest
public class ValidateCaseFieldTest {
    @istest
    /* ***************************************************************
* @description: calling function to pass test data to ValidateCaseField class for code coverage
* @Change:
* *************************************************************** */
    public static void testMeth1()
    {
        //test record for custom setting
        Case_Trigger_Setting__c spSetting =  Case_Trigger_Setting__c.getOrgDefaults();
        spSetting.Is_Active__c=true;
        spSetting.Vaxchora_2_8_Reminder__c='200';
        spSetting.Vaxchora_2_8C_FAQ__c='200';
        spSetting.Vaxchora_Reconstitution__c='200';
        spSetting.Vivotif_Pochette_Pouch__c='200';
        spSetting.Vivotif_Pochette_Pouch_with_PIs_c_Error__c='hello';
        spSetting.Vax_Flashcard_Reconstitution_Remind_Erro__c='hi';
        insert spSetting;
        //get user
        User u = [Select id, ProfileId from User where Alias= 'jbjer' LIMIT 1];
        System.runAs ( u ){
            //test data for account record
            Account a = new Account(Name='TestViv123');
            //insert Account
            insert a;
            //test data for salesplanner record related to account inserted above
            Sales_Planner__c s = new Sales_Planner__c(Name='Test123',Sales_Planner_Year__c='2020',
                                                      Account_Sales_Planner__c=a.id,
                                                      Account_Stage__c='Vivotif Supporter');
            //insert salesplanner
            insert s;
            //test data for case record related to salesplanner created above
            case c = new case(Sales_Planner__c=s.id,
                              OwnerId=u.id,Vivotif_Pochette_Pouch_with_PIs__c=20,
                              Reason='Marketing Materials Request',
                              Status='New',
                              Facility_Name__c='test',
                              Shipping_Address__c ='test',
                              City__c='test', State__c='test', Zip_Code__c='iop');
            //insert case
            insert c;
            //provide Vivotif_Pochette_Pouch_with_PIs__c so that it exceeds limit
            c.Vivotif_Pochette_Pouch_with_PIs__c=208;
            //try to update Vivotif_Pochette_Pouch_with_PIs__c field
            try{
                update c;    
            }catch(exception ex){
                ApexDebugLogController.insertLog('ValidateCaseFieldTest', 'testMeth1', ex.getMessage(), ex.getLineNumber());
            }
            //test data for case related to salesplanner inserted above
            case c1 = new case(Sales_Planner__c=s.id,
                               OwnerId=u.id,Vivotif_Pochette_Pouch_with_PIs__c=200,
                               Reason='Marketing Materials Request',
                               Status='New',
                               Facility_Name__c='test1',
                               Shipping_Address__c ='test',
                               City__c='test', State__c='test1', Zip_Code__c='iop');
            //try to insert test case 
            try{
                insert c1;
            }
            catch(exception ex)
            {
                ApexDebugLogController.insertLog('ValidateCaseFieldTest', 'testMeth1', ex.getMessage(), ex.getLineNumber());
            }
            //test data for case related to salesplanner inserted above
            case c2 = new case(Sales_Planner__c=s.id,
                               OwnerId=u.id,Vaxchora_2_8C_FAQ_Flashcard__c=200,
                               Vaxchora_2_8_Reminder_Cling__c=200,
                               Vaxchora_Reconstitution_Cling__c=200,
                               Reason='Marketing Materials Request',
                               Status='New',
                               Facility_Name__c='test1',
                               Shipping_Address__c ='test',
                               City__c='test', State__c='test1', Zip_Code__c='iop');
            //try to insert case c2
            try{
                insert c2;
            }
            catch(exception ex)
            {
                ApexDebugLogController.insertLog('ValidateCaseFieldTest', 'testMeth1', ex.getMessage(), ex.getLineNumber());
            }
            //assign values so that it exceeds the limit
            c2.Vaxchora_2_8C_FAQ_Flashcard__c=201;
            c2.Vaxchora_2_8_Reminder_Cling__c=201;
            c2.Vaxchora_Reconstitution_Cling__c=201;
            //try updating c2.
            try{
                update c2;
            }
            catch(exception ex)
            {
                ApexDebugLogController.insertLog('ValidateCaseFieldTest', 'testMeth1', ex.getMessage(), ex.getLineNumber());
            }
            //test data for case record
            case c3 = new case(Sales_Planner__c=s.id,
                               OwnerId=u.id,Vaxchora_2_8C_FAQ_Flashcard__c=201,
                               Vaxchora_2_8_Reminder_Cling__c=201,
                               Vaxchora_Reconstitution_Cling__c=201,
                               Reason='Marketing Materials Request',
                               Status='New',
                               Facility_Name__c='test1',
                               Shipping_Address__c ='test',
                               City__c='test', State__c='test1', Zip_Code__c='iop');
            //try to insert c3
            try{
                insert c3;
            }
            catch(exception ex)
            {
                ApexDebugLogController.insertLog('ValidateCaseFieldTest', 'testMeth1', ex.getMessage(), ex.getLineNumber());
            }
        }
    }
}