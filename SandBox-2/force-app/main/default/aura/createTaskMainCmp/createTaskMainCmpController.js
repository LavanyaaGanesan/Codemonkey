({ 
    doInit: function(component, event, helper) {
        //console.log('Create Task init');
        //helper.setSelectedValueHelper(component, component.get("v.objectAssignTo"),  component.get("v.customDataCreate.id"));
    },
    onChangeStatus: function(component, event, helper) {
       //component.set("v.toggleProductDiscussed", false);
       //component.set("v.TaskForm.Product_Discussed__c", '');
       var status =  event.getSource().get("v.value");
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
       var productDiscussed =  event.getSource().get("v.value");
       helper.activateCallStage(component, productDiscussed);
       helper.setTypeName(component);
        component.set("v.showCallStage",true);
    },
    customDataChange: function(component, event, helper) {
        //console.log('Create Main Task: Custom Data Change fire');
        var cData=component.get("v.customDataCreate"); 
        console.log('---'+cData.isOpen);
        if (cData.isOpen==true){ 
            if (cData.event!="eventClick" && cData.event!="eventDrop" && cData.event!="eventClickLoaded"){
                if (component.get("v.TaskForm.Subject")==undefined){
                    component.set("v.TaskForm.Subject","In Person");
                    component.set("v.TaskForm.Type","In Person");
                    component.set("v.TaskForm.Status","Open");
                    component.set("v.TaskForm.Priority","Normal");
                }
            } 
            if (component.get("v.TaskForm.ActivityDateTime__c")==undefined){
                var dt = new Date(cData.selectedDate);
                var sDT=dt.toISOString();
                
                var edt = new Date(cData.selectedEndDate);
                var esDT=edt.toISOString();
                
                if (cData.event!="click" && cData.event!="drop" && $A.get("$Browser.isIPhone")){
                    component.set("v.TaskForm.ActivityDateTime__c", helper.setTimeFromTimeZone(sDT.toString()));
                    component.set("v.TaskForm.EndDate__c", helper.setTimeFromTimeZone(esDT.toString()));
                }else{
                    component.set("v.TaskForm.ActivityDateTime__c",sDT.toString());
                    component.set("v.TaskForm.EndDate__c",esDT.toString());
                }
                
                //component.set("v.TaskForm.ActivityDateTime__c",sDT.toString());
                
                /*if(cData.event=="eventClick"){
                    component.set("v.TaskForm.ActivityDateTime__c",$A.localizationService.formatDate(dt.toLocaleString(), "yyyy-MM-ddTHH:mm:ss"));
                }else{
                    component.set("v.TaskForm.ActivityDateTime__c",$A.localizationService.formatDate(dt.toLocaleString(), "yyyy-MM-ddTHH:mm:ss"));
                }*/                
            }
            console.log('---'+cData.event);
            if (cData.event=="eventClick" || cData.event=="eventDrop"){
				component.set("v.disableRecurrenceOnEdit",true);
                helper.getTask(component);
            }
            else{
                if (cData.event=="click"){ 
                    helper.setSelectedValueUserHelper(component, component.get("v.objectAssignTo"), cData.id);
                	component.set("v.gAccountName", true); 
                }
                else if (cData.event=="drop"){  
                    helper.setSelectedValueUserHelper(component, component.get("v.objectAssignTo"), cData.id);
                    helper.setSelectedValueAccountHelper(component, component.get("v.objectAccount"), cData.accountId);
                	component.set("v.gAccountName", true);
                } 
                    else if (cData.event=="eventClickLoaded"){  
                        component.set("v.gAccountName", true);	
                    }
            }  
        } 
    },
	validateContactMultiSelect : function(component, event, helper) {
        if (component.get("v.selectedRelatedToContactRecords")!=undefined && component.get("v.selectedRelatedToContactRecords")!=null){
			var objContact = component.get("v.selectedRelatedToContactRecords");
            
            if (objContact.length>1){
                component.set("v.disabledRecurrance",true);
                component.set("v.multipleContacts", true);
                if (component.get("v.TaskForm.IsRecurrence")){
                    helper.showToast("warning", "Warning!", "One person per recurring task, please make it one.");
                	component.set("v.TaskForm.IsRecurrence", false);
                }
                else if (component.get("v.TaskForm.isRecurTask__c")){
                    helper.showToast("warning", "Warning!", "One person per recurring task, please make it one.");
                }
            }
            else{
                component.set("v.disabledRecurrance",false);
                component.set("v.multipleContacts", false);
            }
            
            /*for(let i=0; i<objContact.length; i++){
        		console.log("ID :" + objContact[i].Id + " Name:" + objContact[i].Name);
            }*/
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
        helper.disabledSaveButton(component, true);
        
       var objContact = component.get("v.selectedRelatedToContactRecords");
       if(objContact.length>1 && component.get("v.TaskForm.isRecurTask__c")){
           helper.showToast("warning", "Warning!", "One person per recurring task, please make it one.");
           helper.disabledSaveButton(component, false);
           return false;
        }
       
       if(helper.validateHelper(component, event)){
           var sObjectTask =  component.get("v.TaskForm"); 
           
           sObjectTask.OwnerId = helper.getObjectValueHelper(component, "v.selectedCalendarUserRecord");
           sObjectTask.WhoId = helper.getObjectValueHelper(component,  "v.selectedRelatedToContactRecords");                
           sObjectTask.WhatId = helper.getObjectValueHelper(component, "v.selectedRelatedToAccountRecord"); 
           
           if (sObjectTask.ActivityDate!=undefined){
               component.set("v.TaskForm.ActivityDate", null);
           }
           if (sObjectTask.ActivityDateTime__c!=undefined && sObjectTask.ActivityDateTime__c.toString().indexOf('.000Z')==-1){
               component.set("v.TaskForm.ActivityDateTime__c", component.get("v.TaskForm.ActivityDateTime__c")+".000Z");           
           }
           if (sObjectTask.EndDate__c!=undefined && sObjectTask.EndDate__c.toString().indexOf('.000Z')==-1){
               component.set("v.TaskForm.EndDate__c", component.get("v.TaskForm.EndDate__c")+".000Z");           
           }
           
           if (sObjectTask.RecurrenceStartDateOnly!=undefined && sObjectTask.RecurrenceStartDateOnly.toString().indexOf('T00:00:00.000Z')==-1){
               var sDate = new Date(component.get("v.TaskForm.RecurrenceStartDateOnly"));
               if (sDate.toString().indexOf('GMT-')!=-1){  
                   if (component.get("v.recurType")!=undefined && component.get("v.recurType")=="D"){
                       sDate.setDate(sDate.getDate() + 1);
                   }
                   else if (component.get("v.recurType")!=undefined && component.get("v.recurType")=="W"){
                       sDate.setDate(sDate.getDate() + 1);
                   }
                       else
                       {
                           sDate.setDate(sDate.getDate() + 1);
                       }
                   
                   sDate.setHours(0);
                   sDate.setMinutes(0);
                   component.set("v.TaskForm.RecurrenceStartDateOnly", helper.convertToISOStringFormat(sDate));
               }
               else
               {
                   component.set("v.TaskForm.RecurrenceStartDateOnly", component.get("v.TaskForm.RecurrenceStartDateOnly")+"T00:00:00.000Z");
               }               
           }
           if (sObjectTask.RecurrenceEndDateOnly!=undefined && sObjectTask.RecurrenceEndDateOnly.toString().indexOf('T00:00:00.000Z')==-1){
               var eDate = new Date(component.get("v.TaskForm.RecurrenceEndDateOnly"));
               if (eDate.toString().indexOf('GMT-')!=-1){ 
                   if (component.get("v.recurType")!=undefined && component.get("v.recurType")=="D"){
                       eDate.setDate(eDate.getDate() + 1);
                   }
                   else if (component.get("v.recurType")!=undefined && component.get("v.recurType")=="W"){
                       eDate.setDate(eDate.getDate() + 1);
                   }
                       else
                       {
                           eDate.setDate(eDate.getDate() + 1);
                       }                   
                   eDate.setHours(0);
                   eDate.setMinutes(0);
                   component.set("v.TaskForm.RecurrenceEndDateOnly", helper.convertToISOStringFormat(eDate));
               }
               else
               {
                   component.set("v.TaskForm.RecurrenceEndDateOnly", component.get("v.TaskForm.RecurrenceEndDateOnly")+"T00:00:00.000Z");
               }
           }
           
           component.set("v.TaskForm", sObjectTask);
           helper.setTaskTiming(component);
           helper.checkNonPTOAvailable(component, event);
           helper.createTask(component, event);
      }
       else{
           helper.showToast("warning", "Warning!", "Please enter mandatory fields.");
           helper.disabledSaveButton(component, false);
       }
   },
    deleteClick: function(component, event, helper) {        
        helper.disabledDeleteButton(component, true);
        if(component.get("v.TaskForm.Id")!=undefined){
            if (confirm("Are you sure, you want to delete this task?")) {
                helper.deleteTask(component,component.get("v.TaskForm.Id"));
            }
            else     
        		helper.disabledDeleteButton(component, false);                
        }else{
            helper.showToast("warning", "Warning!", "Task not available to delete.");       
        	helper.disabledDeleteButton(component, false);
        }
    },
   closeModel: function(component, event, helper) {
       var cData=component.get("v.customDataCreate");
       cData.isOpen=false;
       cData.event='reload';
       component.set("v.customDataCreate",cData);
   },
    isRecurrence : function(component, event, helper) {        
        if (component.get("v.TaskForm.IsRecurrence")){
            component.set("v.TaskForm.RecurrenceStartDateOnly",$A.localizationService.formatDate(component.get("v.TaskForm.ActivityDateTime__c"), "yyyy-MM-dd"));
            component.set("v.TaskForm.RecurrenceEndDateOnly",$A.localizationService.formatDate(component.get("v.TaskForm.ActivityDateTime__c"), "yyyy-MM-dd"));
        }
    },
    frequencyButtonClick : function(component, event, helper) {
       var buttonLabel= event.getSource().get("v.label"); 
        if (buttonLabel=="Daily"){
            component.set("v.DailyVariant", "brand");
        	component.set("v.WeeklyVariant", "neutral");
        	component.set("v.MonthlyVariant", "neutral");
        }
        else if (buttonLabel=="Weekly"){
            component.set("v.DailyVariant", "neutral");
        	component.set("v.WeeklyVariant", "brand");
        	component.set("v.MonthlyVariant", "neutral");            	
        }
        else if (buttonLabel=="Monthly"){
            component.set("v.DailyVariant", "neutral");
        	component.set("v.WeeklyVariant", "neutral");
        	component.set("v.MonthlyVariant", "brand");  
        }
        
        component.set("v.dOptions", false);
        component.set("v.wOptions", false);
        component.set("v.mOptions", false);
        component.set("v.yOptions", false);
        
        if(buttonLabel == "Daily"){
            component.set("v.dOptions", true);
        }else if(buttonLabel == "Weekly"){
            component.set("v.wOptions", true);
        }else if(buttonLabel == "Monthly"){
            component.set("v.mOptions", true);
        }else if(buttonLabel == "Yearly"){
            component.set("v.yOptions", true);
        }
    },
    handleDailyFrequencyRadioClick : function(component, event, helper) {
		//console.log("handleDailyFrequencyRadioClick()");
        var radioLabel = event.getSource().get("v.label");
        
        var eWeekDay = component.get("v.eWeekDay");
        var eNumOfDays = component.get("v.eNumOfDays");
        
        //console.log("eWeekDay: "+eWeekDay+" eNumOfDays: "+eNumOfDays);
        component.set("v.eWeekDay", false);
        component.set("v.eNumOfDays", false);
        
        //console.log(radioLabel);
        
        if(radioLabel == "Every weekday"){
            component.set("v.eWeekDay", true);
        }else if(radioLabel == "Every"){
            component.set("v.eNumOfDays", true);
        }
	},
    handleMonthChoices : function(component, event, helper) {
		//console.log("handleMonthChoices()");
        var radioLabel = event.getSource().get("v.label");
        var radioName = event.getSource().get("v.name");
        //console.log(radioLabel+"------"+radioName);
        
        component.set("v.month_onDay", false);
        component.set("v.month_onthe", false);
        if(radioName == "monthRadioOptions"){
            if(radioLabel == "On day"){
                component.set("v.month_onDay", true);
            }else if(radioLabel == "On the"){
                component.set("v.month_onthe", true);
            }
        }
    },
    handleYearlyChoices : function(component, event, helper) {
		//console.log("handleYearlyChoices()");
        var radioLabel = event.getSource().get("v.label");
        var radioName = event.getSource().get("v.name");
        //console.log(radioLabel+"------"+radioName);
        
        component.set("v.year_onEvery", false);
        component.set("v.year_onThe", false);
        if(radioName == "yearlyRadioOptions"){
            if(radioLabel == "On every"){
                component.set("v.year_onEvery", true);
            }else if(radioLabel == "On the"){
                component.set("v.year_onThe", true);
            }
        }
    },
    weekDayChange : function(component, event, helper) {
    	if (!component.get("v.wSun") &&
             !component.get("v.wMon") &&
             !component.get("v.wTue") &&
             !component.get("v.wWed") &&
             !component.get("v.wThu") &&
             !component.get("v.wFri") &&
            !component.get("v.wSat")){
            component.set("v.wMon", true)
        }
	},
})