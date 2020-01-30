({	 
    getObjectValueHelper : function(component, param) {        
        var Ids='';
        var sObject=component.get(param);
        if (sObject!=undefined && sObject!=null){
            if (sObject.length==undefined){
                Ids=sObject.Id;
            }
            else{
                for(let i=0; i<sObject.length; i++){
                    Ids+= sObject[i].Id + (i!=sObject.length-1 ? "; " : "");
                }
            }
        }
        return Ids;
	},    
    addErrorClass: function(fieldClassName, className){
        $("." + fieldClassName + ".errorText").addClass(className);
    },
    removeErrorClass: function(fieldClassName, className){
        $("." + fieldClassName + ".errorText").removeClass(className);
    },    
    convertToISOStringFormat : function (dt){
        if (dt.toString().split(' ').length>4){
            var aDate = dt.toString().split(' '); //Thu Jan 03 2019 13:05:57
            var mon={'Jan':'01','Feb':'02','Mar':'03','Apr':'04',
                     'May':'05','Jun':'06','Jul':'07','Aug':'08',
                     'Sep':'09','Oct':'10','Nov':'11','Dec':'12'}
            
            return 	aDate[3]+'-'+  mon[aDate[1]] +'-'+ aDate[2] +'T'+ aDate[4]+'.000Z';
        }
        else {
            return dt;
        }
    }, 
    convertDateToISO: function(date) {
        var _date = date.toString().replace(",","").replace(":"," ").split(" ");
        var mon={'Jan':1,'Feb':2,'Mar':3,'Apr':4,'May':5,'Jun':6,'Jul':7,'Aug':8,'Sep':9,'Oct':10,'Nov':11,'Dec':12}
		return _date[3] +"-"+ mon[_date[1]]+"-"+ _date[2];
        //return date;
    },
    convertDateToLocal: function(date) {
        var _date = date.toString().split("-");
        var mon={'Jan':1,'Feb':2,'Mar':3,'Apr':4,'May':5,'Jun':6,'Jul':7,'Aug':8,'Sep':9,'Oct':10,'Nov':11,'Dec':12}
		return _date[1] +"/"+ _date[2]+"-"+ _date[0];
        //return date;
    },
    addTimeFromTimeZone : function (dt){
        var myDate = new Date(dt);
		var offset = myDate.getTimezoneOffset()  * 60 * 1000;
		var withOffset = myDate.getTime();
		var withoutOffset = withOffset + 0;        
        return new Date(withoutOffset).toISOString();
    },    
    setTimeFromTimeZone : function (dt){
        var myDate = new Date(dt);
		var offset = myDate.getTimezoneOffset()  * 60 * 1000  * 2;
		var withOffset = myDate.getTime();
		var withoutOffset = withOffset + offset;        
        return this.convertToISOStringFormat(new Date(withoutOffset));
    }, 
    validateTime : function(_t){
        var sHH = _t.getHours();
        var sMM = _t.getMinutes();
        if (sHH<8 || (sHH>18 && sMM>=0) || (sHH==18 && sMM>0))
            return true;
        else
            return false;
    },
    validateHelper : function(component, event) { 
        var returnVal=true;        
        
        var start = component.get("v.TaskForm.ActivityDateTime__c");
        var end = component.get("v.TaskForm.EndDate__c");
        var type = component.get("v.TaskForm.Type");
        if (type!='PTO' && start>end){
            this.addErrorClass("EndDate","_error");
            returnVal=false;
        }else{
            this.removeErrorClass("EndDate","_error");
        }
        
        if (type!='PTO' && this.validateTime(new Date(start))){
            this.addErrorClass("StartDateTimeBetween","_error");
            returnVal=false;
        }
        else
        {
            this.removeErrorClass("StartDateTimeBetween","_error");   
        }
        
        if (type!='PTO' && this.validateTime(new Date(end))){
            this.addErrorClass("EndDateTimeBetween","_error");
            returnVal=false;
        }
        else
        {
            this.removeErrorClass("EndDateTimeBetween","_error");   
        }
        
        var assignedUser=this.getObjectValueHelper(component, "v.selectedCalendarUserRecord");
        if (assignedUser==undefined || assignedUser==''){
           this.addErrorClass("AssignTo","_error");
            returnVal=false;
        }
        else
        {
            this.removeErrorClass("AssignTo","_error");
        }
        
        if (component.get("v.TaskForm.Status")=="Completed"){
            if (component.get("v.TaskForm.Product_Discussed__c")!=undefined && 
                component.get("v.TaskForm.Product_Discussed__c")!="Business Related" ){
                var resourceValues=component.get("v.TaskForm.Resources_Left__c");
                if (type=='In Person' && (resourceValues==undefined || resourceValues=='')){
                    this.addErrorClass("ResourcesLeft","_error");
                    returnVal=false;
                }
                else
                {
                    this.removeErrorClass("ResourcesLeft","_error");
                }
            }           
        }
        if(component.get('v.requiredAccount')){
            var errorCount=2;
            if (component.get("v.TaskForm.Status")!="Completed"){
                errorCount=1;
            }
            var relatedToAccount=this.getObjectValueHelper(component, "v.selectedRelatedToAccountRecord");
            var type= component.get("v.TaskForm.Type")
            if (type!='PTO' && (relatedToAccount==undefined || relatedToAccount=='')){
                this.addErrorClass("RelatedTo","_error");
                returnVal=false;
            }
            else
            {
                this.removeErrorClass("RelatedTo","_error");
            }
        }
        if(component.get('v.requiredContact')){
            var errorCount=3;
            if (component.get("v.TaskForm.Status")!="Completed"){
                errorCount=2;
            }
            var relatedToContact=this.getObjectValueHelper(component, "v.selectedRelatedToContactRecords");
            if (relatedToContact==undefined || relatedToContact==''){
                this.addErrorClass("ContactName","_error");
                returnVal=false;
            }
            else
            {
                this.removeErrorClass("ContactName","_error");
            }
        }
                
        var allValid = component.find('validateTaskField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        
        
        if (component.get("v.TaskForm.IsRecurrence")){
            this.validateRecurrenceHandle(component, event);
        }        
        return returnVal && allValid;
	},
    calRecurrenceDayOfWeekMask : function(pDay){
    	var ODay={'Sun':1,'Mon':2,'Tue':4,'Wed':8,'Thu':16,'Fri':32,'Sat':64,'Day':127}
		return ODay[pDay];
    },
    validateRecurrenceHandle : function(component, event) {        
        var taskRecord = component.get("v.TaskForm");
        var dOptions = component.get("v.dOptions");
        var wOptions = component.get("v.wOptions");
        var mOptions = component.get("v.mOptions");
        if(dOptions == true){
            //console.log("===dOptions===");
            var eWeekDay = component.get("v.eWeekDay");
        	var eNumOfDays = component.get("v.eNumOfDays");
            if(eWeekDay){
                component.set("v.recurType","DW");
                taskRecord.RecurrenceType = "RecursEveryWeekday";
                taskRecord.RecurrenceDayOfWeekMask = 62;
            }
            else if(eNumOfDays){
                component.set("v.recurType","D");
                taskRecord.RecurrenceType = "RecursDaily";
                var dNumberOfDays = component.get("v.dNumberOfDays");
                if(dNumberOfDays!=null){                    
                    taskRecord.RecurrenceInterval = parseInt(dNumberOfDays);
                }
            }
        }else if(wOptions == true){
            //console.log("===wOptions===");
            component.set("v.recurType","W");
            taskRecord.RecurrenceType = "RecursWeekly";
            var reNumberOfDays = component.get("v.reNumberOfDays");
            if(reNumberOfDays!=null){
            	taskRecord.RecurrenceInterval =  reNumberOfDays;   
            }
            
            var totWeekDayCount = 0;
            totWeekDayCount+= component.get("v.wSun") ? this.calRecurrenceDayOfWeekMask('Sun') : 0;
            totWeekDayCount+= component.get("v.wMon") ? this.calRecurrenceDayOfWeekMask('Mon') : 0;
            totWeekDayCount+= component.get("v.wTue") ? this.calRecurrenceDayOfWeekMask('Tue') : 0;
            totWeekDayCount+= component.get("v.wWed") ? this.calRecurrenceDayOfWeekMask('Wed') : 0;
            totWeekDayCount+= component.get("v.wThu") ? this.calRecurrenceDayOfWeekMask('Thu') : 0;
            totWeekDayCount+= component.get("v.wFri") ? this.calRecurrenceDayOfWeekMask('Fri') : 0;
            totWeekDayCount+= component.get("v.wSat") ? this.calRecurrenceDayOfWeekMask('Sat') : 0;
            
            if(totWeekDayCount>0){
                taskRecord.RecurrenceDayOfWeekMask = totWeekDayCount;
            }
        }else if(mOptions == true){            
            //console.log("===mOptions===");
            if(component.get("v.month_onDay")){
                component.set("v.recurType","M");
                taskRecord.RecurrenceType = "RecursMonthly";
                taskRecord.RecurrenceDayOfMonth = component.get("v.month_onDayVal");
                taskRecord.RecurrenceInterval = component.get("v.month_ofEvery");
            }else if(component.get("v.month_onthe")){
                component.set("v.recurType","MN");
                taskRecord.RecurrenceType = "RecursMonthlyNth";
                taskRecord.RecurrenceInterval  = component.get("v.month_ontheEvery"); 
                taskRecord.RecurrenceInstance  = component.get("v.month_ontheDayof");
                taskRecord.RecurrenceDayOfWeekMask = this.calRecurrenceDayOfWeekMask(component.get("v.month_ontheDay"));
            }
        }
        taskRecord.RecurrenceType__c = taskRecord.RecurrenceType;
        component.set("v.TaskForm", taskRecord);
    },
    setSelectedValueUserHelper : function(component, objectName, id){   
        if (component.get("v.selectedCalendarUserParentRecord").length!=undefined &&
           	component.get("v.selectedCalendarUserRecord").Id!=undefined &&
            component.get("v.selectedCalendarUserParentRecord")[0].Id!=component.get("v.selectedCalendarUserRecord").Id)
        {
            return true;
        }
    	var action = component.get("c.selectedLookUpValues");
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            id : id,
            ObjectName : objectName
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                //console.log(response.getReturnValue());
                component.set("v.selectedCalendarUserParentRecord", response.getReturnValue());
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);
	}, 
    setSelectedValueContactsHelper : function(component, objectName, ids, accountId){      
    	var action = component.get("c.fetchLookUpMultiSelectValuesWithIds");
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            Ids : ids,
            ObjectName : objectName,
            AccountId : accountId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                //console.log(response.getReturnValue());
                component.set("v.selectedRelatedToContactRecords", response.getReturnValue());
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);
	},     
    setSelectedValueAccountHelper : function(component, objectName, id){
      
    	var action = component.get("c.selectedLookUpValues");
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            id : id,
            ObjectName : objectName
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                //console.log(response.getReturnValue());
                component.set("v.selectedRelatedToAccountParentRecord", response.getReturnValue());
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);
	},  
    activateOtherFieldOnStatus: function(component, status){
        if (status=="Completed"){
        	component.set("v.activeOthers",true);
            component.set("v.requiredComments",true);
            component.set("v.requiredProductDiscussed",true);
        }
        else
        {
        	component.set("v.activeOthers",false);
            component.set("v.requiredProductDiscussed",false);
            if (component.get("v.TaskForm.Product_Discussed__c")!=undefined && 
                component.get("v.TaskForm.Product_Discussed__c")=="Business Related" ){
                component.set("v.requiredComments",true);
            }else{
                component.set("v.requiredComments",false);
            }            
        }
    },  
    activateCallStage: function(component, productDiscussed){        
        component.set("v.requiredResourcesLeft",true);
        if (productDiscussed!='' && productDiscussed=='Vivotif'){            
            component.set("v.requiredCallStage",true);
           	component.set("v.requiredVaxchoraCallStage",false);
            component.set("v.requiredVaxchoraCallStage",false);
            component.set("v.isVivotif",true);
            component.set("v.isVaxchora",false);
            component.set("v.requiredComments",true);
            
        }
        else if (productDiscussed!='' && productDiscussed=='Vaxchora'){ 
            component.set("v.requiredCallStage",false);
           	component.set("v.requiredVaxchoraCallStage",true);
            component.set("v.isVivotif",false);
            component.set("v.isVaxchora",true);
            component.set("v.requiredComments",true);
        } 
        else if (productDiscussed!='' && productDiscussed=='Vivotif and Vaxchora'){  
            component.set("v.requiredCallStage",true);
           	component.set("v.requiredVaxchoraCallStage",true);
            component.set("v.isVivotif",true);
            component.set("v.isVaxchora",true);
            component.set("v.requiredComments",true);
        }
        else if (productDiscussed!='' && productDiscussed=='Business Related'){  
            component.set("v.requiredCallStage",false);
           	component.set("v.requiredVaxchoraCallStage",false);
            component.set("v.isVivotif",false);
            component.set("v.isVaxchora",false);       
        	component.set("v.requiredResourcesLeft",false);
            component.set("v.requiredComments",true);
        }
        else
        {
            component.set("v.requiredCallStage",false);
           	component.set("v.requiredVaxchoraCallStage",false);            
            component.set("v.isVivotif",false);
            component.set("v.isVaxchora",false);       
        	component.set("v.requiredResourcesLeft",false);
            component.set("v.requiredComments",false);
            //component.set("v.TaskForm.Call_Stage__c",null);
        }
    },
    getTask : function(component){		
        component.set("v.disabledRecurrance",true);
        
        var cData=component.get("v.customDataCreate");        
    	var action = component.get("c.getTask");
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            taskId : cData.taskId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var tsk = response.getReturnValue();
                console.log("get Task : " + tsk);                
                this.activateOtherFieldOnStatus(component, tsk.Status); 
                
                component.set("v.TaskForm", tsk);
                component.set("v.taskType", tsk.Type);
                
                component.set("v.activeDelete",true);
                
                var cData=component.get("v.customDataCreate"); 
                this.setCalendarDate(component, cData);
                
                cData.event = 'eventClickLoaded';
                cData.id = component.get("v.TaskForm.OwnerId");
                cData.accountId = component.get("v.TaskForm.WhatId");
                
                this.setSelectedValueUserHelper(component, component.get("v.objectAssignTo"), cData.id);
                
                if (tsk.WhoCount!=undefined && tsk.WhoCount>0){
                    var con='';
                    for (var i=0;i<tsk.TaskRelations.length;i++){
                        if (!tsk.TaskRelations[i].IsWhat)
                            con += tsk.TaskRelations[i].RelationId +"," ;
                    }                    
                    if (con!='')
                    	this.setSelectedValueContactsHelper(component,component.get("v.objectContact"),con.slice(0, -1), cData.accountId); 
                } 
                
        		component.set("v.showCallStage",false);
       			this.activateCallStage(component, tsk.Product_Discussed__c); 
        		component.set("v.showCallStage",true);
                this.setSelectedValueAccountHelper(component, component.get("v.objectAccount"), cData.accountId); 
                
               	component.set("v.customDataCreate",cData);
                if (tsk.Status=="Completed"){
                    var divResInterval = setInterval(function(){
                        if($('#resourcesSelect').length > 0){
                            clearInterval(divResInterval);
                            if(component.get("v.TaskForm.Resources_Left__c")!=undefined){
                                var res=component.get("v.TaskForm.Resources_Left__c");
                                $('#resourcesSelect').val(res.split(';'));
                            }
                        }
                    },1000);
                } 
                
                this.setTaskTiming(component,tsk.Type, 1);
                
                window.setTimeout(function(){
                        var cActiveOthersChange = component.get('c.activeOthersChange');
                		$A.enqueueAction(cActiveOthersChange);
                },0);
                
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                this.showToast("error", "Error", "Something went wrong, Please check with your admin");
            }
        });
        $A.enqueueAction(action);
	},
    getAccountName : function(component, spID){
        if(component.get("v.gAccountName") && component.get("v.accountName") != undefined && component.get("v.accountName")!='')
        {
            var accName = component.get("v.accountName");
            var sub = component.get("v.TaskForm.Subject");
            if (sub.indexOf(accName)>-1){
                component.set("v.TaskForm.Subject",sub.replace(accName + ' - ',''));
            }
        }
        if (component.get("v.gAccountName") && spID!=undefined){
            var action = component.get("c.getAccountNameBasedOnSPId");
            //Set the Object parameters and Field Set name
            action.setParams({                                                   
                SPId : spID
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var accName = response.getReturnValue();
                    component.set("v.accountName", accName);
                    var sub = component.get("v.TaskForm.Subject");
                    if (sub.indexOf(accName)==-1){
                        component.set("v.TaskForm.Subject",accName + ' - ' + component.get("v.TaskForm.Subject"));
                    }
                }else if (state === 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }else{
                    this.showToast("error", "Error", "Something went wrong, Please check with your admin");
                }
            });
            $A.enqueueAction(action);
        }
    },
    setTypeName : function(component){
       
        if(component.get("v.gAccountName"))
        {
            var type = component.get("v.taskType");
            var sub = component.get("v.TaskForm.Subject");
            console.log("--"+type+'***'+component.get("v.TaskForm.Type"));
            if (component.get("v.taskType") != component.get("v.TaskForm.Type"))
            {
                console.log('--sub--'+sub);
                console.log('--typ--'+type);
                console.log('--condition >-1 --'+sub.indexOf(type));
                if (sub.indexOf(type)>-1){
                    sub = sub.replace(type,'');
                }
                
                type = component.get("v.TaskForm.Type");
                component.set("v.taskType", type);
                console.log('--condition =-1 --'+sub.indexOf(type));
                
                if (sub.indexOf(type)==-1 || type==''){
                    console.log('--check3--');
                    sub = sub + type;
                    component.set("v.TaskForm.Subject",sub);
                }
            }
        }
        if (component.get("v.TaskForm.Type")=='PTO')
        	component.set("v.requiredAccount", false);
        else
            component.set("v.requiredAccount", true);
        
        if (component.get("v.TaskForm.Type")!='In Person')
        	component.set("v.requiredResourcesLeftOnType", false);
        else
            component.set("v.requiredResourcesLeftOnType", true);
    },
    setCalendarDate : function(component, cData){
        var dt = new Date(cData.selectedDate);
        var sDT=dt.toISOString();
        
        var edt = new Date(cData.selectedEndDate);
        var esDT=edt.toISOString();
        
        if (cData.event!="click" && cData.event!="drop" && $A.get("$Browser.isIPhone")){
            component.set("v.TaskForm.ActivityDateTime__c", this.setTimeFromTimeZone(sDT.toString()));
            component.set("v.TaskForm.EndDate__c", this.setTimeFromTimeZone(esDT.toString()));
        }else{
            component.set("v.TaskForm.ActivityDateTime__c",sDT.toString());
            component.set("v.TaskForm.EndDate__c",esDT.toString());
        }
    },
    createTask : function(component, objectTtask){
    	var action = component.get("c.createTask");
        var tskForm= component.get("v.TaskForm");  
              
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            taskForm : tskForm
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){   
				var res = response.getReturnValue();                 
                //console.log('@@@Create Response : ' + response.getReturnValue());
                if (res=='PTOEXIST'){
                    this.showToast("Warning", "Warning!", "User is on PTO, please change the selection date!");                
                }
                else{
                    this.showToast("success", "Success!", "Task saved successfully!"); 
                    this.disabledSaveButton(component, false);
                    var cData=component.get("v.customDataCreate");
                    cData.isOpen=false;
                    cData.event='reload';
                    component.set("v.customDataCreate",cData);
                }
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].pageErrors[0] && errors[0].pageErrors[0].message) {
                        this.showToast("Warning", "Warning!", errors[0].pageErrors[0].message); 
                    	console.log("Error message: " + errors[0].pageErrors[0].message);
                    }
                    else if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                this.showToast("error", "Error", "Something went wrong, Please check with your admin");
            }
        });
        $A.enqueueAction(action);
	},
    deleteTask : function(component, taskId){
        var action = component.get("c.deleteTask"); 
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            taskId : taskId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){                   
                var res = response.getReturnValue();
                //console.log('Task Deleted : ' + res);
                this.disabledDeleteButton(component, false);
                this.showToast("success", "Success!", "Task deleted successfully!");                
                var cData=component.get("v.customDataCreate");
               	cData.isOpen=false;
                cData.event='reload';
               	component.set("v.customDataCreate",cData);
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                this.showToast("error", "Error", "Something went wrong, Please check with your admin");
            }
        });
        $A.enqueueAction(action);
    },
    checkPTOAvailable : function(component){
        var tskForm= component.get("v.TaskForm");  
        var action = component.get("c.checkPTOAvailable"); 
              
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            taskForm : tskForm
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){                   
                var res = response.getReturnValue();
                //console.log('Validated PTO : ' + res); 
                component.set("v.isPTO",res);
                if (res){
                    this.showToast("Warning", "Warning!", "User is on PTO, please change the selction date!");                
                }
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                this.showToast("error", "Error", "Something went wrong, Please check with your admin");
            }
        });
        $A.enqueueAction(action);
    },
    checkNonPTOAvailable : function(component, objectTtask){
    	var action = component.get("c.checkNonPTOAvailable");
        var tskForm= component.get("v.TaskForm");  
              
        //Set the Object parameters and Field Set name
        action.setParams({                                                   
            t : tskForm
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){   
				var res = response.getReturnValue(); 
                if (res=='TASKEXIST'){
                    this.showToast("Warning", "Warning!", "Task already created for selected Date and time!");                
                }
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                this.showToast("error", "Error", "Something went wrong, Please check with your admin");
            }
        });
        $A.enqueueAction(action);
	},
    showToast : function(tType, tTitle, tMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": tTitle,
            "type": tType,
            "message": tMessage
        });
        toastEvent.fire();
    },
    disabledSaveButton : function(component, flag) {
        component.set("v.disabledSaveButton", flag);
    },
    disabledDeleteButton : function(component, flag) {
        component.set("v.disabledDeleteButton", flag);
    },
    setTaskTiming: function(component) {
        if (component.get("v.TaskForm.Type")=='PTO'){
            var offsetTime = new Date().getTimezoneOffset();
            
            var sdt = new Date(component.get("v.TaskForm.ActivityDateTime__c"));
            //sdt.setDate(sdt.getDate() + (new Date().toString().indexOf('GMT-')>=0 ? 1 : 0));
            sdt.setHours(00);
            sdt.setMinutes(00);
            //sdt.setMinutes(new Date().toString().indexOf('GMT-')!=-1 ? offsetTime : -offsetTime);
            
            var edt = new Date(component.get("v.TaskForm.EndDate__c"));
            //edt.setDate(edt.getDate() + (new Date().toString().indexOf('GMT-')>=0 ? 1 : 0));
            edt.setHours(23);
            edt.setMinutes(59);
            
            component.set("v.TaskForm.ActivityDateTime__c",sdt.toISOString());
            component.set("v.TaskForm.EndDate__c",edt.toISOString());
        }
    },
    validateExistingTask : function(component, event) { 
        var sObjectTask =  component.get("v.TaskForm"); 
        
        var oID = this.getObjectValueHelper(component, "v.selectedCalendarUserRecord");
        if (oID==undefined || oID=='')
        	return true;
        
        component.set("v.TaskForm.OwnerId", oID);
        
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
                component.set("v.TaskForm.RecurrenceStartDateOnly", this.convertToISOStringFormat(sDate));
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
                component.set("v.TaskForm.RecurrenceEndDateOnly", this.convertToISOStringFormat(eDate));
            }
            else
            {
                component.set("v.TaskForm.RecurrenceEndDateOnly", component.get("v.TaskForm.RecurrenceEndDateOnly")+"T00:00:00.000Z");
            }
        }        
        
        this.checkNonPTOAvailable(component, event);
    },
})