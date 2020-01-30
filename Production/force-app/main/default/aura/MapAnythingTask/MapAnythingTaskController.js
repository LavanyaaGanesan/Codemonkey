({ 
    doInit: function(component, event, helper) {
        var aS = component.get('c.openSpinner');
        $A.enqueueAction(aS);
        
        var data = component.get("v.customDataCreate")==undefined 
            ? {type:'init', id: $A.get("$SObjectType.CurrentUser.Id"), 
               accountId: '',selectedDate: '',selectedEndDate: '', objectName:''} 
            : component.get("v.customDataCreate");
        
        data.type=component.get("v.recordType"); //'LogACall' or 'NewTask'
        data.accountId = component.get("v.recordId");
        var todatDate = new Date();
        if (todatDate.toString().indexOf('GMT-')>0){
            todatDate.setDate(todatDate.getDate());                            
        }                        
        todatDate.setHours(9);
        todatDate.setMinutes(0);
        todatDate.setSeconds(0);
        data.selectedDate=todatDate.toISOString();
        if (data.type=='NewTask'){
            todatDate.setHours(10);
            todatDate.setMinutes(0);
        	todatDate.setSeconds(0); 
        }else
        {
            component.set("v.hideEndDate", true);
        }
        data.selectedEndDate=todatDate.toISOString();        
        component.set("v.customDataCreate", data);
        component.set("v.TaskForm.Is_MapAnything__c ",true);
        component.set("v.TaskForm.IsRecurrence",false);
        
    },
    customDataChange: function(component, event, helper) {
        //console.log('Create Main Task: Custom Data Change fire');
        var cData=component.get("v.customDataCreate");
        
        if (cData.type=='LogACall'){ 
            if (component.get("v.TaskForm.Subject")==undefined){
                component.set("v.taskType","Phone Call");
                component.set("v.TaskForm.Subject","Phone Call");
                component.set("v.TaskForm.Type","Phone Call");
                component.set("v.TaskForm.Status","Completed");
                component.set("v.TaskForm.Priority","Normal");                
                component.set("v.TaskForm.TaskSubtype","Call");                 
                
                var status =  component.get("v.TaskForm.Status");
                helper.activateOtherFieldOnStatus(component, status);
                
                component.set("v.showCallStage",false);
                component.set("v.TaskForm.Call_Stage__c",'');
                component.set("v.TaskForm.Vaxchora_Call_Stage__c",'');
                component.set("v.TaskForm.Resources_Left__c",'');
                var productDiscussed =  component.get("v.TaskForm.Product_Discussed__c");
                helper.activateCallStage(component, productDiscussed);                
                component.set("v.showCallStage",true);
                
            }
        }else if (cData.type=='NewTask'){ 
            if (component.get("v.TaskForm.Subject")==undefined){
                 component.set("v.TaskForm.Subject","In Person");
                    component.set("v.TaskForm.Type","In Person");
                    component.set("v.TaskForm.Status","Open");
                    component.set("v.TaskForm.Priority","Normal");
            }
        }
        if (component.get("v.TaskForm.ActivityDateTime__c")==undefined){
            var dt = new Date(cData.selectedDate);
            var sDT=dt.toISOString().split('.')[0]+'.000Z';
            
            var edt = new Date(cData.selectedEndDate);
            var esDT=edt.toISOString().split('.')[0]+'.000Z';
            
            if ($A.get("$Browser.isIPhone")){
                component.set("v.TaskForm.ActivityDateTime__c", helper.setTimeFromTimeZone(sDT.toString()));
                component.set("v.TaskForm.EndDate__c", helper.setTimeFromTimeZone(esDT.toString()));
            }else{
                component.set("v.TaskForm.ActivityDateTime__c",sDT.toString());
                component.set("v.TaskForm.EndDate__c",esDT.toString());
            }
        }
        component.set("v.disableRecurrenceOnEdit",true);
        helper.setSelectedValueUserHelper(component, component.get("v.objectAssignTo"), cData.id);
        helper.setSelectedValueAccountHelper(component, component.get("v.objectAccount"), cData.accountId);
        component.set("v.gAccountName", true);
        
        
        var aS = component.get('c.closeSpinner');
        $A.enqueueAction(aS);
        
    },
    onChangeStatus: function(component, event, helper) {
       var status =  component.get("v.TaskForm.Status");
       helper.activateOtherFieldOnStatus(component, status);
    },
    onChangeValidateExistingTask: function(component, event, helper) {
        helper.validateExistingTask(component, event);
    },
    onChangeType: function(component, event, helper) {
       helper.setTypeName(component);
    },
    activeOthersChange: function(component, event, helper) {
        if($('.productDiscussed select').length > 0){
            if(component.get("v.TaskForm.Product_Discussed__c")!=undefined){
                var res=component.get("v.TaskForm.Product_Discussed__c");
                $('.productDiscussed select').val(component.get("v.TaskForm.Product_Discussed__c"));
            }
        }
    },
    onChangeResources: function(component, event, helper) {
        var resourcesValue =$("#resourcesSelect").val();
        var resValue=''; 
        if (resourcesValue!=undefined){
            for(var i=0;i<resourcesValue.length;i++)
            {
                resValue +=resourcesValue[i] + (i!=resourcesValue.length-1?";":"");
            }
        }
        component.set("v.TaskForm.Resources_Left__c", resValue);
    },
    onChangeProductDiscussed : function(component, event, helper) {        
        component.set("v.showCallStage",false);
        component.set("v.TaskForm.Call_Stage__c",'');
        component.set("v.TaskForm.Vaxchora_Call_Stage__c",'');
        component.set("v.TaskForm.Resources_Left__c",'');
       var productDiscussed =  component.get("v.TaskForm.Product_Discussed__c");
       helper.activateCallStage(component, productDiscussed); 
       helper.setTypeName(component);               
        component.set("v.showCallStage",true);
    },
	validateContactMultiSelect : function(component, event, helper) {
        if (component.get("v.selectedRelatedToContactRecords")!=undefined && component.get("v.selectedRelatedToContactRecords")!=null){
			var objContact = component.get("v.selectedRelatedToContactRecords");
            
            if (objContact.length>1){
                component.set("v.disabledRecurrance",true);
                component.set("v.multipleContacts", true);
                if (component.get("v.TaskForm.IsRecurrence")){
                    helper.showToast(component,"warning", "Warning!", "One person per recurring task, please make it one.");
                	component.set("v.TaskForm.IsRecurrence", false);
                }
                else if (component.get("v.TaskForm.isRecurTask__c")){
                    helper.showToast(component,"warning", "Warning!", "One person per recurring task, please make it one.");
                }
            }
            else{
                component.set("v.disabledRecurrance",false);
                component.set("v.multipleContacts", false);
            }
        }
	},
	selectedRelatedToAccountRecordChange : function(component, event, helper) {
        if (component.get("v.selectedRelatedToAccountRecord")!=undefined && component.get("v.selectedRelatedToAccountRecord")!=null){
			component.set("v.customDataCreate.accountId", component.get("v.selectedRelatedToAccountRecord").Id);            
            component.set("v.customDataCreate.Subject", component.get("v.selectedRelatedToAccountRecord").Name);
			helper.getAccountName(component, component.get("v.selectedRelatedToAccountRecord").Id);            
        }
	},
    saveClick: function(component, event, helper) { 
        var aS = component.get('c.openSpinner');
        $A.enqueueAction(aS);
        
        helper.disabledSaveButton(component, true);
        
       var objContact = component.get("v.selectedRelatedToContactRecords");
       if(objContact.length>1 && component.get("v.TaskForm.isRecurTask__c")){
           helper.showToast(component,"warning", "Warning!", "One person per recurring task, please make it one.");
           helper.disabledSaveButton(component, false);
           return false;
        }
       
       if(helper.validateHelper(component, event)){
           var sObjectTask =  component.get("v.TaskForm"); 
           
           /*sObjectTask.OwnerId = helper.getObjectValueHelper(component, "v.selectedCalendarUserRecord");
           sObjectTask.WhoId = helper.getObjectValueHelper(component,  "v.selectedRelatedToContactRecords");                
           sObjectTask.WhatId = helper.getObjectValueHelper(component, "v.selectedRelatedToAccountRecord"); */
           
           component.set("v.TaskForm.OwnerId", helper.getObjectValueHelper(component, "v.selectedCalendarUserRecord"));
           component.set("v.TaskForm.WhoId", helper.getObjectValueHelper(component,  "v.selectedRelatedToContactRecords"));
           component.set("v.TaskForm.WhatId", helper.getObjectValueHelper(component, "v.selectedRelatedToAccountRecord"));
           
           
           if (sObjectTask.ActivityDate!=undefined){
               component.set("v.TaskForm.ActivityDate", null);
           }
           if (sObjectTask.ActivityDateTime__c!=undefined && sObjectTask.ActivityDateTime__c.toString().indexOf('Z')==-1){
               component.set("v.TaskForm.ActivityDateTime__c", component.get("v.TaskForm.ActivityDateTime__c")+".000Z");
           }
           if (sObjectTask.EndDate__c!=undefined && sObjectTask.EndDate__c.toString().indexOf('Z')==-1){
               component.set("v.TaskForm.EndDate__c", component.get("v.TaskForm.EndDate__c")+".000Z");          
           }
           if (component.get("v.recordType")!=undefined && component.get("v.recordType")=="LogACall"){
               component.set("v.TaskForm.EndDate__c", component.get("v.TaskForm.ActivityDateTime__c"));          
           }
           
           helper.setTaskTiming(component);
           helper.checkNonPTOAvailable(component, event);
           helper.createTask(component, event);
      }
       else{
           helper.showToast(component,"warning", "Warning!", "Please enter mandatory fields.");
           helper.disabledSaveButton(component, false);
       }        
        
        var aS = component.get('c.closeSpinner');
        $A.enqueueAction(aS);
   },
   closeModel: function(component, event, helper) {
       if (component.get("v.taskId")!=''){
          //  if ($A.get("$Browser.isPhone" || "$Browser.isIPad")){
            if ($A.get("$Browser.formFactor")!='DESKTOP'){ 
           try{
                    component.set("v.sucessForMobile", true);
           			component.set("v.isOpen", false);
                }catch(e){                    
                }                
            }
           else
           {
               window.location.href='/' + component.get("v.taskId");
           }  
       }else{
           component.set("v.isOpen", false); 
       }
   },
    
     closeModelCancel: function(component, event, helper) {
       if (component.get("v.taskId")!=''){
           // if ($A.get("$Browser.isPhone" || "$Browser.isIPad")){
           if ($A.get("$Browser.formFactor")!='DESKTOP'){
           try{
                    component.set("v.sucessForMobile", true);
           			component.set("v.isOpen", false);
                }catch(e){                    
                }                
            }
           else
           {
               window.location.href='/' + component.get("v.taskId");
           }  
       }else{
          // if ($A.get("$Browser.isPhone" || "$Browser.isIPad")){
            if ($A.get("$Browser.formFactor")!='DESKTOP'){
                try{
                    component.set("v.sucessForMobile", true);
                     component.set("v.isOpen", false);
                    component.set("v.Cancel",true);
                }catch(e){                    
                }                
            }
           else{ 
          // window.location.href='https://emergentpaxvax--test02.lightning.force.com/lightning/n/sma__MapAnything';
           window.location.href= $A.get("$Label.c.MapAnythingLink")
           }}
   },
    
    openSpinner : function(component){        
        component.set("v.loaded", false);
    },    
    closeSpinner : function(component){
        component.set("v.loaded", true);
    } 
})