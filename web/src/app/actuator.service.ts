import { Injectable } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';

import { Actuator } from './actuator';
import { catchError, map } from 'rxjs/operators';

import { Observable, of } from 'rxjs';

@Injectable()
export class ActuatorService {

  private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: HttpClient) { }

  getActuators(device_id: number): Observable<Actuator[]> {
    return this.http.get(`${this.devicesUrl}/${device_id}/actuators`)
      .pipe(
        map( (response: any) => response.data as Actuator[])
      );
  }

  getActuator(device_id: number, id: number): Observable<Actuator> {
    const url = `${this.devicesUrl}/${device_id}/actuators/${id}`;
    return this.http.get(url)
      .pipe(
        map( (response: any) => response.data as Actuator)
      );
  }

  delete(actuator: Actuator): Observable<Object> {
    const url = `${this.devicesUrl}/${actuator.device_id}/actuators/${actuator.id}`;
    return this.http.delete(url, {headers: this.headers})
  }

  create(actuator: Actuator): Observable<Actuator> {
    actuator.value = +actuator.value
    return this.http
      .post( `${this.devicesUrl}/${actuator.device_id}/actuators`, JSON.stringify({actuator: actuator}), {headers: this.headers})
      .pipe(
        map( (response: any) => response.data as Actuator)
      );
  }

  update(actuator: Actuator): Observable<Actuator> {
    actuator.value = +actuator.value
    const body: any = { actuator: actuator };
    const url = `${this.devicesUrl}/${actuator.device_id}/actuators/${actuator.id}`;

    return this.http
      .put(url, JSON.stringify(body), {headers: this.headers})
      .pipe(
        map( (response: any) => response.data as Actuator)
      );
  }
}
