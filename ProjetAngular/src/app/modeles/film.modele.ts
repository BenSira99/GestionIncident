export interface Evaluation {
  Source: string;
  Value: string;
}

export interface FilmDetails {
  Title: string;
  Year: string;
  Rated: string;
  Released: string;
  Runtime: string;
  Genre: string;
  Director: string;
  Writer: string;
  Actors: string;
  Plot: string;
  Language: string;
  Country: string;
  Awards: string;
  Poster: string;
  Ratings: Evaluation[];
  Metascore: string;
  imdbRating: string;
  imdbVotes: string;
  imdbID: string;
  Type: string;
  DVD: string;
  BoxOffice: string;
  Production: string;
  Website: string;
  Response: string;
  Error?: string;
}

export interface FilmResume {
  Title: string;
  Year: string;
  imdbID: string;
  Type: string;
  Poster: string;
  Response?: string;
  Error?: string;
}
