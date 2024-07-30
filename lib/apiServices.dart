import 'dart:convert';

import 'package:flutter_assigment/model.dart';
import 'package:http/http.dart' as http;

//I have Using the API Url to get the dummy data from DummyJson.
class ApiServices {
  String baseUrl = 'https://dummyjson.com';
  Future<List<User>> fetchUserData() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    try {
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['users'];
        List<User> userData = data.map((item) => User.fromJson(item)).toList();
        return userData;
      } else {
        throw Exception('Data Not getting fetched');
      }
    } catch (e) {
      throw Exception('Something not right $e');
    }
  }
}
