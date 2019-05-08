import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'search_dropdown.dart';

class DropdownService {
  static final _headers = {'Content-Type': 'application/json'};
  static const api_url = 'http://13.211.182.249:8888/rgevents'; // URL to web API
  final Client _http;

  DropdownService(this._http);

  Future<List<Language>> getAll() async {
    try {
      final response = await _http.get(api_url);
      final data = (_extractData(response) as List)
          .map((value) => Language.fromJson(value))
          .toList();
      print(data);
      return data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) => json.decode(resp.body);

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}