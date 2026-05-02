import { Injectable, signal, computed } from '@angular/core';
import { FilmResume } from '../modeles/film.modele';

@Injectable({
  providedIn: 'root'
})
export class ServiceFavoris {
  private readonly CLE_STOCKAGE = 'cinebensira_favoris';
  
  // Utilisation des signaux pour la réactivité (Angular 17+)
  private favorisSignal = signal<FilmResume[]>(this.chargerFavoris());
  
  // Signal dérivé exposé aux composants (lecture seule)
  public lesFavoris = this.favorisSignal.asReadonly();
  
  // Fonction retournant un signal dérivé pour vérifier si un film est favori
  public estFavori = (id: string) => computed(() => this.favorisSignal().some(f => f.imdbID === id));

  constructor() { }

  private chargerFavoris(): FilmResume[] {
    try {
      const donnees = localStorage.getItem(this.CLE_STOCKAGE);
      return donnees ? JSON.parse(donnees) : [];
    } catch (e) {
      console.error('Erreur lors du chargement des favoris', e);
      return [];
    }
  }

  private sauvegarderFavoris(favoris: FilmResume[]): void {
    try {
      localStorage.setItem(this.CLE_STOCKAGE, JSON.stringify(favoris));
      this.favorisSignal.set(favoris); // Notifie l'UI des changements
    } catch (e) {
      console.error('Erreur lors de la sauvegarde des favoris', e);
    }
  }

  public basculerFavori(film: FilmResume): void {
    const favorisActuels = this.favorisSignal();
    const index = favorisActuels.findIndex(f => f.imdbID === film.imdbID);
    
    // Créer une nouvelle copie du tableau pour assurer l'immuabilité
    let nouveauxFavoris = [...favorisActuels];
    
    if (index === -1) {
      nouveauxFavoris.push(film);
    } else {
      nouveauxFavoris.splice(index, 1);
    }
    
    this.sauvegarderFavoris(nouveauxFavoris);
  }
}
