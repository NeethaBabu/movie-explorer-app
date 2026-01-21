abstract class MovieEvent {}

class FetchMovies extends MovieEvent {
  final String query;
  final int page;
  FetchMovies(this.query, this.page);
}

class FetchMovieDetails extends MovieEvent {
  final String imdbId;
  FetchMovieDetails(this.imdbId);
}
