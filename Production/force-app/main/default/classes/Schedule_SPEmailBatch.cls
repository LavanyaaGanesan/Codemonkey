global class Schedule_SPEmailBatch implements Schedulable {    
    global void execute(SchedulableContext ctx) 
    {
        Database.executeBatch(new SPEmailBatch()); 
    }   
}