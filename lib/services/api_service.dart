import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  Future<dynamic> loadLocation(String latitude, String longitude) async {
    var uri = Uri.parse('https://api-bdc.net/data/reverse-geocode-client');

    final url = uri.replace(
        queryParameters: {'latitude': latitude, 'longitude': longitude});

    final res = await http.get(url);

    final  data = json.decode(res.body);

    return  (data['city'] + "," + data['principalSubdivision'] + "," + data['countryName']);
  }
}
