({    
    getQChart : function(component) {        
        var setBlank =[];
        //console.log('---getQChart--');
        component.set("v.QuarterlyChartList",setBlank);
        var action = component.get('c.getMonthlyData');
        //console.log(':action:::::::'+component.get("v.PName")+component.get("v.SYear"));
        action.setParams({ 
            SalesPlannerID : component.get("v.recordId"),  
            productName : component.get("v.PName"),  
            year : component.get("v.SYear")});
        //console.log(':Record Id:::::::'+component.get("v.recordId"));
        action.setCallback(this,function(response){            
            var state = response.getState();
            
            //console.log(':action:::::::'+state);
            
            if(state === "SUCCESS"){
                //console.log("---response.getReturnValue()-"+response.getReturnValue());
                component.set("v.QuarterlyChartList",response.getReturnValue());
                //this.loadChart(component,component.get("v.QuarterlyChartList")); 
                this.getRelatedData(component);            
            }
        });
        $A.enqueueAction(action)
    },
    
    getRelatedData : function(component) {
        //console.log('---getRelatedData--');
        
        var jsonData = component.get("v.QuarterlyChartList");
        var dataObj = [];        
        dataObj[0] = {
            data: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        };
        
        for(var i=0; i<jsonData.Thisyear.length; i++)
        { 
            dataObj[0].data[jsonData.Thisyear[i].expr0-1]=jsonData.Thisyear[i].expr1;
        }
        for(var i=0; i<jsonData.Lastyear.length; i++)
        {
            dataObj[0].data[jsonData.Lastyear[i].expr0+11]=jsonData.Lastyear[i].expr1;
        }
        
        var allData= dataObj[0].data;
        //console.log("---all data---"+allData);
//        if ($A.get("$Browser.formFactor")=='PHONE'){
  //          component.set("v.selectedYear", "1");
    //    }
        var selectedYearValue = component.get("v.selectedYear");
        var selectedQuaterValue = component.get("v.selectedQuarterly");
        var selectedMonthValue = component.get("v.selectedMonth");
        
        var months = ['Jan-','Feb-','Mar-','Apr-','May-','Jun-' ,'Jul-','Aug-','Sep-','Oct-','Nov-','Dec-'];
        var quarter = ['Q1-CY','Q2-CY','Q3-CY','Q4-CY','Q1-PY','Q2-PY','Q3-PY','Q4-PY', 'Jan-Jun ','Jul-Dec ','Year-'];
        var curYear =new Date().getFullYear();
        var prevYear=curYear-1;
        
        var outData = [];
        var _labels = [];
        
        var cnt =0;
        var total =0;
        
        var iStart = (selectedYearValue=="0" ? 0 : ( selectedYearValue=="1" ? 12 : (0)));
        var iBreak = (selectedYearValue=="0" ? 11 : 23); 
        cnt = iStart;
        if (selectedQuaterValue !="1")
        {
            component.set("v.selectedMonth","");
        }
        if (selectedQuaterValue =="1")
        {   
            component.set("v.showMonth",true);
            
            if (selectedMonthValue==''){
                for(var i = iStart ;i<allData.length;i++){
                    outData.push(allData[i]);
                    var lbl = months[i-(i>11 ? 12 : 0)] + (i>11 ? '' + prevYear : '' + curYear);
                    _labels.push(lbl);
                    if (iBreak==i)
                        break;
                }   
            }
            else{
                var ind=selectedMonthValue-1;
                if (selectedYearValue=="0" || selectedYearValue=="2"){                    
                    outData.push(allData[ind]);
                    _labels.push(months[ind] + '' + curYear);
                    
                }
                if (selectedYearValue=="1" || selectedYearValue=="2"){
                    outData.push(allData[ind+12]);
                    _labels.push(months[ind] + '' + prevYear);
                    
                }  
            }         
        } 
        else if (selectedQuaterValue =="3"){
            component.set("v.showMonth",false);            
            for(var i = iStart ;i<allData.length;i++){
                cnt++;
                total+=allData[i];
                if ((cnt)%selectedQuaterValue==0){
                    //console.log('total : ' + i + ' = ' + total);
                    outData.push(total);
                    var lbl = quarter[(cnt/3)-1] + ((cnt/3)-1>3? '' +prevYear : '' +curYear);
                    _labels.push(lbl);
                    total =0;
                }
                if (iBreak==i)
                    break;
            }           
        } 
            else if (selectedQuaterValue =="6"){ 
                component.set("v.showMonth",false);
                for(var i = iStart ;i<allData.length;i++){
                    cnt++;
                    total+=allData[i];
                    if ((cnt)%selectedQuaterValue==0){
                        outData.push(total);
                        var lbl = quarter[(i>11 ? 5 : 7)+(cnt/6)] + (i>11? '' +prevYear : '' +curYear);
                        _labels.push(lbl);
                        total =0;
                    }
                    if (iBreak==i)
                        break;
                }           
            } 
                else if (selectedQuaterValue =="12"){  
                    component.set("v.showMonth",false);
                    for(var i = iStart ;i<allData.length;i++){
                        cnt++;
                        total+=allData[i];
                        if ((cnt)%selectedQuaterValue==0){
                            outData.push(total);
                            var lbl = quarter[10] + (i>11? '' +prevYear : '' +curYear);
                            _labels.push(lbl);
                            total =0;
                        }
                        if (iBreak==i)
                            break;
                    }           
                }
        
        component.set("v.dataObj", outData);        
        component.set("v.labels", _labels); 
        component.set("v.resetChart", true);        
        //console.log('outData--'+outData);
        //console.log('_labels---'+_labels);
        //this.loadChartData(component); 
    },
    
    getQChartReverse : function(component) {        
        var setBlank =[];
        //console.log('---getQChart--');
        component.set("v.QuarterlyChartList",setBlank);
        var action = component.get('c.getMonthlyDataReverse');
       // console.log(':action:::::::'+component.get("v.PName")+component.get("v.SYear"));
        action.setParams({ 
            SalesPlannerID : component.get("v.recordId"),  
            productName : component.get("v.PName"),  
            year : component.get("v.SYear")});
        //console.log(':Record Id:::::::'+component.get("v.recordId"));
        action.setCallback(this,function(response){            
            var state = response.getState();
            
            //console.log(':action:::::::'+state);
            
            if(state === "SUCCESS"){
                //console.log("---response.getReturnValue()-"+response.getReturnValue());
                component.set("v.QuarterlyChartList",response.getReturnValue());
                //this.loadChart(component,component.get("v.QuarterlyChartList")); 
                this.getRelatedDataReverse(component);            
            }
        });
        $A.enqueueAction(action)
    }, 
    
    getRelatedDataReverse : function(component) {
        //console.log('---getRelatedData--');
        
        var jsonData = component.get("v.QuarterlyChartList");
        var dataObj = [];        
        dataObj[0] = {
            data: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        };
        
        for(var i=0; i<jsonData.Lastyear.length; i++)
        {
            dataObj[0].data[jsonData.Lastyear[i].expr0-1]=jsonData.Lastyear[i].expr1;
        }
        for(var i=0; i<jsonData.Thisyear.length; i++)
        { 
            dataObj[0].data[jsonData.Thisyear[i].expr0+11]=jsonData.Thisyear[i].expr1;
        }
        
        var allData= dataObj[0].data;
        
    //    if ($A.get("$Browser.formFactor")=='PHONE' && component.get("v.selectedYear")=="2"){
   //         component.set("v.selectedYear", "1");
   //     }
        
        //console.log("---all data---"+allData);
        var selectedYearValue = component.get("v.selectedYear");
        var selectedQuaterValue = component.get("v.selectedQuarterly");
        var selectedMonthValue = component.get("v.selectedMonth");
        
        var months = ['Jan-','Feb-','Mar-','Apr-','May-','Jun-' ,'Jul-','Aug-','Sep-','Oct-','Nov-','Dec-'];
        var quarter = ['Q1-PY','Q2-PY','Q3-PY','Q4-PY','Q1-CY','Q2-CY','Q3-CY','Q4-CY', 'Jan-Jun ','Jul-Dec ','Year-'];
        var curYear =new Date().getFullYear();
        var prevYear=curYear-1;
        
        var outData = [];
        var _labels = [];
        
        var cnt =0;
        var total =0;
        
        var iStart = (selectedYearValue=="0" ? 0 : ( selectedYearValue=="1" ? 12 : (0)));
        var iBreak = (selectedYearValue=="0" ? 11 : 23); 
        cnt = iStart;
        if (selectedQuaterValue !="1")
        {
            component.set("v.selectedMonth","");
        }
        if (selectedQuaterValue =="1")
        {   
            component.set("v.showMonth",true);
            
            if (selectedMonthValue==''){
                for(var i = iStart ;i<allData.length;i++){
                    outData.push(allData[i]);
                    var lbl = months[i-(i>11 ? 12 : 0)] + (i>11 ? '' + curYear : '' + prevYear);
                    _labels.push(lbl);
                    if (iBreak==i)
                        break;
                }   
            }
            else{
                var ind=selectedMonthValue-1;
                if (selectedYearValue=="0" || selectedYearValue=="2"){                    
                    outData.push(allData[ind]);
                    _labels.push(months[ind] + '' + prevYear);
                    
                }
                if (selectedYearValue=="1" || selectedYearValue=="2"){
                    outData.push(allData[ind+12]);
                    _labels.push(months[ind] + '' + curYear);
                    
                }  
            }         
        } 
        else if (selectedQuaterValue =="3"){
            component.set("v.showMonth",false);            
            for(var i = iStart ;i<allData.length;i++){
                cnt++;
                total+=allData[i];
                if ((cnt)%selectedQuaterValue==0){
                    //console.log('total : ' + i + ' = ' + total);
                    outData.push(total);
                    var lbl = quarter[(cnt/3)-1] + ((cnt/3)-1>3? '' + curYear : '' +prevYear);
                    _labels.push(lbl);
                    total =0;
                }
                if (iBreak==i)
                    break;
            }           
        } 
            else if (selectedQuaterValue =="6"){  
                component.set("v.showMonth",false);
                for(var i = iStart ;i<allData.length;i++){
                    cnt++;
                    total+=allData[i];
                    if ((cnt)%selectedQuaterValue==0){
                        outData.push(total);
                        var lbl = quarter[(i>11 ? 5 : 7)+(cnt/6)] + (i>11? '' +curYear : '' +prevYear);
                        _labels.push(lbl);
                        total =0;
                    }
                    if (iBreak==i)
                        break;
                }           
            } 
                else if (selectedQuaterValue =="12"){  
                    component.set("v.showMonth",false);
                    for(var i = iStart ;i<allData.length;i++){
                        cnt++;
                        total+=allData[i];
                        if ((cnt)%selectedQuaterValue==0){
                            outData.push(total);
                            var lbl = quarter[10] + (i>11? '' +curYear : '' +prevYear);
                            _labels.push(lbl);
                            total =0;
                        }
                        if (iBreak==i)
                            break;
                    }           
                }
        
        component.set("v.dataObj", outData.reverse());        
        component.set("v.labels", _labels.reverse()); 
        component.set("v.resetChart", true);        
        //console.log('outData--'+outData);
        //console.log('_labels---'+_labels);
        //this.loadChartData(component); 
    },
    
    getQChartReverseVax : function(component) {        
        var setBlankVax =[];
        //console.log('---getQChart--');
        component.set("v.QuarterlyChartListVax",setBlankVax);
        var actionVax = component.get('c.getMonthlyDataReverse');
        //console.log(':action:::::::'+component.get("v.vaxPName")+component.get("v.vaxSYear"));
        actionVax.setParams({ 
            SalesPlannerID : component.get("v.recordId"),  
            productName : component.get("v.vaxPName"),  
            year : component.get("v.vaxSYear")});
        //console.log(':Record Id:::::::'+component.get("v.recordId"));
        actionVax.setCallback(this,function(responseVax){            
            var stateVax = responseVax.getState();
            
            //console.log(':action:::::::'+stateVax);
            
            if(stateVax === "SUCCESS"){
                //console.log("---response.getReturnValue()-"+responseVax.getReturnValue());
                component.set("v.QuarterlyChartListVax",responseVax.getReturnValue());
                //this.loadChart(component,component.get("v.QuarterlyChartList")); 
                this.getRelatedDataReverseVax(component);            
            }
        });
        $A.enqueueAction(actionVax)
    },
    
    getRelatedDataReverseVax : function(component) {
        //console.log('---getRelatedData--');
        
        var jsonDataVax = component.get("v.QuarterlyChartListVax");
        var vaxDataObj = [];        
        vaxDataObj[0] = {
            data: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        };
        
        for(var i=0; i<jsonDataVax.Lastyear.length; i++)
        {
            vaxDataObj[0].data[jsonDataVax.Lastyear[i].expr0-1]=jsonDataVax.Lastyear[i].expr1;
        }
        for(var i=0; i<jsonDataVax.Thisyear.length; i++)
        { 
            vaxDataObj[0].data[jsonDataVax.Thisyear[i].expr0+11]=jsonDataVax.Thisyear[i].expr1;
        }
        
        var allDataVax= vaxDataObj[0].data;
        
    //    if ($A.get("$Browser.formFactor")=='PHONE' && component.get("v.selectedYear")=="2"){
  //          component.set("v.selectedYear", "1");
   //     }
        
        //console.log("---all data---"+allDataVax);
        var selectedYearValueVax = component.get("v.selectedYear");
        var selectedQuaterValueVax = component.get("v.selectedQuarterly");
        var selectedMonthValueVax = component.get("v.selectedMonth");
        
        var monthsVax = ['Jan-','Feb-','Mar-','Apr-','May-','Jun-' ,'Jul-','Aug-','Sep-','Oct-','Nov-','Dec-'];
        var quarterVax = ['Q1-PY','Q2-PY','Q3-PY','Q4-PY','Q1-CY','Q2-CY','Q3-CY','Q4-CY', 'Jan-Jun ','Jul-Dec ','Year-'];
        var curYearVax =new Date().getFullYear();
        var prevYearVax=curYearVax-1;
        
        var outDataVax = [];
        var _labelsVax = [];
        
        var cntVax =0;
        var totalVax =0;
        
        var iStartVax = (selectedYearValueVax=="0" ? 0 : ( selectedYearValueVax=="1" ? 12 : (0)));
        var iBreakVax = (selectedYearValueVax=="0" ? 11 : 23); 
        cntVax = iStartVax;
        if (selectedQuaterValueVax !="1")
        {
            component.set("v.selectedMonth","");
        }
        if (selectedQuaterValueVax =="1")
        {   
            component.set("v.showMonth",true);
            
            if (selectedMonthValueVax==''){
                for(var i = iStartVax ;i<allDataVax.length;i++){
                    outDataVax.push(allDataVax[i]);
                    var lbl = monthsVax[i-(i>11 ? 12 : 0)] + (i>11 ? '' + curYearVax : '' + prevYearVax);
                    _labelsVax.push(lbl);
                    if (iBreakVax==i)
                        break;
                }   
            }
            else{
                var ind=selectedMonthValueVax-1;
                if (selectedYearValueVax=="0" || selectedYearValueVax=="2"){                    
                    outDataVax.push(allDataVax[ind]);
                    _labelsVax.push(monthsVax[ind] + '' + prevYearVax);
                    
                }
                if (selectedYearValueVax=="1" || selectedYearValueVax=="2"){
                    outDataVax.push(allDataVax[ind+12]);
                    _labelsVax.push(monthsVax[ind] + '' + curYearVax);
                    
                }  
            }         
        } 
        else if (selectedQuaterValueVax =="3"){
            component.set("v.showMonth",false);            
            for(var i = iStartVax ;i<allDataVax.length;i++){
                cntVax++;
                totalVax+=allDataVax[i];
                if ((cntVax)%selectedQuaterValueVax==0){
                    //console.log('total : ' + i + ' = ' + totalVax);
                    outDataVax.push(totalVax);
                    var lbl = quarterVax[(cntVax/3)-1] + ((cntVax/3)-1>3? '' + curYearVax : '' +prevYearVax);
                    _labelsVax.push(lbl);
                    totalVax =0;
                }
                if (iBreakVax==i)
                    break;
            }           
        } 
            else if (selectedQuaterValueVax =="6"){  
                component.set("v.showMonth",false);
                for(var i = iStartVax ;i<allDataVax.length;i++){
                    cntVax++;
                    totalVax+=allDataVax[i];
                    if ((cntVax)%selectedQuaterValueVax==0){
                        outDataVax.push(totalVax);
                        var lbl = quarterVax[(i>11 ? 5 : 7)+(cntVax/6)] + (i>11? '' +curYearVax : '' +prevYearVax);
                        _labelsVax.push(lbl);
                        totalVax =0;
                    }
                    if (iBreakVax==i)
                        break;
                }           
            } 
                else if (selectedQuaterValueVax =="12"){  
                    component.set("v.showMonth",false);
                    for(var i = iStartVax ;i<allDataVax.length;i++){
                        cntVax++;
                        totalVax+=allDataVax[i];
                        if ((cntVax)%selectedQuaterValueVax==0){
                            outDataVax.push(totalVax);
                            var lbl = quarterVax[10] + (i>11? '' +curYearVax : '' +prevYearVax);
                            _labelsVax.push(lbl);
                            totalVax =0;
                        }
                        if (iBreakVax==i)
                            break;
                    }           
                }
        
        component.set("v.vaxDataObj", outDataVax.reverse());        
        component.set("v.vaxLabels", _labelsVax.reverse()); 
        component.set("v.vaxResetChart", true);        
        //console.log('outDatavax--'+outDataVax);
        //console.log('_labelsvax---'+_labelsVax);
        //this.loadChartData(component); 
    },
    
    getQChartReverseTyp : function(component) {        
        var setBlank =[];
        //console.log('---getQChart--');
        component.set("v.QuarterlyChartListTyp",setBlank);
        var action = component.get('c.getMonthlyDataReverse');
        //console.log(':action:::::::'+component.get("v.TypPName")+component.get("v.TypSYear"));
        action.setParams({ 
            SalesPlannerID : component.get("v.recordId"),  
            productName : component.get("v.TypPName"),  
            year : component.get("v.TypSYear")});
        //console.log(':Record Id:::::::'+component.get("v.recordId"));
        action.setCallback(this,function(response){            
            var state = response.getState();
            
            //console.log(':action:::::::'+state);
            
            if(state === "SUCCESS"){
                //console.log("---response.getReturnValue()-"+response.getReturnValue());
                component.set("v.QuarterlyChartListTyp",response.getReturnValue());
                //this.loadChart(component,component.get("v.QuarterlyChartList")); 
                this.getRelatedDataReverseTyp(component);            
            }
        });
        $A.enqueueAction(action)
    },
    
    getRelatedDataReverseTyp : function(component) {
        //console.log('---getRelatedData--');
        
        var jsonData = component.get("v.QuarterlyChartListTyp");
        var TypDataObj = [];        
        TypDataObj[0] = {
            data: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        };
        
        for(var i=0; i<jsonData.Lastyear.length; i++)
        {
            TypDataObj[0].data[jsonData.Lastyear[i].expr0-1]=jsonData.Lastyear[i].expr1;
        }
        for(var i=0; i<jsonData.Thisyear.length; i++)
        { 
            TypDataObj[0].data[jsonData.Thisyear[i].expr0+11]=jsonData.Thisyear[i].expr1;
        }
        
        var allData= TypDataObj[0].data;
        
   //     if ($A.get("$Browser.formFactor")=='PHONE' && component.get("v.selectedYear")=="2"){
   //         component.set("v.selectedYear", "1");
    //    }
        
        //console.log("---all data---"+allData);
        var selectedYearValue = component.get("v.selectedYear");
        var selectedQuaterValue = component.get("v.selectedQuarterly");
        var selectedMonthValue = component.get("v.selectedMonth");
        
        var months = ['Jan-','Feb-','Mar-','Apr-','May-','Jun-' ,'Jul-','Aug-','Sep-','Oct-','Nov-','Dec-'];
        var quarter = ['Q1-PY','Q2-PY','Q3-PY','Q4-PY','Q1-CY','Q2-CY','Q3-CY','Q4-CY', 'Jan-Jun ','Jul-Dec ','Year-'];
        var curYear =new Date().getFullYear();
        var prevYear=curYear-1;
        
        var outData = [];
        var _labels = [];
        
        var cnt =0;
        var total =0;
        
        var iStart = (selectedYearValue=="0" ? 0 : ( selectedYearValue=="1" ? 12 : (0)));
        var iBreak = (selectedYearValue=="0" ? 11 : 23); 
        cnt = iStart;
        if (selectedQuaterValue !="1")
        {
            component.set("v.selectedMonth","");
        }
        if (selectedQuaterValue =="1")
        {   
            component.set("v.showMonth",true);
            
            if (selectedMonthValue==''){
                for(var i = iStart ;i<allData.length;i++){
                    outData.push(allData[i]);
                    var lbl = months[i-(i>11 ? 12 : 0)] + (i>11 ? '' + curYear : '' + prevYear);
                    _labels.push(lbl);
                    if (iBreak==i)
                        break;
                }   
            }
            else{
                var ind=selectedMonthValue-1;
                if (selectedYearValue=="0" || selectedYearValue=="2"){                    
                    outData.push(allData[ind]);
                    _labels.push(months[ind] + '' + prevYear);
                    
                }
                if (selectedYearValue=="1" || selectedYearValue=="2"){
                    outData.push(allData[ind+12]);
                    _labels.push(months[ind] + '' + curYear);
                    
                }  
            }         
        } 
        else if (selectedQuaterValue =="3"){
            component.set("v.showMonth",false);            
            for(var i = iStart ;i<allData.length;i++){
                cnt++;
                total+=allData[i];
                if ((cnt)%selectedQuaterValue==0){
                    //console.log('total : ' + i + ' = ' + total);
                    outData.push(total);
                    var lbl = quarter[(cnt/3)-1] + ((cnt/3)-1>3? '' + curYear : '' +prevYear);
                    _labels.push(lbl);
                    total =0;
                }
                if (iBreak==i)
                    break;
            }           
        } 
            else if (selectedQuaterValue =="6"){  
                component.set("v.showMonth",false);
                for(var i = iStart ;i<allData.length;i++){
                    cnt++;
                    total+=allData[i];
                    if ((cnt)%selectedQuaterValue==0){
                        outData.push(total);
                        var lbl = quarter[(i>11 ? 5 : 7)+(cnt/6)] + (i>11? '' +curYear : '' +prevYear);
                        _labels.push(lbl);
                        total =0;
                    }
                    if (iBreak==i)
                        break;
                }           
            } 
                else if (selectedQuaterValue =="12"){  
                    component.set("v.showMonth",false);
                    for(var i = iStart ;i<allData.length;i++){
                        cnt++;
                        total+=allData[i];
                        if ((cnt)%selectedQuaterValue==0){
                            outData.push(total);
                            var lbl = quarter[10] + (i>11? '' +curYear : '' +prevYear);
                            _labels.push(lbl);
                            total =0;
                        }
                        if (iBreak==i)
                            break;
                    }           
                }
        
        component.set("v.TypDataObj", outData.reverse());        
        component.set("v.TypLabels", _labels.reverse()); 
        component.set("v.TypResetChart", true);        
        //console.log('outData--'+outData);
        //console.log('_labels---'+_labels);
        //this.loadChartData(component); 
    }
    
    
    
})