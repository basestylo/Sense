import { Injectable } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';

import { Metric } from './metric';

import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

@Injectable()
export class MetricService {

  private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: HttpClient) { }

  getMetrics(device_id: number): Observable<Metric[]> {
    return this.http.get(`${this.devicesUrl}/${device_id}/metrics`)
      .pipe(
        map( (response: any) => response.data)
      );
  }


  getMetric(device_id: number, id: number): Observable<Metric> {
    const url = `${this.devicesUrl}/${device_id}/metrics/${id}`;
    return this.http.get(url)
      .pipe(
        map( (response: any) => response.data)
      );

  }

  delete(id: number, device_id: number): Observable<Object> {
    const url = `${this.devicesUrl}/${device_id}/metrics/${id}`;
    return this.http.delete(url, {headers: this.headers});
  }

  create(metric: Metric): Observable<Metric> {
    return this.http
      .post( `${this.devicesUrl}/${metric.device_id}/metrics`, JSON.stringify({metric: metric}), {headers: this.headers})
      .pipe(
        map( (response: any) => response.data)
      );
  }

  update(metric: Metric): Observable<Metric> {
    const body: any = { metric: metric };
    const url = `${this.devicesUrl}/${metric.device_id}/metrics/${metric.id}`;

    return this.http
      .put(url, JSON.stringify(body), {headers: this.headers})
      .pipe(
        map( (response: any) => response.data)
      );
  }
}
