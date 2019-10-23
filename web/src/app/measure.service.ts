import { Injectable } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';

import { Measure } from './measure';
import { catchError, map } from 'rxjs/operators';

import { Observable, of } from 'rxjs';

@Injectable()
export class MeasureService {

  private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: HttpClient) { }

  getMeasures(device_id: number, metric_id: number): Observable<Measure[]> {
    return this.http.get(`${this.devicesUrl}/${device_id}/metrics/${metric_id}/measures`)
      .pipe(
        map( (response: any) => response.data as Measure[])
      );
  }

  create(measure: Measure): Observable<Measure> {
    return this.http
      .post( `${this.devicesUrl}/${measure.metric_id}/measures`, JSON.stringify({measure: measure}), {headers: this.headers})
      .pipe(
        map( (response: any) => response.data as Measure )
      );
  }
}
