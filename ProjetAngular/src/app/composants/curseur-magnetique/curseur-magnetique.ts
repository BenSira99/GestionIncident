import { Component, ElementRef, HostListener, OnInit, ViewChild, PLATFORM_ID, inject, OnDestroy } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import gsap from 'gsap';

@Component({
  selector: 'app-curseur-magnetique',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './curseur-magnetique.html',
  styleUrl: './curseur-magnetique.css'
})
export class CurseurMagnetique implements OnInit, OnDestroy {
  @ViewChild('curseurExt', { static: true }) curseurExt!: ElementRef<HTMLDivElement>;
  @ViewChild('curseurInt', { static: true }) curseurInt!: ElementRef<HTMLDivElement>;

  private plateformeId = inject(PLATFORM_ID);
  
  public estActif = false;
  public texteCurseur = '';

  private elementsInteractifs = 'a, button, input, .carte-film-contenu, .bouton-favori-container, .lien-film';
  private coordonneesSouris = { x: 0, y: 0 };
  private evenementSurvolLie: (e: Event) => void;
  private evenementSortieLie: (e: Event) => void;

  constructor() {
    this.evenementSurvolLie = this.surSurvolElement.bind(this);
    this.evenementSortieLie = this.surSortieElement.bind(this);
  }

  ngOnInit(): void {
    if (isPlatformBrowser(this.plateformeId)) {
      // Configuration initiale GSAP
      gsap.set(this.curseurExt.nativeElement, { xPercent: -50, yPercent: -50 });
      gsap.set(this.curseurInt.nativeElement, { xPercent: -50, yPercent: -50 });

      this.attacherEcouteursInteractifs();
      
      // Observer le DOM pour attacher les écouteurs aux nouveaux éléments (comme les cartes chargées asynchrone)
      const observateur = new MutationObserver(() => {
        this.attacherEcouteursInteractifs();
      });
      observateur.observe(document.body, { childList: true, subtree: true });
    }
  }

  ngOnDestroy(): void {
    if (isPlatformBrowser(this.plateformeId)) {
      const elements = document.querySelectorAll(this.elementsInteractifs);
      elements.forEach(el => {
        el.removeEventListener('mouseenter', this.evenementSurvolLie);
        el.removeEventListener('mouseleave', this.evenementSortieLie);
      });
    }
  }

  @HostListener('window:mousemove', ['$event'])
  surMouvementSouris(e: MouseEvent): void {
    if (!isPlatformBrowser(this.plateformeId)) return;

    this.coordonneesSouris.x = e.clientX;
    this.coordonneesSouris.y = e.clientY;

    // Animation du curseur intérieur (instantanée)
    gsap.to(this.curseurInt.nativeElement, {
      x: this.coordonneesSouris.x,
      y: this.coordonneesSouris.y,
      duration: 0.1,
      ease: 'power2.out'
    });

    // Animation du curseur extérieur (légèrement retardée pour l'effet élastique)
    gsap.to(this.curseurExt.nativeElement, {
      x: this.coordonneesSouris.x,
      y: this.coordonneesSouris.y,
      duration: 0.5,
      ease: 'power3.out'
    });
  }

  private attacherEcouteursInteractifs(): void {
    const elements = document.querySelectorAll(this.elementsInteractifs);
    elements.forEach(el => {
      // Éviter d'attacher plusieurs fois
      el.removeEventListener('mouseenter', this.evenementSurvolLie);
      el.removeEventListener('mouseleave', this.evenementSortieLie);
      
      el.addEventListener('mouseenter', this.evenementSurvolLie);
      el.addEventListener('mouseleave', this.evenementSortieLie);
    });
  }

  private surSurvolElement(e: Event): void {
    this.estActif = true;
    const cible = e.currentTarget as HTMLElement;
    
    // Déterminer le texte optionnel basé sur les attributs de données ou les classes
    if (cible.classList.contains('carte-film-contenu') || cible.classList.contains('lien-film')) {
      this.texteCurseur = 'VOIR';
    } else {
      this.texteCurseur = '';
    }

    // Animation d'agrandissement et effet magnétique du curseur
    gsap.to(this.curseurExt.nativeElement, {
      scale: 1.5,
      backgroundColor: 'rgba(59, 191, 250, 0.1)',
      borderColor: 'rgba(59, 191, 250, 0.8)',
      duration: 0.3
    });
    
    gsap.to(this.curseurInt.nativeElement, {
      scale: 0,
      opacity: 0,
      duration: 0.2
    });
  }

  private surSortieElement(): void {
    this.estActif = false;
    this.texteCurseur = '';

    // Retour à l'état normal
    gsap.to(this.curseurExt.nativeElement, {
      scale: 1,
      backgroundColor: 'transparent',
      borderColor: 'rgba(255, 255, 255, 0.3)',
      duration: 0.3
    });
    
    gsap.to(this.curseurInt.nativeElement, {
      scale: 1,
      opacity: 1,
      duration: 0.2
    });
  }
}
