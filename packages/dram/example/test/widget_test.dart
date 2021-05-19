import 'package:example/business/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

void main() {
  test("Movie", () {
    var movies = json.decode("""
    {
      "Title":"First Love, Last Rites",
      "US Gross":10876,
      "Worldwide Gross":10876,
      "US DVD Sales":null,
      "Production Budget":300000,
      "Release Date":"Feb 07 1998",
      "MPAA Rating":"R",
      "Running Time min":null,
      "Distributor":"Strand",
      "Source":null,
      "Major Genre":"Drama",
      "Creative Type":null,
      "Director":null,
      "Rotten Tomatoes Rating":null,
      "IMDB Rating":6.9,
      "IMDB Votes":207
    }
    """);

    Movie movie = Movie.fromJson(movies);
    
    expect(DateFormat.yMMMd("en_US").format(movie.releaseDate), "Feb 7, 1998");
  });
}
