import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FilmResume } from '../../modeles/film.modele';
import { BoutonFavori } from '../bouton-favori/bouton-favori';

@Component({
  selector: 'app-carte-film',
  standalone: true,
  imports: [CommonModule, RouterModule, BoutonFavori],
  templateUrl: './carte-film.html',
  styleUrls: ['./carte-film.css']
})
export class CarteFilm {
  @Input({ required: true }) film!: FilmResume;

  /**
   * Retourne l'URL de l'affiche ou une image par défaut si non disponible.
   */
  obtenirAffiche(): string {
    return this.film.Poster !== 'N/A' 
      ? this.film.Poster 
      : 'https://via.placeholder.com/300x450?text=Affiche+Non+Disponible';
  }
}
