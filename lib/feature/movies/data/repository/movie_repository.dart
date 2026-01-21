import '../datasource/movie_remote_datasource.dart';
import '../model/movie_model.dart';

class MovieRepository {
  final MovieRemoteDataSource datasource;

  MovieRepository(this.datasource);

  Future<List<MovieModel>> getMovies(String query, int page) async {
    final data = await datasource.fetchMovies(query, page);
    return (data["Search"] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>> getMovieDetails(String imdbId) {
    return datasource.fetchMovieDetails(imdbId);
  }
}
