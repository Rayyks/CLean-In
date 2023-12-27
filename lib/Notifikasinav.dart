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
  bool isLoading = true;

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
          isLoading = false;
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

  Future<String> fetchPaymentStatus(int orderId) async {
    try {
      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/payments'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final payment = responseData['payments'].firstWhere(
          (payment) => payment['pesanan_laundry_id'] == orderId,
          orElse: () => null,
        );

        if (payment != null) {
          return payment['status'] ?? '';
        }
      } else {
        // Handle error scenarios
        // Print an error message or show a snackbar
      }
    } catch (error) {
      // Handle exceptions
      // Print an error message or show a snackbar
    }

    return ''; // Default to an empty string if payment status is not found
  }

  void removeNotification(int orderId) {
    // Implement the logic to remove the notification based on your backend API
    // You may need to send a request to your server to update the notification status or remove it from the list
    print('Removing Notification with ID: $orderId');
    // For now, we will remove it from the local list (this won't persist on server)
    setState(() {
      notifications
          .removeWhere((notification) => notification['id'] == orderId);
    });
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
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Display loader here
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16.0),
                      children: notifications.map((order) {
                        return FutureBuilder<String>(
                          future: fetchPaymentStatus(order['id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(); // Don't display loader for each element
                            } else if (snapshot.hasError) {
                              return Text('Error loading payment status');
                            } else {
                              // Get the payment status
                              final paymentStatus = snapshot.data ?? '';

                              return NotificationCard(
                                orderId: order['id'],
                                status: order['status'],
                                createdAt: order['created_at'],
                                userAddress: order['address'],
                                laundryWeight: order['laundry_weight'],
                                paymentStatus: paymentStatus,
                                onRemove: removeNotification,
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final int orderId;
  final String status;
  final String createdAt;
  final String userAddress;
  final double laundryWeight;
  final String paymentStatus;
  final Function(int) onRemove;

  NotificationCard({
    required this.orderId,
    required this.status,
    required this.createdAt,
    required this.userAddress,
    required this.laundryWeight,
    required this.paymentStatus,
    required this.onRemove,
  });

  String getStatusText(
    String status,
    String userAddress,
    double laundryWeight,
    String paymentStatus,
  ) {
    String lowercaseStatus = status.toLowerCase();
    print('Lowercase Status: $lowercaseStatus');

    if (paymentStatus == 'pending') {
      return 'Mohon lakukan pembayaran';
    }

    switch (lowercaseStatus) {
      case 'terima':
        return 'Pesanan kamu udah di terima nih';
      case 'pickup':
        return 'Pakaian kamu lagi di jemput oleh kurir \nKamu sekarang sudah bisa melakukan pembayaran 😊';
      case 'proses':
        return 'Pakaian kamu udah di timbang beratnya:\n${laundryWeight.toString()} Kg \nKamu sekarang sudah bisa melakukan pembayaran 😊';
      case 'packing':
        return 'Pakaian kamu sedang dipacking untuk pengiriman\nKamu sekarang sudah bisa melakukan pembayaran 😊';
      case 'kirim':
        return 'Pakaian kamu lagi di antar ke $userAddress\nKamu sekarang sudah bisa melakukan pembayaran 😊';
      case 'sampai':
        return 'Pakaian kamu sudah sampai';
      case 'selesai':
        return 'Yey, Pakaian sudah di tangan kamu,\nTerima kasih sudah mempercayai Clean.In untuk menjaga pakaianmu tetap terawat ❤️';
      default:
        return 'Pesanan lagi pending';
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
              getStatusText(status, userAddress, laundryWeight, paymentStatus),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Text(
              'Waktu: ${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(DateTime.parse(createdAt))}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          if (paymentStatus == 'pending')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Mohon melakukan pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => onRemove(orderId),
              child: Text('Hapus'),
            ),
          ),
        ],
      ),
    );
  }
}
