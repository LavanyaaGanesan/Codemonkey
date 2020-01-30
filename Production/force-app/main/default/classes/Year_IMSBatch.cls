global class Year_IMSBatch implements Database.Batchable<sObject> {
    global final String query;
    global Year_IMSBatch(String q) {
        query = q;
    }

	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {
        IMSHelper.createIMSYear(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
	}

}