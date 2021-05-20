import 'package:dram/app.dart';

class Movie {
  
  final String id;
  final String title;
  final String genre;
  final String distributor;
  final DateTime releaseDate;

  Movie({required this.title, required this.genre, required this.distributor, required this.releaseDate, required this.id});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"],
      genre: json["genre"],
      distributor: json["distributor"],
      releaseDate: DateTime.parse(json["release_date"]),
      id: json["id"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "distributor": distributor,
      "genre": genre,
      "release_date": releaseDate.toIso8601String()
    };
  }

  Movie copyWith({String? title}) {
    return Movie(
      id: this.id,
      title: title ?? this.title,
      distributor: this.distributor,
      genre: this.genre,
      releaseDate: this.releaseDate
    );
  }
}

class MovieAdapters extends ModelAdapterBuilder<Movie> {

  @override
  Map<Type, ModelAdapter<Movie>> get adapters => {
    HttpServiceSource: ModelAdapter(
      fromProvider: (source) => Movie.fromJson(source),
      toProvider: (movie) => movie.toJson(),
    ),
    SqliteServiceSource: ModelAdapter(
      fromProvider: (source) {
        return Movie(
          id: source["id"],
          title: source["title"],
          distributor: source["distributor"],
          genre: source["genre"],
          releaseDate: DateTime.fromMillisecondsSinceEpoch(source["release_date"]),  
        );
      },
      toProvider: (movie) => {
        "title": movie.title,
        "distributor": movie.distributor,
        "genre": movie.genre,
        "release_date": movie.releaseDate.millisecondsSinceEpoch
      },
    )
  };
  

}