import 'package:http/http.dart';

import 'APIConstants.dart';

enum TYPE { get, post }

class Networking {
  Networking._internal();

  Networking._privateConstructor();

  static final Networking _instance = Networking._privateConstructor();

  static Networking get instance {
    return _instance;
  }

  Future<String> sendRequest(String apiPath, Map<String, String> params,
      {TYPE type = TYPE.get}) async {
    var requestUri = Uri.https(APIConstants.API_BASE_URL, apiPath, params);
    print(requestUri.toString());
    final response = await get(requestUri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO handle errors here
      return "";
    }
  }
}
