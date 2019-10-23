import { Injectable } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';

import { Device } from './device';

import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

@Injectable()
export class DeviceService {

  private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: HttpClient) { }

  getDevices(): Observable<Device[]> {
    return this.http
      .get(this.devicesUrl)
      .pipe(
        map( (response: any) => response.data as Device[] )
      );
  }


  getDevice(id: number): Observable<Device> {
    const url = `${this.devicesUrl}/${id}`;
    return this.http
      .get(url)
      .pipe(
        map( (response: any) => response.data as Device )
      );
  }

  delete(id: number): Observable<Object> {
    const url = `${this.devicesUrl}/${id}`;
    return this.http
      .delete(url, {headers: this.headers})
  }

  create(device: Device): Observable<Device> {
    const body: any = { device: device };
    return this.http
      .post(this.devicesUrl,
            JSON.stringify(body),
            {headers: this.headers})
      .pipe(
        map( (response: any) => response as Device )
      );
  }

  update(device: Device): Observable<Device> {
    const body: any = { device: device };
    const url = `${this.devicesUrl}/${device.id}`;

    return this.http
      .put(url, JSON.stringify(body), {headers: this.headers})
      .pipe(
        map( (response: any) => response as Device )
      );
  }
}
