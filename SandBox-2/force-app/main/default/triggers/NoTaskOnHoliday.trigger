trigger NoTaskOnHoliday on Task (before insert, before Update) 
{
    for(Task t:Trigger.new)
    {
        system.debug('task'+ t.ActivityDate);
        for(Holiday h: NoTaskHoildayClass.getHolidays())
        {
            system.debug('after first for'+h.ActivityDate+'----'+t.ActivityDate);
            if(t.ActivityDate==h.ActivityDate)
                {
                    t.addError('Start day is a Holiday, Please select another day.');
                    system.debug(t.ActivityDate + '************'+h.ActivityDate );
                }
            else if(t.EndDate__c!=null)
            {
                DateTime dT = t.EndDate__c;
                Date endDt = date.newinstance(dT.year(), dT.month(), dT.day());
                if(endDt==h.ActivityDate)
                {
                    t.addError('End day is a Holiday,Please select another day.');
                }
            }
        }
    }
}
// system.debug(t.ActivityDate + '************'+h.ActivityDate );
// DateTime dT = t.ActivityDate;
//date.newinstance(dT.year(), dT.month(), dT.day())
//  Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());