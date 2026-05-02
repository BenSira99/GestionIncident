import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ServiceFavoris } from '../../services/favoris.service';
import { CarteFilm } from '../../composants/carte-film/carte-film';

@Component({
  selector: 'app-favoris',
  standalone: true,
  imports: [CommonModule, RouterModule, CarteFilm],
  templateUrl: './favoris.html',
  styleUrls: ['./favoris.css']
})
export class Favoris {
  public readonly serviceFavoris = inject(ServiceFavoris);
}
