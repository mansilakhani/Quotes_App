import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'database_helper.dart';

class APIHelper {
  APIHelper._();
  static final APIHelper apiHelper = APIHelper._();

  String baseURL = "https://api.quotable.io/";
  String endPoint = "search/quotes?query=";

  Future<List<Quote>?> getQuotesList() async {
    Uri api = Uri.parse(baseURL + endPoint + query);
    http.Response response = await http.get(api);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = await jsonDecode(response.body);
      List<dynamic> allQuotesList = data['results'];
      return allQuotesList.map((e) => Quote.fromJson(e)).toList();
    }
    return null;
  }
}
