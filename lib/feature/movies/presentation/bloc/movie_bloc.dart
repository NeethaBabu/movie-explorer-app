import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;
  int page = 1;
  List allMovies = [];
  bool hasMore = true;

  MovieBloc(this.repository) : super(MovieInitial()) {
    // on<FetchMovies>((event, emit) async {
    //   try {
    //     if (!event.loadMore) {
    //       emit(MovieLoading());
    //       allMovies.clear();
    //       hasMore = true;
    //     }
    //
    //     if (!hasMore) return;
    //
    //     final movies = await repository.getMovies(event.query, event.page);
    //
    //     if (movies.length < 10) {
    //       hasMore = false;
    //     }
    //
    //     allMovies.addAll(movies);
    //     emit(MovieLoaded(List.from(allMovies), hasMore: hasMore));
    //   } catch (e) {
    //     emit(MovieError(e.toString()));
    //   }
    // });
    on<FetchMovies>((event, emit) async {
      try {
        // first load or new search
        if (!event.loadMore) {
          emit(MovieLoading());
          page = event.page;
          allMovies.clear();
          hasMore = true;
        } else {
          emit(MovieLoaded(
            allMovies,
            hasMore: hasMore,
            isLoadingMore: true,
          ));
        }

        if (!hasMore) return;

        final movies = await repository.getMovies(event.query, page);

        if (movies.length < 10) {
          hasMore = false;
        }

        allMovies.addAll(movies);

        emit(MovieLoaded(
          List.from(allMovies),
          hasMore: hasMore,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });

    on<FetchMovieDetails>((event, emit) async {
      emit(MovieLoading());
      try {
        final details = await repository.getMovieDetails(event.imdbId);
        emit(MovieDetailsLoaded(details));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}
