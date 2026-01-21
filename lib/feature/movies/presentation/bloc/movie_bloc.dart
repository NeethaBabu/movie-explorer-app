import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc(this.repository) : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await repository.getMovies(event.query, event.page);
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });

    on<FetchMovieDetails>((event, emit) async {
      emit(MovieLoading());
      final details = await repository.getMovieDetails(event.imdbId);
      emit(MovieDetailsLoaded(details));
    });
  }
}
