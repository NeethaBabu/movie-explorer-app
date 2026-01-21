class MovieModel {
  final String imdbID;
  final String title;
  final String year;
  final String poster;

  MovieModel({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbID: json["imdbID"],
      title: json["Title"],
      year: json["Year"],
      poster: json["Poster"],
    );
  }
}
