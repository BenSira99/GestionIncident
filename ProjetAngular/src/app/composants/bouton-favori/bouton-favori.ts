import { Component, Input, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ServiceFavoris } from '../../services/favoris.service';
import { FilmResume, FilmDetails } from '../../modeles/film.modele';
import { gsap } from 'gsap';

@Component({
  selector: 'app-bouton-favori',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './bouton-favori.html',
  styleUrls: ['./bouton-favori.css']
})
export class BoutonFavori {
  @Input({ required: true }) film!: FilmResume | FilmDetails;
  
  private serviceFavoris = inject(ServiceFavoris);
  
  // Calculer si le film actuel est un favori
  estActif = computed(() => {
    return this.serviceFavoris.estFavori(this.film.imdbID)();
  });

  basculer(evenement: MouseEvent, elementCoeur: HTMLElement) {
    // Empêcher la propagation pour ne pas déclencher la navigation si placé dans une carte cliquable
    evenement.stopPropagation();
    evenement.preventDefault();
    
    // Adaptation du modèle si un FilmDetails complet est passé
    const filmResume: FilmResume = {
      Title: this.film.Title,
      Year: this.film.Year,
      imdbID: this.film.imdbID,
      Type: this.film.Type,
      Poster: this.film.Poster
    };
    
    this.serviceFavoris.basculerFavori(filmResume);
    
    // Animation GSAP (Awwwards Level Experience)
    if (this.estActif()) {
      // Animation d'ajout : explosion et rebond (Heartburst)
      gsap.fromTo(elementCoeur, 
        { scale: 0.5, rotation: -20 },
        { scale: 1.3, rotation: 0, duration: 0.5, ease: 'elastic.out(1.2, 0.5)' }
      );
      gsap.to(elementCoeur, { scale: 1, duration: 0.2, delay: 0.5 });
    } else {
      // Animation de retrait douce
      gsap.fromTo(elementCoeur,
        { scale: 1.2 },
        { scale: 1, duration: 0.3, ease: 'power2.out' }
      );
    }
  }
}
