import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';
import { environment } from '../environments/environment';

import 'rxjs/add/operator/toPromise';

import { Device } from './device';

@Injectable()
export class DeviceService {

  private headers = new Headers({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: Http) { }

  getDevices(): Promise<Device[]> {
    return this.http.get(this.devicesUrl)
               .toPromise()
               .then(response => response.json().data as Device[])
               .catch(this.handleError);
  }


  getDevice(id: number): Promise<Device> {
    const url = `${this.devicesUrl}/${id}`;
    return this.http.get(url)
      .toPromise()
      .then(response => response.json().data as Device)
      .catch(this.handleError);
  }

  delete(id: number): Promise<void> {
    const url = `${this.devicesUrl}/${id}`;
    return this.http.delete(url, {headers: this.headers})
      .toPromise()
      .then(() => null)
      .catch(this.handleError);
  }

  create(device: Device): Promise<Device> {
    return this.http
      .post(this.devicesUrl, JSON.stringify({device: device}), {headers: this.headers})
      .toPromise()
      .then(res => res.json().data as Device)
      .catch(this.handleError);
  }

  update(device: Device): Promise<Device> {
  var body:any = { device: device };
    const url = `${this.devicesUrl}/${device.id}`;
    return this.http
      .put(url, JSON.stringify(body), {headers: this.headers})
      .toPromise()
      .then(() => device)
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error); // for demo purposes only
    return Promise.reject(error.message || error);
  }
}
