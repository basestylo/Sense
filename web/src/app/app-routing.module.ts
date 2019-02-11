import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { DashboardComponent } from './dashboard.component';
import { DevicesComponent } from './devices.component';
import { DeviceDetailComponent } from './device-detail.component';
import { MetricsComponent } from './metrics.component';
import { ActuatorsComponent } from './actuators.component';
import { MetricDetailComponent } from './metric-detail.component';
import { ActuatorDetailComponent } from './actuator-detail.component';

const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'dashboard',                        component: DashboardComponent },
  { path: 'devices/:id',                      component: DeviceDetailComponent },
  { path: 'devices/:device_id/metrics',       component: MetricsComponent },
  { path: 'devices/:device_id/actuators',     component: ActuatorsComponent },
  { path: 'devices/:device_id/metrics/:id',   component: MetricDetailComponent },
  { path: 'devices/:device_id/actuators/:id', component: ActuatorDetailComponent },
  { path: 'devices',                          component: DevicesComponent }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
