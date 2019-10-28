import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Location } from '@angular/common';
import { MatSnackBar } from '@angular/material';

import { Metric } from './metric';
import { Measure } from './measure';
import { MetricService } from './metric.service';
import { MeasureService } from './measure.service';
import { MeasureComponent } from './measure.component';

import * as Highcharts from 'highcharts'

@Component({
  selector: 'app-metric-detail',
  templateUrl: './metric-detail.component.html',
  styleUrls: [ './metric-detail.component.css' ]
})

export class MetricDetailComponent implements OnInit {
  metric: Metric;
  measures: Measure[];
  device_id: number;
  metric_id: number;

  Highcharts = Highcharts;
  chartConstructor = 'chart';
  chartOptions =  {
    chart: {
      marginLeft: 40, // Keep all charts left aligned
      spacingTop: 20,
      spacingBottom: 20,
      className: "chart-measurements"
    },
    title: {
      text: "",
      align: "left",
      margin: 0,
      x: 30
    },
    credits: {
      enabled: false
    },
    legend: {
      enabled: false
    },
    xAxis: {
      crosshair: true,
      events: {
        setExtremes: function(e) {
          var thisChart = this.chart;

          if (e.trigger !== "syncExtremes") {
            // Prevent feedback loop
            Highcharts.each(Highcharts.charts, function(chart) {
              if (
                chart !== thisChart &&
                  chart.options.chart.className ===
                  thisChart.options.chart.className
              ) {
                if (chart.xAxis[0].setExtremes) {
                  // It is null while updating
                  chart.xAxis[0].setExtremes(e.min, e.max, undefined, false, {
                    trigger: "syncExtremes"
                  });
                }
              }
            });
          }
        }
      },
      labels: {
        format: "{(new Date(value)).toLocaleString()}"
      }
    },
    yAxis: {
      title: {
        text: null
      }
    },
    tooltip: {
      positioner: function() {
        return {
          // right aligned
          x: this.chart.chartWidth - this.label.width,
          y: 10 // align to title
        };
      },
      borderWidth: 0,
      backgroundColor: "none",
      pointFormat: "{point.y}",
      headerFormat: "",
      shadow: false,
      style: {
        fontSize: "18px"
      }
    },
    series: [
      {
        name: "",
        data: []
      }
    ]
  };
  // chartCallback = function (chart) { ... } // optional function, defaults to null
  public updateFlag = false; // optional boolean
  oneToOneFlag = true; // optional boolean, defaults to false

  public data: Array<any>;

  constructor(
    private metricService: MetricService,
    private measureService: MeasureService,
    private route: ActivatedRoute,
    private location: Location,
    public snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.route.params
      .subscribe((params: Params) => this.metricService.getMetric(+params['device_id'], +params['id'])
                 .subscribe((metric: Metric) => this.onMetricChange(metric)));
    this.route.params
      .subscribe((params: Params) => this.measureService.getMeasures(+params['device_id'], +params['id'])
                 .subscribe((measures: Measure[]) => this.onMeasureChange(measures)));

  }

  public onMeasureChange(measures): void {
    this.measures = measures;
    this.chartOptions["series"][0]["data"] = measures.map((measure) =>
                                                          [new Date(measure.timestamp).getTime(),
                                                           measure.value]);
    this.updateFlag = true;
  }

  public onMetricChange(metric): void {
    this.metric = metric;

    this.chartOptions["series"][0]["name"] = "Sync group: " + metric.name;
    this.updateFlag = true;
  }

  openSnackBar(message: string, action: string) {
    this.snackBar.open(message, action, { duration: 2000 });
  }

  save(): void {
    this.metricService.update(this.metric)
      .subscribe(() => this.openSnackBar('Metric saved', ''));
  }

  destroy(): void {
    this.metricService.delete(this.metric.id, this.metric.device_id)
      .subscribe(() => {
        this.openSnackBar('Metric destroyed', '');
        this.goBack();
      });
  }

  goBack(): void {
    this.location.back();
  }
}
