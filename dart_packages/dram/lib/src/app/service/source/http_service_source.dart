import 'package:dram/app.dart';
import 'package:dram/src/app/http/api_response.dart';
import 'package:dram/src/app/module/http_module.dart';
import 'package:dram/src/app/service/adapter/model_adapter_provider.dart';
import 'package:dram/src/app/service/source/domain_service_source.dart';

class HttpServiceSource<T> extends DomainServiceSource<T> {

  late HttpModule _httpModule;
  String? _resource;

  HttpServiceSource({String? resource}) {
    _resource = resource;
    
    var httpModule = ServiceProvider.instance.getService<HttpModule>();
    assert(httpModule != null, "HttpModule is not added, which is required to use HttpServiceSource.");

    _httpModule = httpModule!;
  }

  @override
  Future<T?> find(String id) async {
    ModelAdapter<T> adapter = ModelAdapterProvider().adapterFor<T, HttpServiceSource>(defaultIfNotFound: true);
    String resourceName = _resource ?? adapter.name;
    ApiResponse response = await _httpModule.sendGet("$resourceName/$id");
    if(response.isFailed) {
      return null;
    }

    return adapter.fromProvider(response.data);
  }

  @override
  Future<List<T>> findMany({Map<String, dynamic>? params, DateTime? notBefore}) async {
    ModelAdapter<T> adapter = ModelAdapterProvider().adapterFor<T, HttpServiceSource>(defaultIfNotFound: true);  
    String resourceName = _resource ?? adapter.name;
    var queryParams = params ?? {};
    if(notBefore != null)
      queryParams["not_before"] = notBefore.toIso8601String();

    ApiResponse response = await _httpModule.sendGet("$resourceName", params: params);
    if(response.isFailed) {
      return List.empty();
    }

    if(response.data is List) {
      return (response.data as List).map((e) => adapter.fromProvider(e)).toList();
    }

    return List.empty();
  }
}