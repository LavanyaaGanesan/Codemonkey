trigger salesData_Trigger on Sales_Data__c (after insert) {
	salesData_Helper.afterInsert(Trigger.new);
}