import { Injectable } from '@angular/core';
import { Http } from '@angular/http';

import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';

import { Device } from './device';

@Injectable()
export class DeviceSearchService {

  constructor(private http: Http) {}

  search(term: string): Observable<Device[]> {
    return this.http
               .get(`app/devices/?name=${term}`)
               .map(response => response.json().data as Device[]);
  }
}
