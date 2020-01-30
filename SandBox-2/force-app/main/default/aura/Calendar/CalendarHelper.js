({
    eventToSObject : function (event) {
        var sObject = {};
        sObject.sobjectType = 'Task';
        sObject.Subject = event.title;
        sObject.ActivityDate = event.start;
        sObject.EndDate = event.end;
        sObject.ReminderDateTime = event.reminder;
        sObject.Status = event.status;
        sObject.Type = event.Type; 
        sObject.Id = event.sfid;
        sObject.AccountId = event.accountId;
        //sObject.Account.Name = event.accountName;
        sObject.Resources_Left__c = event.Resources_Left__c;
        sObject.Product_Discussed__c = event.Product_Discussed__c;
        return sObject;
    },
    sObjectToEvent : function (sObject) {       
        var event = {};
        try{

            if (sObject.Subject!=undefined){
                event.ObjectName="T";
                event.title = sObject.Subject;            
                event.reminder = sObject.ReminderDateTime;
                event.status = sObject.Status;
                event.accountId = (sObject.AccountId!=undefined?sObject.AccountId : "");
                event.accountName = (sObject.AccountId!=undefined?sObject.Account.Name : "");
                event.Type = sObject.Type; 
                event.sfid = sObject.Id;            
                event.allDay=false;
                event.Resources_Left__c = sObject.Resources_Left__c;
                event.Product_Discussed__c  = sObject.Product_Discussed__c;
                event.Call_Stage__c =  (sObject.Call_Stage__c!=undefined && sObject.Call_Stage__c.length==3 ?'': sObject.Call_Stage__c); 
                event.Vaxchora_Call_Stage__c = (sObject.Vaxchora_Call_Stage__c!=undefined &&  sObject.Vaxchora_Call_Stage__c.length==3 ?'': sObject.Vaxchora_Call_Stage__c);                
                
                event.Is_MapAnything__c = sObject.Is_MapAnything__c;                
                event.TaskSubType = sObject.TaskSubtype;                
                
                var dt = new Date(sObject.ActivityDateTime__c!=undefined?sObject.ActivityDateTime__c:sObject.ActivityDate);
                var edt = new Date(sObject.EndDate__c!=undefined?sObject.EndDate__c:
                                   (sObject.ActivityDateTime__c!=undefined?sObject.ActivityDateTime__c:sObject.ActivityDate));
                
                if (sObject.ActivityDateTime__c!=undefined){
                    event.start=$A.localizationService.formatDate(dt.toISOString(), "yyyy-MM-ddTHH:mm:00");
                }
                else{
                    event.start=$A.localizationService.formatDate(dt.toISOString(), "yyyy-MM-ddTHH:mm:00");
                }
                //if (sObject.Type!='PTO'){
                if (sObject.EndDate__c!=undefined || sObject.ActivityDateTime__c!=undefined){
                    event.end=$A.localizationService.formatDate(edt.toISOString(), "yyyy-MM-ddTHH:mm:00");
                }
                else{
                    event.end=$A.localizationService.formatDate(edt.toISOString(), "yyyy-MM-ddTHH:mm:00");
                }
                
            }
            else{                
                event.ObjectName="H";
                event.title = sObject.Name;            
                event.allDay=false;
                var dt = new Date(sObject.ActivityDate);
                var edt = new Date(sObject.ActivityDate);                
                event.start=$A.localizationService.formatDate(dt.toISOString(), "yyyy-MM-ddT00:00:00");
                event.end=$A.localizationService.formatDate(edt.toISOString(), "yyyy-MM-ddT23:59:59");
            }
            return event;
        }catch(e){
            event.start=$A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm:ss");
            event.end=$A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm:ss");
            return event;
        }
    },
    convertISODateToLocal: function(dt) {
        var _date = dt.toString().replace('T','-').replace('.000Z','').split("-");//"2019-01-09T14:30:00.000Z"
        var mon={1:'Jan',2:'Feb',3:'Mar',4:'Apr',
                 5:'May',6:'Jun',7:'Jul',8:'Aug',
                 9:'Sep',10:'Oct',11:'Nov',12:'Dec'}
        //dd-MMM-yyyy HH:mm:ss a
        return _date[2] +"-"+ mon[parseInt(_date[1])]+"-"+ _date[0] + ' ' + _date[3];
    },
    convertISODateToLocalDisplay: function(dt) {
        var _date = dt.toString().replace('T','-').replace('.000Z','').split("-");//"2019-01-09T14:30:00.000Z"
        var mon={1:'Jan',2:'Feb',3:'Mar',4:'Apr',
                 5:'May',6:'Jun',7:'Jul',8:'Aug',
                 9:'Sep',10:'Oct',11:'Nov',12:'Dec'}
        //dd-MMM-yyyy HH:mm:ss a
        return _date[2] +"-"+ mon[parseInt(_date[1])]+"-"+ _date[0] + ' ' + this.convertTimeToAMPM(_date[3]);
    },
    convertTimeToAMPM: function(iTi) {
        var sTi = iTi.split(':');
        return (parseInt(sTi[0])>=12 ? (parseInt(sTi[0])-12==0 ? '12' : (parseInt(sTi[0])-12)) : sTi[0]) +':' + sTi[1] +':' + sTi[2] +' ' + (parseInt(sTi[0])>=12 ? 'PM' :  'AM');
    },    
    addTimeFromTimeZone : function (dt){
        var myDate = new Date(dt);
        var offset = myDate.getTimezoneOffset()  * 60 * 1000;
        var withOffset = myDate.getTime();
        var withoutOffset = withOffset - offset;        
        return 	new Date(withoutOffset).toISOString(); 
    },
    getHolidaysHelper: function(component) {
        var action = component.get("c.getHolidays");        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var listHolidays = response.getReturnValue();
                component.set("v.listHolidays",null);
                component.set("v.listHolidays", listHolidays);
            }
        });
        $A.enqueueAction(action);
    },
    getTasks: function(component,recordIds) {
        component.set("v.listViewData",null);
        // https://fullcalendar.io/docs/event_data/Event_Object/
        //console.log('in getTaskList');
        var action = component.get("c.getTaskSObjects");
        if (recordIds) {
            action.setParams({'recordIds' : recordIds});
        }
        var data = component.get("v.customDataCal");        
        action.setParams({'id' : data.id});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var allEvents = response.getReturnValue();
                
                var lHoliday= component.get("v.listHolidays");                
                if(lHoliday!=undefined){
                    for(var i=0;i<lHoliday.length;i++){
                        allEvents.push(lHoliday[i]);
                    }
                }
                
                component.set("v.events",null);
                component.set("v.events", allEvents);
                this.getPTOListview(component);
        		this.setFilterTaskDataInListview(component);
            }
        });
        $A.enqueueAction(action);
    },
    saveTask: function(cmp,taskData) {	 	
        window.setTimeout(
            $A.getCallback(function(){
                var action = cmp.get('c.saveTaskObject');
                action.setParams({"taskForm" : taskData});
                action.setCallback(this,function(response){
                    var state = response.getState();
                    //console.log('Drop Task state ',state);
                    if(cmp.isValid() && state === "SUCCESS") {
                        //this.showToast("success", "Success!", "Task saved successfully!");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type": "success",
                            "message": "Task saved successfully!"
                        });
                        toastEvent.fire();
                        
                        /*var cData=cmp.get("v.customDataCal");
                       cData.isOpen=false;
                       cData.event='reload';
                       cmp.set("v.customDataCal",cData);*/
                       var aLoad = cmp.get('c.jsLoaded');
                       $A.enqueueAction(aLoad);
                   } else if (state === "ERROR") {
                       response.getError().forEach(function(err){
                           //console.log('Error: ' + err.message);
                       });
                   }
               });
               $A.enqueueAction(action);
           }),0);
    },
    setCalendarDate: function(cmp) {
        // http://momentjs.com/docs/#/displaying/format/
        var view = cmp.get('v.view').toLowerCase();
        var moment = $('#calendar').fullCalendar('getDate');
        var headerDate, startof;       
        
        if (view.includes('month')) {
            headerDate = moment.format('MMMM YYYY');
            startof='month';
        } else
            if (view.includes('day')) {
                headerDate = moment.format('MMMM DD, YYYY');
                startof='day';
            } else
                if (view.includes('week')) {
                    startof='week';
                    var mon={1:'Jan',2:'Feb',3:'Mar',4:'Apr',
                             5:'May',6:'Jun',7:'Jul',8:'Aug',
                             9:'Sep',10:'Oct',11:'Nov',12:'Dec'}
                    var startDay = moment.startOf('week').format('DD');
                    var endDay = moment.endOf('week').format('DD');
                    var prevMonth=(startDay<endDay? 
                                   mon[parseInt(moment.format('MM'))]:
                                   (parseInt(moment.format('MM'))-1==0 ? 
                                    mon[12] : mon[parseInt(moment.format('MM'))-1]));
                    headerDate =  prevMonth +' ' + startDay + ' – ' + moment.format('MMM ') 
                    + endDay + moment.format(', YYYY');
                }
        cmp.set('v.headerDate',headerDate);
        cmp.set("v.startDate", moment.startOf(startof).format('YYYY-MM-DD'));
        cmp.set("v.endDate", moment.endOf(startof).format('YYYY-MM-DD'));
        this.setFilterTaskDataInListview(cmp);
        
    },
    setFilterTaskDataInListview: function(cmp) {
        var allEvents = cmp.get("v.events");
        var start = cmp.get("v.startDate");
        var end = cmp.get("v.endDate");
        if (allEvents!=undefined && allEvents.length>0 && 
           start!=undefined && end!=undefined){
            cmp.set("v.listViewData",allEvents.filter(function(a){
                
                aDate = new Date(a.ActivityDate);
                return aDate >= new Date(start) 
                	&& aDate <=  new Date(end) && a.Subject!=undefined;
                allEvents.update();
            }));
            
    	}
    },
    getPTOListview: function(cmp) {
        var allEvents = cmp.get("v.events");
        if (allEvents!=undefined && allEvents.length>0){
            cmp.set("v.listViewPTOData",allEvents.filter(x => x.Type=='PTO'));
    	}
    },
    checkPTORecordAvailable: function(cmp, selectedDate) {
        /*var ptoEvents = cmp.get("v.listViewPTOData");
        if (ptoEvents!=undefined && ptoEvents.length>0){
           var availablePTOEvents = ptoEvents.filter(function(a){
               var offsetTime = new Date().getTimezoneOffset();
               
               var sDT = new Date(a.ActivityDateTime__c);
               sDT.setMinutes(new Date().toString().indexOf('GMT-')!=-1 ? offsetTime : -offsetTime);
               sDate = new Date(sDT.toISOString().indexOf('T00:00:00.000Z')==-1 ? a.ActivityDateTime__c.split('T')[0]+ 'T00:00:00.000Z' : a.ActivityDateTime__c);
                
               var eDT = new Date(a.EndDate__c);
               eDate = new Date(eDT.toString().indexOf('23:59:00')==-1 ? a.EndDate__c.split('T')[0]+ 'T23:59:59.000Z' : a.EndDate__c);
                
               //eDate = new Date(a.EndDate__c.split('T')[0]+'T23:59:59.000Z');
                return sDate <= new Date(selectedDate + 'T00:00:00.000Z') 
                	&& eDate >=  new Date(selectedDate+ 'T23:59:59.000Z');
            });
            if (availablePTOEvents!=undefined && availablePTOEvents.length>0){
                return true;
            }
    	}*/
        return false;
    },
    getHolidayName: function(component, sdate,edate,listOfHolidays) { 
        var holidayName='';
        if (listOfHolidays!=undefined && listOfHolidays.length>0){
           var fltHolidays = listOfHolidays.filter(function(a){
               var offsetTime = new Date().getTimezoneOffset();
               
               var aDate = new Date(a.ActivityDate);
               
               var selSDate = new Date(sdate.toISOString().split('T')[0] + 'T00:00:00.000Z');
               var selEDate = edate!=undefined ? new Date(edate.toISOString().split('T')[0] + 'T00:00:00.000Z') : selSDate;
               
                return (aDate <= new Date(selSDate) 
                	&& aDate >=  new Date(selSDate)) || (aDate <= new Date(selEDate) 
                	&& aDate >=  new Date(selEDate));
            });
            if (fltHolidays!=undefined && fltHolidays.length>0){
                holidayName= fltHolidays[0].Name;
            }
    	}
        return holidayName;
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
})