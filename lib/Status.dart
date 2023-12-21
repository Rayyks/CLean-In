import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusPage extends StatefulWidget {
  final String orderId;

  const StatusPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Map<String, dynamic>? orderDetails;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/pesanan_laundry/${widget.orderId}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['pesanan_laundry'] != null) {
          setState(() {
            orderDetails = responseData['pesanan_laundry'];
          });
        } else {
          print('Error: Invalid response format');
        }
      } else {
        print('Error: Failed to fetch order details');
      }
    } catch (error) {
      print('Error fetching order details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 191, 0, 255),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (orderDetails != null)
                  Text(
                    'No. Pemesanan: ${widget.orderId}',
                    style: TextStyle(fontSize: 15),
                  ),
                Text('Total Harga: \$90.000', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 18),
            Text(
              'Status Pemesanan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            if (orderDetails != null)
              StatusItem(
                text1: orderDetails!['status'],
                text2: getStatusText(orderDetails!['status']),
                time: getOrderTime(orderDetails!['created_at']),
              ),
          ],
        ),
      ),
    );
  }

  String getStatusText(String status) {
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
        return 'Pakaian kamu lagi di antar';
      case 'sampai':
        return 'Pakaian kamu sudah sampai';
      case 'selesai':
        return 'Yey, Pakaian sudah di tangan kamu,\nTerima kasih sudah mempercayai Clean.In untuk menjaga pakaianmu tetap terawat ❤️';
      default:
        return 'Pesanan lagi pending, mohon di tunggu ya 😊';
    }
  }

  String getOrderTime(String createdAt) {
    DateTime orderTime = DateTime.parse(createdAt);
    return DateFormat.Hm().format(orderTime);
  }
}

class StatusItem extends StatelessWidget {
  final String text1;
  final String text2;
  final String time;

  StatusItem({
    required this.text1,
    required this.text2,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          getImageAssetPath(text1.toLowerCase()),
          width: 60,
          height: 60,
        ),
        Divider(
          color: Colors.black,
          height: 60,
          thickness: 1,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1),
            Text(text2),
          ],
        ),
        Spacer(),
        Text(time),
      ],
    );
  }

  String getImageAssetPath(String status) {
    switch (status) {
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
}
