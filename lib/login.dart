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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.email),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorText: _formKey.currentState?.validate() == true &&
                            emailController.text.isEmpty
                        ? 'Mohon isi datanya'
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon isi datanya';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.lock),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorText: _formKey.currentState?.validate() == true &&
                            passwordController.text.isEmpty
                        ? 'Mohon isi datanya'
                        : null,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon isi datanya';
                    }
                    return null;
                  },
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
                    if (_formKey.currentState!.validate()) {
                      loginUser(context);
                    }
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

        // Check if the response contains an 'errors' key
        if (responseData.containsKey('errors')) {
          Map<String, dynamic> errors = responseData['errors'];
          errors.forEach((key, value) {
            // Highlight the input fields with red color
            switch (key) {
              case 'email':
                emailController.clear();
                break;
              case 'password':
                passwordController.clear();
                break;
              // Add more cases for other fields if needed
            }

            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$key: $value'),
                duration: Duration(seconds: 3),
              ),
            );
          });

          // Show error popup only for invalid login data
          if (errors.keys.contains('email') ||
              errors.keys.contains('password')) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Failed'),
                  content: Text('Invalid email or password. Please try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else if (responseData.containsKey('user')) {
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
      content: Text('Login Gagal: Mohon cek datanya kembali '),
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

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

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
