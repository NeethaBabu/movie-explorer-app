abstract class MovieEvent {}

class FetchMovies extends MovieEvent {
  final String query;
  final int page;
  final bool loadMore;

  FetchMovies(this.query, this.page, {this.loadMore = false});

}
class FetchMovieDetails extends MovieEvent {
  final String imdbId;
  FetchMovieDetails(this.imdbId);
}