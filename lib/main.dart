import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(LaundryApp());
}

class LaundryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: LaundryHomePage(),
    );
  }
}

class LaundryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hilangkan app bar
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Menggunakan Container untuk latar belakang dengan bayangan
            Container(
              width: 200.0,
              height: 200.0,
              child: Image.asset(
                'Images/logo.png',
                width: 100.0,
                height: 100.0,
              ),
            ),
            Text(
              'Laundry Modern Untuk Hidup Urban Anda',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                    255, 221, 121, 252), // Ubah warna teks menjadi ungu
              ),
            ),
            SizedBox(height: 30.0),
            // Menggunakan Card untuk tombol dengan bayangan
            Card(
              elevation: 5, // Tinggi efek bayangan tombol
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(
                      255, 176, 62, 217), // Warna latar belakang tombol
                  onPrimary: Colors.white, // Warna teks pada tombol
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 14), // Padding tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Mulai',
                  style: TextStyle(fontSize: 18), // Ukuran teks tombol
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
