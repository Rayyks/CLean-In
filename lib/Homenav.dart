import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pra_project/component/d1.dart';
import 'package:pra_project/component/d2.dart';
import 'package:pra_project/component/d3.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final storage = FlutterSecureStorage();
  String userName = '';
  String userAddress = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final storedUserName = await storage.read(key: 'userName') ?? '';
      final storedUserAddress = await storage.read(key: 'userAddress') ?? '';

      setState(() {
        userName = storedUserName;
        userAddress = storedUserAddress;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: double.infinity,
          height: 150.0,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBC5FFF), Color(0xFF7647FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Clean In',
                  style: TextStyle(
                    color: Color.fromARGB(255, 231, 151, 255),
                    fontSize: 24.0,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo, $userName', // Displaying user name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Lokasi Anda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        userAddress, // Displaying user address
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25.0),
        LayananComponent(),
        const SizedBox(height: 25.0),
        PenawaranComponent(),
        const SizedBox(height: 25.0),
        DiskonComponent(),
      ],
    );
  }
}
