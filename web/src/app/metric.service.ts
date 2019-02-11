import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';
import { environment } from '../environments/environment';

import 'rxjs/add/operator/toPromise';

import { Metric } from './metric';

@Injectable()
export class MetricService {

  private headers = new Headers({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: Http) { }

  getMetrics(device_id: number): Promise<Metric[]> {
    return this.http.get(`${this.devicesUrl}/${device_id}/metrics`)
               .toPromise()
               .then(response => response.json().data as Metric[])
               .catch(this.handleError);
  }


  getMetric(device_id: number, id: number): Promise<Metric> {
    const url = `${this.devicesUrl}/${device_id}/metrics/${id}`;
    return this.http.get(url)
      .toPromise()
      .then(response => response.json().data as Metric)
      .catch(this.handleError);
  }

  delete(id: number, device_id: number): Promise<void> {
    const url = `${this.devicesUrl}/${device_id}/metrics/${id}`;
    return this.http.delete(url, {headers: this.headers})
      .toPromise()
      .then(() => null)
      .catch(this.handleError);
  }

  create(metric: Metric): Promise<Metric> {
    return this.http
      .post( `${this.devicesUrl}/${metric.device_id}/metrics`, JSON.stringify({metric: metric}), {headers: this.headers})
      .toPromise()
      .then(res => res.json().data as Metric)
      .catch(this.handleError);
  }

  update(metric: Metric): Promise<Metric> {
  const body:any = { metric: metric };
    const url =  `${this.devicesUrl}/${metric.device_id}/metrics/${metric.id}`;
    return this.http
      .put(url, JSON.stringify(body), {headers: this.headers})
      .toPromise()
      .then(() => metric)
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error); // for demo purposes only
    return Promise.reject(error.message || error);
  }
}
