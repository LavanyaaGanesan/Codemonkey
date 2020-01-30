global class Month_IMSBatch implements Database.Batchable<sObject> {
    global final String query;
    global Month_IMSBatch(String q) {
        query = q;
    }

	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<IMS_Yearly_Stats__c> scope) {
        IMSHelper.createPreviousIMSMonth(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
	}

}