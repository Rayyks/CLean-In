import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsTab extends StatefulWidget {
  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  List<Map<String, dynamic>> notifications = [];
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/pesanan_laundry'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        setState(() {
          if (responseData['pesanan_laundry'].isNotEmpty) {
            notifications = List<Map<String, dynamic>>.from(
                responseData['pesanan_laundry']);
          }
        });
      } else {
        print('Error: Failed to fetch notifications');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    }
  }

  Future<void> _handleRefresh() async {
    await fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color.fromARGB(255, 188, 95, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  children: notifications.map((order) {
                    return NotificationCard(
                      status: order['status'],
                      createdAt: order['created_at'],
                      userAddress: order['address'],
                    );
                  }).toList(),
                ),
              ),
            ],
          )),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String status;
  final String createdAt;
  final String userAddress;

  NotificationCard({
    required this.status,
    required this.createdAt,
    required this.userAddress,
  });

  String getStatusText(String status, String userAddress) {
    String lowercaseStatus = status.toLowerCase();
    print('Lowercase Status: $lowercaseStatus');
    switch (lowercaseStatus) {
      case 'terima':
        return 'Pesanan kamu udah di terima nih ';
      case 'pickup':
        return 'Pakaian kamu lagi di jemput oleh kurir';
      case 'proses':
        return 'Pakaian kamu sedang di laundry';
      case 'kirim':
        return 'Pakaian kamu lagi di antar ke $userAddress';
      case 'sampai':
        return 'Pakaian kamu sudah sampai';
      case 'selesai':
        return 'Yey, Pakaian sudah di tangan kamu,\nTerima kasih sudah mempercayai Clean.In untuk menjaga pakaianmu tetap terawat ❤️';
      default:
        return 'Pesanan lagi pending, mohon di tunggu ya 😊';
    }
  }

  String getImageAssetPath(String status) {
    switch (status.toLowerCase()) {
      case 'terima':
        return 'Images/ls_confirm 1.png';
      case 'pickup':
        return 'Images/ls_pickup 1.png';
      case 'proses':
        return 'Images/ls_in_progress 1.png';
      case 'kirim':
        return 'Images/Frame 228.png';
      case 'sampai':
        return 'Images/Frame 228.png';
      case 'selesai':
        return 'Images/Frame 229.png';
      default:
        return 'Images/logo.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              getStatusText(status, userAddress),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Text(
              'Waktu: ${DateFormat.yMMMMd().add_jm().format(DateTime.parse(createdAt))}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              getImageAssetPath(status),
              height: 100,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
