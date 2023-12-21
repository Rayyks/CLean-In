import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'registrasi.dart';
import 'dashboard.dart';

void main() {
  runApp(LaundryApp());
}

class LaundryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'Images/logo.png',
                width: 100.0,
                height: 100.0,
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Masukkan akun anda',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Lupa Password?'),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  loginUser(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Masuk',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()),
                      );
                    },
                    child: Text('Daftar Akun'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginUser(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login'),
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      // Check the content type of the response
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        // If the response is in JSON format, decode the body
        final responseData = json.decode(response.body);
        // print(
        //     'Response status: ${response.statusCode}'); // Access response here if it's not null
        // print('Response body: ${response.body}');

        // Check if the response contains a 'user' key
        if (responseData.containsKey('user')) {
          User user = User.fromJson(responseData['user']);
          showLoginSuccessNotification(context);

          // Store user data securely
          final storage = FlutterSecureStorage();
          await storage.write(key: 'userId', value: user.id.toString());
          await storage.write(key: 'userName', value: user.name);
          await storage.write(key: 'userEmail', value: user.email);
          await storage.write(key: 'userPhone', value: user.phone);
          await storage.write(key: 'userAddress', value: user.address);
          await storage.write(key: 'accessToken', value: responseData['token']);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else {
          showLoginErrorNotification(context, 'Invalid response format');
        }
      } else {
        showLoginErrorNotification(context, 'Invalid content type');
      }
    } catch (error) {
      showLoginErrorNotification(context, 'Login failed: $error');
      print('Error: $error');
    }
  }
}

void showLoginSuccessNotification(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Berhasil Masuk!'),
      duration: Duration(seconds: 3),
    ),
  );
}

void showLoginErrorNotification(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Login failed: $errorMessage'),
      duration: Duration(seconds: 3),
    ),
  );
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  User(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }
}
