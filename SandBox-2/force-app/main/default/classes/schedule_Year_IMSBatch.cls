global class schedule_Year_IMSBatch implements Schedulable {
   
    global void execute(SchedulableContext ctx) {
        String query = 'SELECT Id from Account';

        Year_IMSBatch yBatch = new Year_IMSBatch(query);
        Database.executeBatch(yBatch);
    }   
}