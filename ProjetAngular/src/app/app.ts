import { Component, signal, OnInit, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { Entete } from './composants/entete/entete';
import { PiedPage } from './composants/pied-page/pied-page';
import { ServiceDefilement } from './services/defilement.service';
import { CurseurMagnetique } from './composants/curseur-magnetique/curseur-magnetique';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, Entete, PiedPage, CurseurMagnetique],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App implements OnInit {
  protected readonly titre = signal('CineBenSira');
  private serviceDefilement = inject(ServiceDefilement);

  ngOnInit(): void {
    this.serviceDefilement.initialiser();
  }
}
