import { Component, inject, OnInit, signal, ElementRef, ViewChild, PLATFORM_ID, AfterViewInit } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { ActivatedRoute, RouterModule } from '@angular/router';
import { ServiceOmdb } from '../../services/omdb.service';
import { FilmDetails } from '../../modeles/film.modele';
import { BoutonFavori } from '../../composants/bouton-favori/bouton-favori';
import * as ColorThiefLib from 'colorthief';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';

@Component({
  selector: 'app-details',
  standalone: true,
  imports: [CommonModule, RouterModule, BoutonFavori],
  templateUrl: './details.html',
  styleUrls: ['./details.css']
})
export class Details implements OnInit, AfterViewInit {
  @ViewChild('afficheImage') afficheImage!: ElementRef<HTMLImageElement>;
  @ViewChild('arrierePlanGlow') arrierePlanGlow!: ElementRef<HTMLDivElement>;

  private readonly _route = inject(ActivatedRoute);
  private readonly _serviceOmdb = inject(ServiceOmdb);
  private readonly plateformeId = inject(PLATFORM_ID);
  private readonly _sanitizer = inject(DomSanitizer);

  // Signaux pour l'état du film
  film = signal<FilmDetails | null>(null);
  chargement = signal(true);
  erreur = signal('');
  couleurDominante = signal<string>('');
  modeCinema = signal(false);
  urlBandeAnnonce = signal<SafeResourceUrl | null>(null);

  ngOnInit(): void {
    const id = this._route.snapshot.paramMap.get('id');
    if (id) {
      this.chargerFilm(id);
    } else {
      this.erreur.set('Identifiant de film manquant.');
      this.chargement.set(false);
    }
  }

  ngAfterViewInit(): void {
    // Sera utilisé pour les animations GSAP
  }

  /**
   * Charge les détails du film depuis l'API.
   * @param idImdb L'identifiant du film.
   */
  chargerFilm(idImdb: string): void {
    this._serviceOmdb.obtenirDetailsParId(idImdb).subscribe({
      next: (donnees: FilmDetails) => {
        if (donnees.Response === 'True') {
          this.film.set(donnees);
          // Lancer les animations une fois le DOM mis à jour
          if (isPlatformBrowser(this.plateformeId)) {
            setTimeout(() => this.initialiserAnimations(), 100);
          }
        } else {
          this.erreur.set(donnees.Error || 'Impossible de charger les détails.');
        }
        this.chargement.set(false);
      },
      error: () => {
        this.erreur.set('Erreur de communication avec le serveur.');
        this.chargement.set(false);
      }
    });
  }

  /**
   * Configure et lance les animations GSAP pour la page.
   */
  private initialiserAnimations(): void {
    // Animation d'entrée de la section héro
    gsap.from('.affiche-principale', {
      y: 50,
      opacity: 0,
      duration: 1,
      ease: 'power3.out'
    });

    gsap.from('.textes-hero > *', {
      y: 30,
      opacity: 0,
      duration: 0.8,
      stagger: 0.1,
      ease: 'power2.out',
      delay: 0.2
    });

    // Parallax et Reveal sur le scroll
    gsap.utils.toArray('.carte-info').forEach((carte: any) => {
      gsap.from(carte, {
        scrollTrigger: {
          trigger: carte,
          start: 'top 85%',
          toggleActions: 'play none none reverse'
        },
        y: 40,
        opacity: 0,
        duration: 0.8,
        ease: 'power2.out'
      });
    });
  }

  /**
   * Retourne une image d'affiche valide.
   */
  obtenirAffiche(): string {
    const f = this.film();
    return f && f.Poster !== 'N/A' ? f.Poster : 'https://via.placeholder.com/600x900';
  }

  /**
   * Extrait la couleur dominante de l'affiche chargée.
   */
  surImageChargee(): void {
    if (isPlatformBrowser(this.plateformeId) && this.afficheImage && this.arrierePlanGlow) {
      try {
        const ClasseColorThief = (ColorThiefLib as any).default || ColorThiefLib;
        const voleurCouleur = new ClasseColorThief();
        const img = this.afficheImage.nativeElement;
        
        // S'assurer que l'image est prête pour le canvas (problèmes CORS possibles avec OMDB)
        if (img.complete) {
          const couleur = voleurCouleur.getColor(img);
          if (couleur) {
            const couleurRgb = `rgb(${couleur[0]}, ${couleur[1]}, ${couleur[2]})`;
            this.couleurDominante.set(couleurRgb);
            this.arrierePlanGlow.nativeElement.style.setProperty('--couleur-film', couleurRgb);
          }
        }
      } catch (err) {
        console.warn('Impossible d\'extraire la couleur (CORS probable) :', err);
      }
    }
  }

  basculerModeCinema(): void {
    const active = !this.modeCinema();
    this.modeCinema.set(active);
    if (active) {
      // Mock d'un trailer via la chaine FilmsActu
      const videoId = 'K-5EdHZ0hBs'; // ID YouTube d'une bande annonce
      const urlEmbed = `https://www.youtube.com/embed/${videoId}?autoplay=1&mute=0&rel=0`;
      this.urlBandeAnnonce.set(this._sanitizer.bypassSecurityTrustResourceUrl(urlEmbed));
    } else {
      this.urlBandeAnnonce.set(null);
    }
  }

  /**
   * Ouvre la recherche de la bande annonce Films Actu dans un nouvel onglet.
   */
  redirigerVersYouTube(): void {
    const f = this.film();
    if (f) {
      const query = encodeURIComponent(`FilmsActu ${f.Title} bande annonce`);
      window.open(`https://www.youtube.com/results?search_query=${query}`, '_blank');
    }
  }
}
