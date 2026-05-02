import { FilmResume } from './film.modele';

export interface ResultatRecherche {
  Search: FilmResume[];
  totalResults: string;
  Response: string;
  Error?: string;
}
