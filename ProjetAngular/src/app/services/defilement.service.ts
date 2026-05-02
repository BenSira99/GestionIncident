import { Injectable, OnDestroy, PLATFORM_ID, inject } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import Lenis from '@studio-freight/lenis';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

@Injectable({
  providedIn: 'root'
})
export class ServiceDefilement implements OnDestroy {
  private lenis: Lenis | null = null;
  private animationFrameId: number | null = null;
  private plateformeId = inject(PLATFORM_ID);

  constructor() {}

  /**
   * Initialise le défilement fluide (Smooth Scroll) globalement.
   */
  public initialiser(): void {
    if (isPlatformBrowser(this.plateformeId) && !this.lenis) {
      this.lenis = new Lenis({
        duration: 1.2,
        easing: (t: number) => Math.min(1, 1.001 - Math.pow(2, -10 * t)), // Easing exponentiel doux
        orientation: 'vertical',
        gestureOrientation: 'vertical',
        smoothWheel: true,
        wheelMultiplier: 1,
        touchMultiplier: 2,
        infinite: false,
      });

      // Intégration de Lenis avec le ScrollTrigger de GSAP pour la synchronisation des animations
      this.lenis.on('scroll', ScrollTrigger.update);

      gsap.ticker.add((time) => {
        this.lenis?.raf(time * 1000);
      });

      gsap.ticker.lagSmoothing(0);
    }
  }

  /**
   * Arrête l'instance de Lenis pour le nettoyage.
   */
  ngOnDestroy(): void {
    if (this.lenis) {
      this.lenis.destroy();
      this.lenis = null;
      if (this.animationFrameId !== null) {
        cancelAnimationFrame(this.animationFrameId);
      }
    }
  }
}
