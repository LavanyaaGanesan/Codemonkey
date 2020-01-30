public class NoTaskHoildayClass {
    public static List<Holiday> getHolidays()
    {
        list<Holiday> holi= [SELECT Id,Name,ActivityDate FROM Holiday];
        return holi;
    }
}