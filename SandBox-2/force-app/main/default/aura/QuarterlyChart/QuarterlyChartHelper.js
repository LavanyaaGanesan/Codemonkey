({
    getQChart : function(component) {
        
        var action = component.get('c.getVaxQuarterly');
        console.log(':action:::::::'+component.get("v.PName")+component.get("v.SYear"));
        //action.setParams({ SalesPlannerID : component.get("v.recordId") });
        action.setParams({ SalesPlannerID : component.get("v.recordId"),  productName : component.get("v.PName"),  year : component.get("v.SYear")});
        console.log(':Record Id:::::::'+component.get("v.recordId"));
        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());
            console.log(':action:::::::'+state);
            
            if(state === "SUCCESS"){
                console.log("---response.getReturnValue()-"+response.getReturnValue());
                component.set("v.QuarterlyChartList",response.getReturnValue());
                var jsonData = response.getReturnValue();
                var dataObj = [];
                dataObj[0] = {
                    name: component.get("v.PName") ,
                    data: [0,0,0,0,0,0,0,0]
                };
                 
                console.log(jsonData.Lastyear.length+'&&&*****&&&&'+jsonData.Thisyear.length);
                
               for(var i=0; i<jsonData.Lastyear.length; i++)
               {
                  
                   		console.log(jsonData.Lastyear[i].expr0+'&&&&&&&'+jsonData.Lastyear[i].expr1);
                   		dataObj[0].data[jsonData.Lastyear[i].expr0-1]=jsonData.Lastyear[i].expr1;
                 
               }
                for(var i=0; i<jsonData.Thisyear.length; i++)
               {
                   
                   		console.log(jsonData.Thisyear[i].expr0+'&&&&&&&'+jsonData.Thisyear[i].expr1);
                   		dataObj[0].data[jsonData.Thisyear[i].expr0+3]=jsonData.Thisyear[i].expr1;
                 
               }
                dataObj[0].data.reverse();
                console.log("dfghg"+JSON.stringify(jsonData));
                console.log("dataObj"+JSON.stringify(dataObj));
                
              /*  
                dataObj[1] = {
                    name: 'Quarter',
                    data: [30,30,15]
                };
               /* var jsonData = component.get("v.data");
                var dataObj = JSON.parse(jsonData);
                console.log('jsonData===',jsonData);
                
                console.log('dataObj===',dataObj);*/
                
                jsonData = JSON.stringify(dataObj);
                component.set("v.data",jsonData);
                console.log(dataObj, '======', jsonData);
                new Highcharts.Chart({
                    chart: {
                        renderTo: component.find("chart").getElement(),
                        type: 'column'
                    },
                     title: 
                    {
                        text: [component.get("v.Name1")]
                    },
                    
                    colors:[component.get("v.color")],
                    subtitle: {
                        text: ''
                    },
                    xAxis: {
                        categories: ['Q4 CY2019','Q3 CY2019','Q2 CY2019','Q1 CY2019','Q4 CY2018','Q3 CY2018','Q2 CY2018','Q1 CY2018'],
                        crosshair: true
                    },
                    yAxis: {
                        
                        title: 
                        {
                            text: 'Total Doses(In Units)' //component.get("v.SYear")
                        }
                    },
                    tooltip: 
                    {
                        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true
                    },
                    plotOptions: {
                        column: {
                             dataLabels: {
                enabled: true
            },
            enableMouseTracking: false,
        

                            pointPadding: 0.2,
                            borderWidth: 0
                        }
                    },
                    series: dataObj
                });
                
            }
            
            
        });
        $A.enqueueAction(action)
    } 
    
})