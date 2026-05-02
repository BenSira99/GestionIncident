import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ServiceFavoris } from '../../services/favoris.service';

@Component({
  selector: 'app-entete',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './entete.html',
  styleUrls: ['./entete.css']
})
export class Entete {
  public readonly serviceFavoris = inject(ServiceFavoris);
}

