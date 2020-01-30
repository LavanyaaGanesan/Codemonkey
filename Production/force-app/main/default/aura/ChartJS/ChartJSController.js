({
    loadChart : function(component, event, helper) 
    {
        console.log('Enter');
        
        var _labels = component.get("v.cLabels");
        var chartData = component.get("v.cDataObj");
        var maxValue =0;
        for (var i=0;i<chartData.length;i++){
            if (i==0)
                maxValue=chartData[i];
            if(chartData[i]>maxValue)
                maxValue = chartData[i];
        } 
        var addValue =(200-(maxValue%100));
		var stepSizeValue = (maxValue+addValue) / 5;
        
        /************************************************
            Start: Chart JS Code
            *************************************************/
        var color = Chart.helpers.color;
        var barChartData = {
            labels: _labels,
            datasets: [{
                label: component.get("v.cChartName"),
                backgroundColor: component.get("v.cColor"),
                borderColor: component.get("v.cColor"),
                borderWidth: 1,
                data: chartData
            }]
        };
        var ctx =document.getElementById('canvas' +component.get("v.cSection")).getContext('2d');
        window.myBar = new Chart(ctx, {
            type: 'horizontalBar',
            data: barChartData,
            options: {
                tooltips: {
                      enabled: ($A.get("$Browser.formFactor")=='DESKTOP' ? true : false) ,
                    backgroundColor : 'rgba(0, 0, 0)'
                },
                
                responsive: true,
               maintainAspectRatio: ($A.get("$Browser.formFactor")=='DESKTOP' ? true : false) ,
                 //maintainAspectRatio:true,
                legend: {
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                        pointStyle : 'circle',
                        fontStyle : 'bold',
                        fontColor: '#000000'
                    }
                },
          
                /***************************************/
                
                "hover": {
                    "animationDuration": 0
                },
                "animation": {
                    "duration": 1,
                    "onComplete": function() {
                        
                        var chartInstance = this.chart,
                            ctx = chartInstance.ctx;
                        
                        //ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, Chart.defaults.global.defaultFontStyle, Chart.defaults.global.defaultFontFamily);
                        ctx.font = '10px "Arial Black"';                      
                        
                        this.data.datasets.forEach(function(dataset, i) {
                            var meta = chartInstance.controller.getDatasetMeta(i);
                            meta.data.forEach(function(bar, index) {
                                var data = dataset.data[index];
                               ctx.fillText(data, bar._model.x+3, bar._model.y); 
                            });
                        });
                    }
                },
                
                /**************************************/
                
                
                
                title: {
                    display: true,
                    text: component.get("v.cName1"),
                    fontSize : '20',
                    fontStyle : 'normal',
                    padding: 15
                },
                
                scales: {
                    yAxes: [{
                        gridLines: {
                            display: false
                        },
                        display: true,
                        scaleLabel: {
                            display: false,
                            labelString: 'Year'
                        },
                        
                        ticks: {
                            beginAtZero: true,
                            major: {
                                fontStyle: 'bold',
                                fontColor: '#FF0000'
                            }
                        }
                    }],
                    xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: 'Total Doses (In Units)'
                        },
                        ticks: {
                            beginAtZero: true,
                                steps: 5,
                            	min: 0,
                            	max: maxValue+addValue,
                            	stepSize: stepSizeValue
                        }
                    }]
                }
            }
        });   
        
        myBar.update();
        
        
        /************************************************
            End: Chart JS Code
            *************************************************/
        console.log('Finish');
    },
})