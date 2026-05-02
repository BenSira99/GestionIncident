import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-pied-page',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './pied-page.html',
  styleUrls: ['./pied-page.css']
})
export class PiedPage {
  anneeActuelle = new Date().getFullYear();
}
