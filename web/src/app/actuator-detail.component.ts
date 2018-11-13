import 'rxjs/add/operator/switchMap';
import { Component, OnInit, OnDestroy }      from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Location }               from '@angular/common';
import { MatSnackBar }            from '@angular/material';
import { Observable }      from 'rxjs';
import { Actuator }        from './actuator';
import { ActuatorService } from './actuator.service';
import { Subscription } from 'rxjs';
import {
  IMqttMessage,
  MqttModule,
  MqttService,
  IMqttServiceOptions
} from 'ngx-mqtt';

@Component({
  selector: 'actuator-detail',
  templateUrl: './actuator-detail.component.html',
  styleUrls: [ './actuator-detail.component.css' ]
})

export class ActuatorDetailComponent implements OnInit, OnDestroy {
  actuator: Actuator;
  private subscription: Subscription;
  private message: string;

  constructor(
    private actuatorService: ActuatorService,
    private route: ActivatedRoute,
    private location: Location,
    private _mqttService: MqttService,
    public snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.route.params
      .switchMap((params: Params) => this.actuatorService.getActuator(+params['device_id'], +params['id']))
      .subscribe(actuator => this.actuator = actuator);
    this.subscription = this._mqttService.observe('my/topic').subscribe((message: IMqttMessage) => {
      this.message = message.payload.toString();
    });
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }

  openSnackBar(message: string, action: string) {
    this.snackBar.open(message, action, { duration: 2000 });
  }

  save(): void {
    this.actuatorService.update(this.actuator)
      .then(() =>  this.openSnackBar('Actuator saved', ''));
  }

  destroy(): void {
    this.actuatorService.delete(this.actuator.id)
      .then(() => {
        this.openSnackBar('Actuator destroyed', '');
        this.goBack();
      });
  }

  goBack(): void {
    this.location.back();
  }
}
