abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List movies;
  final bool hasMore;
  final bool isLoadingMore;
  MovieLoaded(
      this.movies, {
        this.hasMore = true,
        this.isLoadingMore = false,
      });
}


class MovieDetailsLoaded extends MovieState {
  final Map<String, dynamic> details;
  MovieDetailsLoaded(this.details);
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}
