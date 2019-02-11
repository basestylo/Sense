import 'rxjs/add/operator/switchMap';
import { Component, OnInit, Input } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Location } from '@angular/common';
import { DatePipe } from '@angular/common';

import { Metric } from './metric';
import { Measure } from './measure';
import { MeasureService } from './measure.service';

@Component({
  selector: 'measure',
  templateUrl: './measure.component.html',
  styleUrls: [ './measure.component.css' ]
})
export class MeasureComponent implements OnInit {
  @Input()
  measure: Measure;

  @Input()
  metric: Metric;

  constructor(
    private measureService: MeasureService,
    private route: ActivatedRoute,
    private location: Location
  ) {}

  ngOnInit(): void {

  }

  create(): void {
    this.measureService.create(this.measure)
      .then(() => this.goBack());
  }

  goBack(): void {
    this.location.back();
  }
}
