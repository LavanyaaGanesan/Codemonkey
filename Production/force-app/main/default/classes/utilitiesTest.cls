@isTest
public class utilitiesTest{
    @isTest static void testMethod1(){
    UserRole uRole = [select id,Name from userRole  LIMIT 1];
        Test.StartTest();
        Set<id> idsSet = utilities.getMyChildRoles(uRole.id);
        Test.StopTest();
    }
}