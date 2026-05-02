import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { ResultatRecherche } from '../modeles/resultat-recherche.modele';
import { FilmDetails } from '../modeles/film.modele';

@Injectable({
  providedIn: 'root'
})
export class ServiceOmdb {
  // Dépendances injectées (nouvelle syntaxe Angular 17/18)
  private readonly _http = inject(HttpClient);
  
  // Clé API OMDB
  private readonly _cleApi = '4116a82a';
  private readonly _urlBase = 'https://www.omdbapi.com/';

  /**
   * Recherche des films par titre.
   * @param titre Le titre du film recherché.
   * @param page Le numéro de page (10 résultats par défaut).
   */
  rechercherFilms(titre: string, page: number = 1): Observable<ResultatRecherche> {
    return this._http.get<ResultatRecherche>(`${this._urlBase}?s=${titre}&page=${page}&apikey=${this._cleApi}`);
  }

  /**
   * Obtient les détails complets d'un film par son ID IMDb.
   * @param idImdb L'identifiant unique du film.
   */
  obtenirDetailsParId(idImdb: string): Observable<FilmDetails> {
    return this._http.get<FilmDetails>(`${this._urlBase}?i=${idImdb}&plot=full&apikey=${this._cleApi}`);
  }
}
