import { Injectable }    from '@angular/core';
import { Headers, Http } from '@angular/http';
import { environment }   from '../environments/environment';

import 'rxjs/add/operator/toPromise';

import { Actuator } from './actuator';

@Injectable()
export class ActuatorService {

  private headers = new Headers({'Content-Type': 'application/json'});
  private devicesUrl = environment.apiUrl + '/api/v1/devices';

  constructor(private http: Http) { }

  getActuators(device_id: number): Promise<Actuator[]> {
    return this.http.get(`${this.devicesUrl}/${device_id}/actuators`)
               .toPromise()
               .then(response => response.json().data as Actuator[])
               .catch(this.handleError);
  }


  getActuator(device_id: number, id: number): Promise<Actuator> {
    const url = `${this.devicesUrl}/${device_id}/actuators/${id}`;
    return this.http.get(url)
      .toPromise()
      .then(response => response.json().data as Actuator)
      .catch(this.handleError);
  }

  delete(id: number): Promise<void> {
    const url = `${this.devicesUrl}/${id}`;
    return this.http.delete(url, {headers: this.headers})
      .toPromise()
      .then(() => null)
      .catch(this.handleError);
  }

  create(actuator: Actuator): Promise<Actuator> {
    actuator.value = +actuator.value
    return this.http
      .post( `${this.devicesUrl}/${actuator.device_id}/actuators`, JSON.stringify({actuator: actuator}), {headers: this.headers})
      .toPromise()
      .then(res => res.json().data as Actuator)
      .catch(this.handleError);
  }

  update(actuator: Actuator): Promise<Actuator> {
    actuator.value = +actuator.value
    var body:any={actuator: actuator};
    const url =  `${this.devicesUrl}/${actuator.device_id}/actuators/${actuator.id}`;
    return this.http
      .put(url, JSON.stringify(body), {headers: this.headers})
      .toPromise()
      .then(() => actuator)
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error); // for demo purposes only
    return Promise.reject(error.message || error);
  }
}
