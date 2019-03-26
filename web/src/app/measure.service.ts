import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';
import { environment } from '../environments/environment';

import 'rxjs/add/operator/toPromise';

import { Measure } from './measure';

@Injectable()
export class MeasureService {

  private headers = new Headers({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: Http) { }

  getMeasures(device_id: number, metric_id: number): Promise<Measure[]> {
    return this.http.get(`${this.devicesUrl}/${device_id}/metrics/${metric_id}/measures`)
               .toPromise()
               .then(response => response.json().data as Measure[])
               .catch(this.handleError);
  }

  create(measure: Measure): Promise<Measure> {
    return this.http
      .post( `${this.devicesUrl}/${measure.metric_id}/measures`, JSON.stringify({measure: measure}), {headers: this.headers})
      .toPromise()
      .then(res => res.json().data as Measure)
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error); // for demo purposes only
    return Promise.reject(error.message || error);
  }
}
