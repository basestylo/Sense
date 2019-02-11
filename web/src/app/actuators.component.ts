import { Component, OnInit} from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Router } from '@angular/router';
import { Location } from '@angular/common';

import { Actuator } from './actuator';
import { ActuatorService } from './actuator.service';

@Component({
  selector: 'my-actuators',
  templateUrl: './actuators.component.html',
  styleUrls: [ './actuators.component.css' ]
})

export class ActuatorsComponent implements OnInit{
  actuator: Actuator;
  device_id: number;

  constructor(
    public route: ActivatedRoute,
    private actuatorService: ActuatorService,
    private location: Location
  ) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.device_id = +params['device_id'];
    });
  }

  add(name: string, description: string): void {
    name = name.trim();
    description = description.trim();

    if (!name || !description) { return; }
    var new_actuator: Actuator = {id: 0, name: name, description: description, device_id: this.device_id, value: 0, type: "button"};

     this.actuatorService.create(new_actuator)
      .then( () => this.goBack());
  }

  goBack(): void {
    this.location.back();
  }
}
