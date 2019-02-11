import { Component, OnInit} from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Router } from '@angular/router';
import { Location } from '@angular/common';

import { Metric }        from './metric';
import { MetricService } from './metric.service';

@Component({
  selector: 'my-metrics',
  templateUrl: './metrics.component.html',
  styleUrls: [ './metrics.component.css' ]
})

export class MetricsComponent implements OnInit {
  metric: Metric;
  device_id: number;

  constructor(
    private route: ActivatedRoute,
    private metricService: MetricService,
    private location: Location
  ) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.device_id = +params['device_id'];
    });
  }

  add(name: string, description: string): void {
    name = name.trim();
    description = description.trim();

    if (!name || !description) { return; }
    const new_metric: Metric = {id: 0, name: name, description: description, device_id: this.device_id};

     this.metricService.create(new_metric)
      .then( () => this.goBack());
  }

  goBack(): void {
    this.location.back();
  }
}
