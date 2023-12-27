import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pra_project/login.dart';
import 'history.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final storage = FlutterSecureStorage();

  String name = '';
  String phone = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the widget is initialized
  }

  Future<void> fetchUserData() async {
    try {
      // Retrieve user data from secure storage
      final userName = await storage.read(key: 'userName');
      final userPhone = await storage.read(key: 'userPhone');
      final userAddress = await storage.read(key: 'userAddress');

      setState(() {
        name = userName ?? '';
        phone = userPhone ?? '';
        address = userAddress ?? '';
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> updatePhone(String newPhone) async {
    try {
      // Retrieve the access token from secure storage
      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.put(
        Uri.parse(
            'http://127.0.0.1:8000/api/user/update'), // Change this endpoint to the actual endpoint for updating phone
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'phone': newPhone}),
      );

      if (response.statusCode == 200) {
        print('Phone updated successfully');
      } else {
        print('Failed to update phone: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating phone: $error');
    }
  }

  Future<void> updateAddress(String newAddress) async {
    try {
      // Retrieve the access token from secure storage
      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.put(
        Uri.parse(
            'http://127.0.0.1:8000/api/user/update'), // Change this endpoint to the actual endpoint for updating address
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'address': newAddress}),
      );

      if (response.statusCode == 200) {
        print('Address updated successfully');
      } else {
        print('Failed to update address: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating address: $error');
    }
  }

  void _editPhone(BuildContext context) {
    TextEditingController controller = TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit No Telepon'),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // Update phone in the database
                await updatePhone(controller.text);

                // Update the UI
                setState(() {
                  phone = controller.text;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _editAddress(BuildContext context) {
    TextEditingController controller = TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Alamat'),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // Update address in the database
                await updateAddress(controller.text);

                // Update the UI
                setState(() {
                  address = controller.text;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color.fromARGB(255, 188, 95, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: const CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage('Images/foto_profile.png'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: const Text(
              'Pengaturan Akun',
              style: TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 177, 162, 162),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alamat'),
                InkWell(
                  onTap: () {
                    _editAddress(context);
                  },
                  child: const Icon(Icons.edit),
                ),
              ],
            ),
            subtitle: Text(address), // Use the address variable
            onTap: () {
              // Handle address tapping
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('No Telepon'),
                InkWell(
                  onTap: () {
                    _editPhone(context);
                  },
                  child: const Icon(Icons.edit),
                ),
              ],
            ),
            subtitle: Text(phone), // Use the phone variable
            onTap: () {
              // Handle phone tapping
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('History Pesanan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Clear user token from storage
    await storage.delete(key: 'accessToken');

    // Navigate to login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginPage()), // Replace LoginPage() with your actual login page widget
    );
  }

  void _showFeedbackList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Daftar Pengajuan Umpan Balik'),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
