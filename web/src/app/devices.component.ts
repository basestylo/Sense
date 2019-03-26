import { Component} from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';

import { Device } from './device';
import { DeviceService } from './device.service';

@Component({
  selector: 'app-my-devices',
  templateUrl: './devices.component.html',
  styleUrls: [ './devices.component.css' ]
})

export class DevicesComponent {
  device: Device;

  constructor(
    private deviceService: DeviceService,
    private location: Location
  ) { }

  add(name: string, description: string): void {
    name = name.trim();
    description = description.trim();
    if (!name || !description) { return; }
    const new_device: Device = {id: 0, name: name, description: description, user_id: 1};

     this.deviceService.create(new_device)
      .then( () => this.goBack());
  }

  goBack(): void {
    this.location.back();
  }
}
