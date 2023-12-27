import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pra_project/dashboard.dart';

class SelesaiPage extends StatefulWidget {
  final String orderId;

  SelesaiPage({required this.orderId});

  @override
  _SelesaiPageState createState() => _SelesaiPageState();
}

class _SelesaiPageState extends State<SelesaiPage> {
  Map<String, dynamic> orderDetails = {};
  bool isLoading = true;
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

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        setState(() {
          orderDetails = responseData;
          isLoading = false;
        });
      } else {
        print('Error fetching order details: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle error scenarios
      }
    } catch (error) {
      print('Exception during fetchOrderDetails: $error');
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selesai Page'),
      ),
      body: Center(
        child: Material(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Order Details'),
                      _buildOrderInfo('Nama Pelanggan',
                          orderDetails['pesanan_laundry']['name'] ?? ''),
                      _buildOrderInfo('Nomor Pemesanan', widget.orderId),
                      _buildDeliveryInfo('Waktu Pengembalian',
                          orderDetails['pesanan_laundry']['delivery_at'] ?? ''),
                      _buildOrderInfo('Metode Pembayaran',
                          'Bayar di tempat / melalui kurir'),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Status Pembayaran'),
                      Center(
                        child: Image.network(
                          'https://png.pngtree.com/png-vector/20220724/ourmid/pngtree-bill-paid-icon-payment-successful-invoice-bill-paid-vector-png-image_38128822.png',
                          height: 200,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(),
            ),
          );
        },
        child: Icon(Icons.dashboard),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildOrderInfo(String title, String value) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 2, // Adjust the flex factor as needed
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(String title, String value) {
    try {
      // Attempt to parse the date string
      DateTime deliveryDate = DateTime.parse(value);
      // Format the date as "EEEE, d MMMM yyyy" in Indonesian
      String formattedDate =
          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(deliveryDate);
      return _buildOrderInfo(title, formattedDate);
    } catch (error) {
      // Handle date parsing error
      print('Error parsing date: $error');
      return _buildOrderInfo(title, 'Masih di proses');
    }
  }
}
