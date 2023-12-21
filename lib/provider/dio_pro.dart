import 'dart:convert';
import 'package:dio/dio.dart';

class ApiProvider {
  final String baseUrl;

  ApiProvider(this.baseUrl);

  Future<bool> register(String username, String email, String address,
      String phone, String password) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        'http://127.0.0.1:8000/api/register',
        data: jsonEncode({
          'username': username,
          'email': email,
          'address': address,
          'phone': phone,
          'password': password,
        }),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to register. Server responded with status code ${response.statusCode}');
        print('Response body: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        'http://127.0.0.1:8000/api/login',
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to login. Server responded with status code ${response.statusCode}');
        print('Response body: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }
}
