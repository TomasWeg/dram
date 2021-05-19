import 'package:dram/app.dart';
import 'package:example/business/movie_mock.dart';

import 'movie.dart';

class MovieWorker extends BaseWorker<Movie> {

  MovieWorker() : super(executeAfter: const Duration(minutes: 15));

  @override
  Future<Map<String, Movie>> fetch() {
    return Future.value({});  
  }
}

abstract class BaseMoviesService extends DomainService<Movie> {
  BaseMoviesService({required DomainServiceSource<Movie> serviceSource}) : super(serviceSource: serviceSource);

  BaseWorker? get worker => MovieWorker();

  Future<Movie?> find(String id);
  Future<List<Movie>> findAll({String? title, String? distributor, DateTime? releasedBefore});
  Future<bool> create(Movie movie);
  Future<bool> delete(String movieId);
  Future<bool> edit(String movieId, {String? newTitle});
}

class MockMoviesService extends BaseMoviesService {
  MockMoviesService() : super(serviceSource: MultiServiceSource(
    sources: [
      MockServiceSource(entries: Map.fromIterable(MovieMock().getMock(), key: (k) => k.id, value: (v) => v))
    ]
  ));

  @override
  Future<bool> create(Movie movie) async {
    ApiResponse response = await http.sendPost("", body: movie.toJson());

    if(response.isFailed) {
      return false;
    }

    movie = response.data as Movie;
    await source.push(movie.id, movie);

    return true;
  }

  @override
  Future<bool> delete(String movieId) async {
    ApiResponse response = await http.sendDelete(movieId);
    if(response.isFailed) {
      return false;
    }

    await source.delete(movieId);

    return true;
  }

  @override
  Future<bool> edit(String movieId, {String? newTitle}) async {
    Movie? movie = await source.find(movieId);
    if(movie == null) {
      return false;
    }
    
    ApiResponse response = await http.sendPatch(movieId, body: {
      "title": newTitle
    });

    if(response.isFailed) {
      return false;
    }

    movie = movie.copyWith(title: newTitle);
    await source.push(movieId, movie);

    return true;
  }

  @override
  Future<Movie?> find(String id) {
    return source.find(id);
  }

  @override
  Future<List<Movie>> findAll({String? title, String? distributor, DateTime? releasedBefore}) {
    return source.findMany(
      notBefore: releasedBefore,
      params: {
        "title": title,
        "distributor": distributor
      }
    );
  }
}

class MoviesService extends BaseMoviesService {
  MoviesService() : super(serviceSource: MultiServiceSource(
    sources: [
      MemoryServiceSource(
        interpreter: MemorySourceInterpreter.forType<Movie>((entries, parameters, notBefore) {
          var result = entries.values;
          if(parameters != null) {
            String? title = parameters["title"];
            String? genre = parameters["genre"];
            if(title != null) {
              result = result.where((element) => element.title.toLowerCase() == title);
            }

            if(genre != null) {
              result = result.where((element) => element.genre.toLowerCase() == genre);
            }
          }

          if(notBefore != null) {
            result = result.where((element) => element.releaseDate.isAfter(notBefore));
          }

          return result;         
        })
      ),
      SqliteServiceSource(),
      HttpServiceSource(resource: "v1/movies")
    ]
  ));

  @override
  Future<bool> create(Movie movie) async {
    ApiResponse response = await http.sendPost("", body: movie.toJson());

    if(response.isFailed) {
      return false;
    }

    movie = response.data as Movie;
    await source.push(movie.id, movie);

    return true;
  }

  @override
  Future<bool> delete(String movieId) async {
    ApiResponse response = await http.sendDelete(movieId);
    if(response.isFailed) {
      return false;
    }

    await source.delete(movieId);

    return true;
  }

  @override
  Future<bool> edit(String movieId, {String? newTitle}) async {
    Movie? movie = await source.find(movieId);
    if(movie == null) {
      return false;
    }
    
    ApiResponse response = await http.sendPatch(movieId, body: {
      "title": newTitle
    });

    if(response.isFailed) {
      return false;
    }

    movie = movie.copyWith(title: newTitle);
    await source.push(movieId, movie);

    return true;
  }

  @override
  Future<Movie?> find(String id) {
    return source.find(id);
  }

  @override
  Future<List<Movie>> findAll({String? title, String? distributor, DateTime? releasedBefore}) {
    return source.findMany(
      notBefore: releasedBefore,
      params: {
        "title": title,
        "distributor": distributor
      }
    );
  }
}