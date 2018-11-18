import { NgModule } from '@angular/core';

import {
  MatButtonModule,
  MatMenuModule,
  MatToolbarModule,
  MatIconModule,
  MatCardModule,
  MatInputModule,
  MatListModule,
  MatSnackBarModule,
  MatTableModule,
  MatTabsModule,
  MatSelectModule,
  MatSlideToggleModule,
  MatSliderModule
} from '@angular/material';

@NgModule({
  imports: [
    MatButtonModule,
    MatMenuModule,
    MatToolbarModule,
    MatIconModule,
    MatCardModule,
    MatInputModule,
    MatListModule,
    MatSnackBarModule,
    MatTableModule,
    MatTabsModule,
    MatSelectModule,
    MatSlideToggleModule,
    MatSliderModule
  ],
  exports: [
    MatButtonModule,
    MatMenuModule,
    MatToolbarModule,
    MatIconModule,
    MatCardModule,
    MatInputModule,
    MatListModule,
    MatSnackBarModule,
    MatTableModule,
    MatTabsModule,
    MatSelectModule,
    MatSlideToggleModule,
    MatSliderModule
  ]
})
export class MaterialModule {}
