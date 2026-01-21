import '../../../../core/network/dio.dart';

class MovieRemoteDataSource {
  Future<Map<String, dynamic>> fetchMovies(String query, int page) async {
    final response = await DioClient.dio.get(
      "",
      queryParameters: {
        "s": query,
        "page": page,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> fetchMovieDetails(String imdbId) async {
    final response = await DioClient.dio.get(
      "",
      queryParameters: {
        "i": imdbId,
        "plot": "full",
      },
    );
    return response.data;
  }
}
