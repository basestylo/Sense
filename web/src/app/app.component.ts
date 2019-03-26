import { Component, NgModule, VERSION } from '@angular/core';

@Component({
    selector: 'app-sense-app',
    templateUrl:  './app.component.html',
    styleUrls: ['./app.component.css']
})

export class AppComponent {
  title: string;
  version: string;

  constructor() {
    this.title = 'Sense';
    this.version = VERSION.full
  }
}
