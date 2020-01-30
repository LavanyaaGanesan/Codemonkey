({
	 doInit: function(component) {
		 var createRecordEvent = $A.get('e.force:createRecord');
        if ( createRecordEvent ) {
            
            createRecordEvent.setParams({
                'entityApiName':'NewTask',
                /*'defaultFieldValues': {
                    'Salesplanner_Name__c' : component.get("v.recordId"),
                    'AccountId' : component.get("v.AccountId"),
                }*/
              
            });
            createRecordEvent.fire();
             } else {
            /* Create Record Event is not supported 
            alert("Contact creation not supported");*/
        }
	}
})