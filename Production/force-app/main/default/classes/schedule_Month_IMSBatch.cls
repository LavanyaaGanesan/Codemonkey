global class schedule_Month_IMSBatch implements Schedulable {
   
    global void execute(SchedulableContext ctx) {
        String year = system.now().format('YYYY');
        String query = 'SELECT Id, Account__c from IMS_Yearly_Stats__c where Year__c =\'' + year + '\'';

        Month_IMSBatch mBatch = new Month_IMSBatch(query);
        Database.executeBatch(mBatch);
    }   
}