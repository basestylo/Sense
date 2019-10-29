import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { environment } from '../environments/environment';
import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { DashboardComponent } from './dashboard.component';
import { DevicesComponent } from './devices.component';
import { DeviceDetailComponent } from './device-detail.component';
import { ActuatorService } from './actuator.service';
import { DeviceService } from './device.service';
import { MetricService } from './metric.service';
import { MeasureService } from './measure.service';
import { ActuatorDetailComponent } from './actuator-detail.component';
import { MetricDetailComponent } from './metric-detail.component';
import { ActuatorsComponent } from './actuators.component';
import { MetricsComponent } from './metrics.component';
import { MeasureComponent } from './measure.component';
import { MaterialModule } from './material.module';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { Observable } from 'rxjs';
import { IMqttMessage,
         MqttModule,
         IMqttServiceOptions } from 'ngx-mqtt';
import { Subscription } from 'rxjs';

import { HighchartsChartModule } from 'highcharts-angular';

export const MQTT_SERVICE_OPTIONS: IMqttServiceOptions = {
  hostname: environment.mqttHost,
  port: environment.mqttPort,
  path: environment.mqttPath,
  username: 'JohnDoEx',
  password: 'foobarfoo',
  protocol: 'wss'
};

@NgModule({
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    AppRoutingModule,
    MaterialModule,
    BrowserAnimationsModule,
    MqttModule.forRoot(MQTT_SERVICE_OPTIONS),
    HighchartsChartModule
  ],
  declarations: [
    AppComponent,
    DashboardComponent,
    ActuatorsComponent,
    ActuatorDetailComponent,
    DeviceDetailComponent,
    DevicesComponent,
    MetricsComponent,
    MetricDetailComponent,
    MeasureComponent
  ],
  providers: [ ActuatorService, DeviceService, MetricService, MeasureService ],
  bootstrap: [ AppComponent ]
})
export class AppModule { }
