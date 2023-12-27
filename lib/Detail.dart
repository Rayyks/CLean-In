import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DetailPage extends StatefulWidget {
  final String orderId;

  const DetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? orderDetails;
  final storage = FlutterSecureStorage();
  String errorMessage = '';

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate =
        "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
    return formattedDate;
  }

  // New method to get status text based on the order status
  String getStatusText(String status) {
    String lowercaseStatus = status.toLowerCase();
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
        return 'Yey, Pakaian sudah di tangan kamu,\nTerima kasih sudah mempercayai\nClean.In';
      default:
        return 'Pesanan lagi pending,\nmohon di tunggu ya 😊';
    }
  }

  // New method to get image asset path based on the order status
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

  Future<void> _refreshData() async {
    fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Retrieve the access token from secure storage
      final accessToken = await storage.read(key: 'accessToken');

      final orderResponse = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/pesanan_laundry/${widget.orderId}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (orderResponse.statusCode == 200) {
        final orderData = json.decode(orderResponse.body);

        // Check if the required data is present
        if (orderData['pesanan_laundry'] != null) {
          // Extract the price from the orderData
          final price = orderData['pesanan_laundry']['price'];

          // Store the price in Flutter storage
          await storage.write(key: 'price', value: price.toString());

          setState(() {
            orderDetails = orderData['pesanan_laundry'];
          });
        } else {
          setState(() {
            errorMessage = 'Order details not found';
          });
          return;
        }
      } else {
        final errorResponse = json.decode(orderResponse.body);
        setState(() {
          errorMessage = errorResponse['message'] ?? 'Unknown error';
        });
        return;
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orderDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detail Pemesanan'),
        ),
        body: Center(
          child: errorMessage.isEmpty
              ? CircularProgressIndicator()
              : Text('Error fetching order details: $errorMessage'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pemesanan',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 191, 0, 255),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. Pemesanan: ${orderDetails!['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Tanggal Pengambilan: ${orderDetails!['pickup_at']} '),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Waktu Pengambilan: ${orderDetails?['delivery_at'] ?? "Sedang di tentukan"}',
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        '${orderDetails?['laundry_type']} ${orderDetails?['detergen_type'] != null ? '& ${orderDetails?['detergen_type']}' : ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 8),
                      Text('Item:'),
                      for (var item
                          in json.decode(orderDetails!['laundry_items'])) ...[
                        Text('${item['quantity']}x ${item['item']}'),
                      ],
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Berat Timbangan'),
                          Text(
                              '${orderDetails!['laundry_weight'] ?? 'Sedang di timbang'}'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Harga Pembayaran:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   'Subtotal ',
                      // ),
                      // Text('Diskon: \10%'),
                      SizedBox(height: 8),
                      Text(
                        'Total: ${formatAsIDR(orderDetails!['price'] ?? 'Menunggu hasil timbangan')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image.asset(
                          getImageAssetPath(orderDetails!['status']),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status Pemesanan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            getStatusText(orderDetails!['status']),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to format the price as IDR
String formatAsIDR(dynamic amount) {
  final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  if (amount is String) {
    double amountValue = double.tryParse(amount) ?? 0;

    // Display 'Menunggu hasil timbangan' when the total price is 0
    return amountValue == 0
        ? 'Menunggu hasil timbangan'
        : format.format(amountValue);
  } else if (amount is num) {
    // Display 'Menunggu hasil timbangan' when the total price is 0
    return amount == 0 ? 'Menunggu hasil timbangan' : format.format(amount);
  } else {
    return 'Menunggu hasil timbangan';
  }
}
