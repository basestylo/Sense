import 'rxjs/add/operator/switchMap';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Location } from '@angular/common';
import { MatSnackBar } from '@angular/material';

import { Actuator } from './actuator';
import { Device } from './device';
import { Metric } from './metric';
import { ActuatorService } from './actuator.service';
import { DeviceService } from './device.service';
import { MetricService } from './metric.service';

@Component({
  selector: 'app-device-detail',
  templateUrl: './device-detail.component.html',
  styleUrls: [ './device-detail.component.css' ]
})
export class DeviceDetailComponent implements OnInit {
  actuators: Metric[];
  device: Device;
  metrics: Metric[];

  constructor(
    private actuatorService: ActuatorService,
    private deviceService: DeviceService,
    private metricService: MetricService,
    private route: ActivatedRoute,
    private location: Location,
    public snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.route.params
      .switchMap((params: Params) => this.deviceService.getDevice(+params['id']))
      .subscribe(device => this.device = device);
    this.route.params
      .switchMap((params: Params) => this.metricService.getMetrics(+params['id']))
      .subscribe(metrics => this.metrics = metrics);
    this.route.params
      .switchMap((params: Params) => this.actuatorService.getActuators(+params['id']))
      .subscribe(actuators => this.actuators = actuators);
  }

  openSnackBar(message: string, action: string): void {
    this.snackBar.open(message, action, { duration: 2000 });
  }

  save(): void {
    this.deviceService.update(this.device)
      .then(() =>  this.openSnackBar('Device saved', ''));
  }

  destroy(): void {
    this.deviceService.delete(this.device.id)
      .then(() => {
        this.openSnackBar('Metric destroyed', '');
        this.goBack()
      });
  }

  goBack(): void {
    this.location.back();
  }
}
