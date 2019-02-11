import 'rxjs/add/operator/switchMap';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Location } from '@angular/common';
import { MatSnackBar } from '@angular/material';

import { Metric } from './metric';
import { Measure } from './measure';
import { MetricService } from './metric.service';
import { MeasureService } from './measure.service';
import { MeasureComponent } from './measure.component';

@Component({
  selector: 'metric-detail',
  templateUrl: './metric-detail.component.html',
  styleUrls: [ './metric-detail.component.css' ]
})
export class MetricDetailComponent implements OnInit {
  metric: Metric;
  measures: Measure[];
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
      .switchMap((params: Params) => this.metricService.getMetric(+params['device_id'], +params['id']))
      .subscribe(metric => this.metric = metric);
    this.route.params
      .switchMap((params: Params) => this.measureService.getMeasures(+params['device_id'], +params['id']))
          .subscribe(measures => this.measures = measures.reverse());
    this.data = [
  {
    'name': 'Germany',
    'series': [
      {
        'name': '2010',
        'value': 7300000
      },
      {
        'name': '2011',
        'value': 8940000
      }
    ]
  },
​
  {
    'name': 'USA',
    'series': [
      {
        'name': '2010',
        'value': 7870000
      },
      {
        'name': '2011',
        'value': 8270000
      }
    ]
  }
]
  }

  openSnackBar(message: string, action: string) {
    this.snackBar.open(message, action, { duration: 2000 });
  }

  save(): void {
    this.metricService.update(this.metric)
      .then(() =>  this.openSnackBar('Metric saved', ''));
  }

  destroy(): void {
    this.metricService.delete(this.metric.id, this.metric.device_id)
      .then(() => {
        this.openSnackBar('Metric destroyed', '');
        this.goBack();
      });
  }

  goBack(): void {
    this.location.back();
  }
}
