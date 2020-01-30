({
    doInit : function(cmp,evt,hlp) {
        hlp.getHolidaysHelper(cmp);
            var divCalendar = setInterval(function(){
                try{        
                    if($('#calendar').html()!=undefined){
                        clearInterval(divCalendar);
                        cmp.find("buttonLabel").set("v.label", 'Week');         
                        var dView = cmp.get('c.basicWeek');
                        $A.enqueueAction(dView);
                        
                        var cH = cmp.get('c.changeHeight');
                        $A.enqueueAction(cH); 
                    }
                }catch(e){            
                }
            },3000);
        
    },
    prev : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('prev');
        hlp.setCalendarDate(cmp);
    },
    next : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('next');
        hlp.setCalendarDate(cmp);
    },
    handleSelect : function(cmp, evt, hlp) {
        var dt = {
            today:'Today',
            month:'Month',
            basicWeek:'Week',
            listWeek:'List Week',
            basicDay:'Day',
            listDay:'List Day'            
        }
        
        var selectedMenuItemValue = evt.getParam("value");
        if (selectedMenuItemValue=='today'){
            var atoday = cmp.get('c.basicDay');
            $A.enqueueAction(atoday);        
        }
        cmp.find("buttonLabel").set("v.label", dt[selectedMenuItemValue]);         
        var a = cmp.get('c.'+ selectedMenuItemValue);
        $A.enqueueAction(a);

		var cH = cmp.get('c.changeHeight');
        $A.enqueueAction(cH);        
    },
    changeHeight: function(cmp, evt, hlp)
    {
        try{
            if($('.infinite-loading > div > div > a').length > 0)
            {
                $('.uiScroller').css({'height':($('#calendar').height()-$('.slds-page-header--object-home').height()-65)+'px', 'overflow':'auto'});
            }
        }catch(e){}
    },
    today : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('today');
        hlp.setCalendarDate(cmp);
    },
    month : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('changeView','month');
        cmp.set('v.view','month');
        hlp.setCalendarDate(cmp);
    },
    basicWeek : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('changeView','agendaWeek');
        cmp.set('v.view','basicWeek');
        hlp.setCalendarDate(cmp);
    },
    listWeek : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('changeView','listWeek');
        cmp.set('v.view','listWeek');
        hlp.setCalendarDate(cmp);
    },
    basicDay : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('changeView','agendaDay');
        cmp.set('v.view','basicDay');
        hlp.setCalendarDate(cmp);
    },
    listDay : function(cmp, evt, hlp) {
        $('#calendar').fullCalendar('changeView','listDay');
        cmp.set('v.view','listDay');
        hlp.setCalendarDate(cmp);
    },
    loadEvents : function(cmp,evt,hlp) {        
        var events = cmp.get('v.events');   
        $("#calendar").fullCalendar('removeEvents',null);
        $('#calendar').fullCalendar('addEventSource',events);
    },
    loadMore : function(cmp, evt, hlp) {
        var trCount = 0, NoOfHits = 0;
        if($('.external-tasks table.forceRecordLayout tbody tr')){
            trCount = $('.external-tasks table.forceRecordLayout tbody tr').length;
        }
        var interval = setInterval(function(){
            var isListExist = false;
            NoOfHits = NoOfHits+1;
            if(NoOfHits==10){
                clearInterval(interval);
            }             
            $('.external-tasks table.forceRecordLayout tbody tr').each(function() {
                var AccName = null;    
                if($(this).find('.outputLookupLink')){
                    AccName = $(this).find('.outputLookupLink').text();
                }
                $(this).data('event', {
                    accId: $(this).find('.outputLookupLink').attr("data-recordid"),
                    title: AccName, // use the element's text as the event title
                    stick: true // maintain when user navigates (see docs on the renderEvent method)
                });
                $(this).css({"cursor":"move", "position":"relative", "z-index":"auto"});
                // make the event draggable using jQuery UI
                $(this).draggable({
                    helper: function(event) {   
                        var name=$(event.currentTarget).find('.outputLookupLink').text(),
                            Id = $(event.currentTarget).find('.outputLookupLink').attr('data-recordid');
                        if(name)
                            return $("<div style='font-weight:bold;'>"+name+"</div>");
                        else
                            return null;
                    },
                    cursorAt: { left: 35, top: 25 },
                    appendTo: "body",
                    zIndex: 999,
                    revert: true,      // will cause the event to go back to its
                    revertDuration: 0  //  original position after the drag
                });
            });
        },1000);
    },
    jsLoaded : function(cmp, evt, hlp) {
        try{
            //console.log("JS Loaded :" + cmp.get("v.customDataCal"));
            
            
            if (cmp.get("v.customDataCal.event")!='load')
                return;
            
            var listOfHolidays = cmp.get("v.listHolidays");
            
            //console.log('jsLoaded running');
            // Fetch events and load in calendar	        
            $(document).ready(function(){
                if ($A.get("$Browser.formFactor")!='DESKTOP')
                {
                    $("#calendar").css("display","none");
                }
                
                $(".slds-dropdown_left").addClass("slds-dropdown_right");
                $(".slds-dropdown_right").removeClass("slds-dropdown_left");
                //setTimeout(function(){ 
                var divInterval = setInterval(function(){
                    if($('.infinite-loading > div > div > a').length > 0){
                        LoadMoreEvent();
                        clearInterval(divInterval);
                        $('.uiScroller').css({'height':($('#calendar').height()-$('.slds-page-header--object-home').height()-65)+'px', 'overflow':'auto'});
                    }
                },1000);
                function LoadMoreEvent(){
                    $('.infinite-loading > div > div > a').on('click', 
                                                              $A.getCallback(function(){
                                                                  var a = cmp.get('c.loadMore');
                                                                  $A.enqueueAction(a);
                                                                  //console.log("=======-->");
                                                                  /*setTimeout(function(){
                                                                  LoadMoreEvent();
                                                              },3000);*/
                                                                  var divIntervalEvent = setInterval(function(){
                                                                      if($('.infinite-loading > div > div > a').length > 0){
                                                                          LoadMoreEvent();
                                                                          clearInterval(divIntervalEvent);
                                                                          //$('.uiScroller').css({'height':($('#calendar').height()-$('.slds-page-header--object-home').height()-65)+'px', 'overflow':'hidden', 'overflow-y':'auto'});
                                                                      }
                                                                  },1000);
                                                              })
                                                             );
                }
                
                var divSearchInput = setInterval(function(){
                    if($("input[type='search']").length > 0){
                        LoadSearchEvent();
                        clearInterval(divSearchInput);
                        $('.uiScroller').css({'height':($('#calendar').height()-$('.slds-page-header--object-home').height()-65)+'px', 'overflow':'auto'});
                    }
                },1000);
                function LoadSearchEvent(){
                    $("input[type='search']").on('mouseout', $A.getCallback(function(e){
                        if(e.which!=13){
                            var aSearchOut = cmp.get('c.loadMore');
                            $A.enqueueAction(aSearchOut);
                            var divIntervalSearchEvent = setInterval(function(){
                                if($('.infinite-loading > div > div > a').length > 0){
                                    LoadMoreEvent();
                                    clearInterval(divIntervalSearchEvent);
                                    //$('.uiScroller').css({'height':($('#calendar').height()-$('.slds-page-header--object-home').height()-65)+'px', 'overflow':'hidden', 'overflow-y':'auto'});
                                }
                            },1000);
                        }
                    }));
                }
                
                //setTimeout(function(){
                LoadMoreEvent();
                
                var dragDrop = false;
                
                var a = cmp.get('c.loadMore');
                $A.enqueueAction(a);
                
               var calendar = $('#calendar').fullCalendar({
                    //defaultView: 'Week',
                    header: false,
                    navLinks: true, // can click day/week names to navigate views
                    editable: true,
                    droppable: true, // allows things to be dropped onto the calendar
                    selectable: true,
                    selectHelper: true,
                    minTime:'08:00:00',
                    maxTime:'18:30:00',
                    nextDayThreshold:'00:00:00',
                    defaultTimedEventDuration: '01:00',
                    eventLimit: true, // allow "more" link when too many events
                    slotDuration: "00:15:00",
                    slotLabelFormat:"hh:mm a",
                    views: {
                        timeGrid: {
                            eventLimit: 2 
                        },
                        month: {
                            eventLimit: 2
                        },
                        week: {
                            eventLimit: 2
                        },
                        weekGrid: {
                            eventLimit: 2
                        },
                        day: {
                            eventLimit: 2
                        }
                    },
                   /*businessHours: {
                       
                       daysOfWeek: [1, 2, 3, 4, 5],
                       start: '08:00',
                       end: '18:00',
                       
                   },*/
                    events: [],
                    dayRender: function( date, cell ) {
                        var holidayName = hlp.getHolidayName(cmp,date,date, listOfHolidays);
                        if (holidayName!=''){
                            cell.html(($('#calendar').fullCalendar('getView').name=='month' ? "<br/>" :'') + "<span style='font-size:95%'>" +  holidayName + "</span>");
                            cell.css("background", "rgba(252, 244, 3, 0.2)");
                            cell.css("color", "blue");
                        }
                    },
                    // Callbacks
                    select: function(start, end) {                        
                        var endDate = end;
                        if ($('#calendar').fullCalendar('getView').name=='month'){
                            endDate = new Date(endDate);
                            endDate.setDate(endDate.getDate()-1);
                        }
                        
                        var holidayName = hlp.getHolidayName(cmp,start,endDate, listOfHolidays);
                        
                        if (holidayName!=''){                            
                            hlp.showToast("warning", "Warning", cmp.get("v.HolidayMessage"));                            
                            return false;
                        }
                        if (!hlp.checkPTORecordAvailable(cmp, start.format('YYYY-MM-DD'))){
                            if (cmp.find("buttonLabel").get("v.label")!='Month'){                            
                                var data = cmp.get("v.customDataCal");
                                data.event="click";
                                data.isOpen= true;
                                data.accountId ="";
                                
                                data.selectedDate=start.format();
                                data.selectedEndDate=end.format();
                                cmp.set("v.customDataCal",data);     
                            }                        
                        }else{
                            cmp.set("v.isOpenModal", true); 
                        }                        
                        $('#calendar').fullCalendar('unselect');
                    },
                    dayClick: function(date,jsEvent,ui,resourceObj) {
                        var holidayName = hlp.getHolidayName(cmp,date,date,listOfHolidays);
                        if (holidayName!=''){                            
                            hlp.showToast("warning", "Warning", cmp.get("v.HolidayMessage"));                            
                            return false;
                        }                        
                        if (!hlp.checkPTORecordAvailable(cmp, date.format('YYYY-MM-DD'))){
                            //console.log('a day has been clicked!');
                            var data = cmp.get("v.customDataCal");
                            data.event="click";
                            data.isOpen= true;
                            data.accountId ="";
                            
                            if (cmp.find("buttonLabel").get("v.label")=='Month'){
                                var todatDate = new Date();
                                if (todatDate.toString().indexOf('GMT-')>0){
                                    date._d.setDate(date._d.getDate() + 1);                            
                                }                        
                                date._d.setHours(9);
                                date._d.setMinutes(0);  
                                data.selectedDate=date._d.toISOString();
                                date._d.setHours(10);
                                date._d.setMinutes(0); 
                                data.selectedEndDate=date._d.toISOString();
                            }
                            else{
                                data.selectedDate=date.format();
                                date._d.setHours(date._d.getHours() + 1);
                                data.selectedEndDate=date.format();
                            }
                            cmp.set("v.customDataCal",data);
                        }else{
                            cmp.set("v.isOpenModal", true); 
                        } 
                    },
                    drop: function(date,jsEvent,ui,resourceId) {
                        var holidayName = hlp.getHolidayName(cmp,date,date, listOfHolidays);
                        if (holidayName!=''){                            
                            hlp.showToast("warning", "Warning", cmp.get("v.HolidayMessage"));                            
                            return false;
                        }
                        if (!hlp.checkPTORecordAvailable(cmp, date.format('YYYY-MM-DD'))){                    
                            var data = cmp.get("v.customDataCal");
                            data.event="drop";
                            data.isOpen= true;
                            data.accountId = $(this).data('event').accId;
                            //data.selectedDate= date._d.toISOString();
                            if (cmp.find("buttonLabel").get("v.label")=='Month'){
                                var todatDate = new Date();
                                if (todatDate.toString().indexOf('GMT-')>0){
                                    date._d.setDate(date._d.getDate() + 1);                            
                                }                        
                                date._d.setHours(9);
                                date._d.setMinutes(0);                        
                                data.selectedDate=date._d.toISOString();
                                date._d.setHours(10);
                                date._d.setMinutes(0); 
                                data.selectedEndDate=date._d.toISOString();
                            }
                            else{
                                data.selectedDate=date.format();
                                date._d.setHours(date._d.getHours() + 1);
                                data.selectedEndDate=date.format();
                            }
                            cmp.set("v.customDataCal",data);
                        }else{
                            cmp.set("v.isOpenModal", true); 
                        } 
                    },
                    eventClick: function(calEvent, jsEvent, view) {
                        var data = cmp.get("v.customDataCal");
                        data.event="eventClick";
                        data.isOpen= true;
                        data.taskId = calEvent.sfid;
                        if (calEvent.Type=='PTO'){
                            data.selectedDate= calEvent.start.toISOString(); 
                            data.selectedEndDate= calEvent.end !=undefined ? calEvent.end.toISOString():calEvent.start.toISOString();
                        }else{
                            data.selectedDate= calEvent.start.toISOString(); 
                            data.selectedEndDate= calEvent.end !=undefined ? calEvent.end.toISOString():calEvent.start.toISOString();
                        }
                        cmp.set("v.customDataCal",data); 
                    },
                    eventMouseover: function(calEvent, jsEvent, view) {
                        //console.log('---->');
                        $(this).attr('title', '');
                        $('.popover').css({'zIndex':'999', 'border':'1px solid #ccc', 'border-radius':'3px'});
                        
                    },
                    eventMouseout: function(calEvent, jsEvent, view) {
                        $('.popover').hide();
                    },
                   

                    eventDataTransform: function(event) {
                        // https://fullcalendar.io/docs/event_data/Event_Object/
                        var evt;
                        // Salesforce Event
                        if (event.Id) {
                            evt = hlp.sObjectToEvent(event);
                        }
                        // Regular Event 
                        else {
                            evt = event;
                        }
                        //console.log('eventDataTransform:output',evt);
                        return evt;
                    },
                    eventDrop: function(event, delta, revertFunc) {
                        var holidayName = hlp.getHolidayName(cmp,event.start,event.end, listOfHolidays);
                        if (holidayName!=''){                            
                            hlp.showToast("warning", "Warning", cmp.get("v.HolidayMessage"));                            
                            return false;
                        }
                        //if (!hlp.checkPTORecordAvailable(cmp, start.format('YYYY-MM-DD'))){
                            var data = cmp.get("v.customDataCal");
                            data.event="eventDrop"; 
                            data.isOpen= true;
                            data.taskId = event.sfid;
                            data.selectedDate= event.start.toISOString(); 
                            data.selectedEndDate= event.end !=undefined ? event.end.toISOString():event.start.toISOString(); 
                            cmp.set("v.customDataCal",data); 
                        /*}else{
                            alert(cmp.set("v.alertPTOMessage"));
                        } */
                    },
                    eventResize: function(event, delta, revertFunc) {
                        var holidayName = hlp.getHolidayName(cmp,event.start,event.end, listOfHolidays);
                        if (holidayName!=''){                            
                            hlp.showToast("warning", "Warning", cmp.get("v.HolidayMessage"));                            
                            return false;
                        }
                        var data = cmp.get("v.customDataCal");
                        data.event="eventClick";
                        data.isOpen= true;
                        data.taskId = event.sfid;
                        if (event.Type=='PTO'){
                            data.selectedDate= event.start.toISOString(); 
                            data.selectedEndDate= event.end !=undefined ? event.end.toISOString():event.start.toISOString();
                        }else{
                            data.selectedDate= event.start.toISOString(); 
                            data.selectedEndDate= event.end !=undefined ? event.end.toISOString():event.start.toISOString();
                        }
                        cmp.set("v.customDataCal",data); 
                        /*if (!confirm("is this okay?")) {
                            revertFunc();
                        } else {
                            var sObject = hlp.eventToSObject(event);
                        }*/
                    },
                    eventDragStart : function(event) {
                        dragDrop =true;                
                    },
                    eventDragStop : function(event) {
                        dragDrop =false;                
                    },
                    eventReceive: function(event) {
                        var sObject = hlp.eventToSObject(event);
                        sObject.WhatId = sObject.Id;
                        sObject.Id = null;
                    },
                    eventRender: function(eventObj, $el) {
                        setTimeout(function(){
                            $('.fc-content').css({'padding':'4px 3px'});
                            $('.fc-day-grid-event').css({'border-radius':'15px'});
                        },0); 
                        if (eventObj.title==undefined || dragDrop)
                            return true;
                        
                        try{
                            $el.popover({
                                html : true,
                                animation:false, 
                                placement: (cmp.get('v.view')=='basicWeek' || cmp.get('v.view')=='basicDay') ? 'left': 'left',
                                constraints: [{ to: 'scrollParent', pin: true }],
                                title: function(){
                                    return "<div style='background:#ccc;padding:7px;font-weight:bold;' data-recordid="+eventObj.sfid+">"+
                                        "<p>"+(eventObj.Is_MapAnything__c?'MapAnything - ':'')+eventObj.title+"</p>"+
                                        "</div>";
                                },
                                content: function(){
                                    var statusCom= eventObj.status=='Completed' 
                                    ?   (eventObj.Resources_Left__c!=undefined ? "<tr><td>Resources Left</td><td>: "+eventObj.Resources_Left__c+"</td></tr>" : "")+
                                        (eventObj.Call_Stage__c!=undefined ? "<tr><td>Vivotif Call Stage</td><td>: "+eventObj.Call_Stage__c+"</td></tr>" : "") + 
                                        (eventObj.Vaxchora_Call_Stage__c!=undefined ? "<tr><td>Vaxchora Call Stage</td><td>: "+eventObj.Vaxchora_Call_Stage__c+"</td></tr>" : "")
                                    :"";
                                    
                                    var outPut= "<div style='background:white;padding:7px;'>"+ 
                                        "<table style='width:400px;'>"+
                                        "<tr><td style='width:130px;'>Subject</td><td>: "+eventObj.title+"</td></tr>"+
                                        (eventObj.accountName!=undefined && eventObj.accountName!='' ?"<tr><td>Account Name</td><td>: "+eventObj.accountName+"</td></tr>" : "") + 
                                        "<tr><td>Start Date</td><td>: "+hlp.convertISODateToLocalDisplay(eventObj.start._d.toISOString())+"</td></tr>"+
                                        "<tr><td>End Date</td><td>: "+hlp.convertISODateToLocalDisplay(eventObj.end !=undefined ? eventObj.end._d.toISOString():eventObj.start._d.toISOString())+"</td></tr>"+
                                        "<tr><td>Status</td><td>: "+eventObj.status+"</td></tr>"+ 
                                        (eventObj.Product_Discussed__c!=undefined ?"<tr><td>Topic of Discussion</td><td>: "+eventObj.Product_Discussed__c+"</td></tr>" : "")+
                                        statusCom +
                                        "</table>"+
                                        "</div>";
                                    
                                    return outPut
                                },
                                trigger: 'hover',
                                container: 'body'
                            }).on("mouseleave", function () {
                                $(this).popover("hide");
                            });
                        }
                        catch(e){
                            console.log(e);
                        }
                    },
                    eventAfterRender: function (event, element, view) {
                        var dateString = event.start.format("YYYY-MM-DD");
                        if (event.ObjectName=='H'){
                            if (event.start._d.toString().indexOf('GMT-')!=-1){
                                var d = new Date(event.start);
                                d.setDate(d.getDate() + 1);
                                dateString = d.toISOString().split('T')[0];
                            }
        					$(view.el[0]).find('.fc-day[data-date=' + dateString + ']').css("background", "rgba(252, 244, 3, 0.2)");
                            element.remove();
                            return true;
                        }
                        
                        //console.log('TYpe : ' + event.Type);
                        if (event.Type=="PTO"){
                            element.css({'background':'purple', 'border':'purple'});//Event color
                        }else{
                            if(event.status=="Open"){
                                if (new Date(hlp.convertISODateToLocal(event.start._d.toISOString()))< new Date())
                                    element.css({'background':'red', 'border':'red'});//Event color
                                else 
                                    element.css({'background':'Gray', 'border':'Grey'});//Event color                            
                            } 
                            else if(event.status=="Completed"){
                                if (event.TaskSubType=="Call")
                                    element.css({'background':'green', 'border':'green'});//Event color
                                else
                                    element.css({'background':'green', 'border':'green'});//Event color
                            }
                        }
                    }
                });
                $('#calendar').fullCalendar('option', 'timezone', $A.get("$Locale.timezone"));
                
                var a = cmp.get('c.loadEvents');
                $A.enqueueAction(a); 
                hlp.setCalendarDate(cmp); 
                
                hlp.getTasks(cmp);
            });
        }catch(e){
        }
    },
    selectedCalendarUserRecordChange : function(component, event, helper) {
        var data = component.get("v.customDataCal");
        
        if (component.get("v.selectedCalendarUserRecord")!=undefined && component.get("v.selectedCalendarUserRecord")!=null){
            data.id=component.get("v.selectedCalendarUserRecord").Id!=undefined ? 
                component.get("v.selectedCalendarUserRecord").Id 
            :$A.get("$SObjectType.CurrentUser.Id");
        }else{
            data.id=$A.get("$SObjectType.CurrentUser.Id");
        }
        helper.getTasks(component);
        setTimeout(function(){
            var a = component.get('c.loadEvents');
            $A.enqueueAction(a); 
            helper.setCalendarDate(component);
        },2000);
    },
    closePTOModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenModal", false); 
    }
})