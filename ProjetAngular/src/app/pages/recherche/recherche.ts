import { Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ServiceOmdb } from '../../services/omdb.service';
import { FilmResume } from '../../modeles/film.modele';
import { ResultatRecherche } from '../../modeles/resultat-recherche.modele';
import { CarteFilm } from '../../composants/carte-film/carte-film';
import { PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

@Component({
  selector: 'app-recherche',
  standalone: true,
  imports: [CommonModule, FormsModule, CarteFilm],
  templateUrl: './recherche.html',
  styleUrls: ['./recherche.css']
})
export class Recherche {
  private readonly _serviceOmdb = inject(ServiceOmdb);
  private readonly _plateformeId = inject(PLATFORM_ID);

  // Signaux pour la réactivité (Angular 17+)
  termeRecherche = signal('');
  films = signal<FilmResume[]>([]);
  chargement = signal(false);
  erreur = signal('');
  totalResultats = signal(0);
  pageActuelle = signal(1);

  /**
   * Effectue la recherche de films via le service.
   */
  lancerRecherche(): void {
    const terme = this.termeRecherche().trim();
    if (!terme) return;

    this.chargement.set(true);
    this.erreur.set('');
    
    this._serviceOmdb.rechercherFilms(terme, this.pageActuelle()).subscribe({
      next: (reponse: ResultatRecherche) => {
        if (reponse.Response === 'True') {
          this.films.set(reponse.Search);
          this.totalResultats.set(parseInt(reponse.totalResults));
          if (isPlatformBrowser(this._plateformeId)) {
            setTimeout(() => this.animerResultats(), 100);
          }
        } else {
          this.films.set([]);
          this.erreur.set(reponse.Error || 'Aucun film trouvé.');
        }
        this.chargement.set(false);
      },
      error: () => {
        this.erreur.set('Erreur lors de la communication avec l\'API.');
        this.chargement.set(false);
      }
    });
  }

  /**
   * Gère le changement de page.
   */
  changerPage(nouvellePage: number): void {
    this.pageActuelle.set(nouvellePage);
    this.lancerRecherche();
  }

  /**
   * Anime l'apparition des cartes de films via GSAP.
   */
  private animerResultats(): void {
    // Réinitialise les ScrollTriggers existants pour cette vue si besoin
    ScrollTrigger.refresh();

    gsap.utils.toArray('.carte-film-animate').forEach((carte: any, index: number) => {
      gsap.fromTo(carte, 
        { y: 50, opacity: 0 },
        {
          scrollTrigger: {
            trigger: carte,
            start: 'top 90%',
            toggleActions: 'play none none reverse'
          },
          y: 0,
          opacity: 1,
          duration: 0.6,
          ease: 'power2.out',
          delay: (index % 10) * 0.05 // Léger délai en cascade pour chaque ligne
        }
      );
    });
  }
}
