import { Routes } from '@angular/router';
import { Recherche } from './pages/recherche/recherche';
import { Details } from './pages/details/details';
import { Favoris } from './pages/favoris/favoris';

export const routes: Routes = [
  { path: 'recherche', component: Recherche },
  { path: 'details/:id', component: Details },
  { path: 'favoris', component: Favoris },
  { path: '', redirectTo: 'recherche', pathMatch: 'full' },
  { path: '**', redirectTo: 'recherche' }
];

