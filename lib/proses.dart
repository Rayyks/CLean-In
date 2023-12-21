import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pra_project/selesai.dart';
import 'Detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProsesPage extends StatefulWidget {
  @override
  _ProsesPageState createState() => _ProsesPageState();
}

class _ProsesPageState extends State<ProsesPage> {
  final storage = FlutterSecureStorage();

  List<Map<String, dynamic>> orders = [];
  String errorMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    try {
      // Retrieve the access token from secure storage
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
            orders = List<Map<String, dynamic>>.from(
                responseData['pesanan_laundry']);
          }
          isLoading = false;
        });
      } else {
        final errorResponse = json.decode(response.body);
        setState(() {
          errorMessage = errorResponse['message'] ?? 'Unknown error';
          isLoading = false;
        });
        print(errorMessage);
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
        isLoading = false;
      });
      print(errorMessage);
    }
  }

  Future<String> fetchPaymentStatus(int orderId) async {
    try {
      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/payment/$orderId/status'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['status'] ?? '';
      } else {
        // Handle error scenarios
        print('Error fetching payment status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return '';
      }
    } catch (error) {
      // Handle exceptions
      print('Exception during fetchPaymentStatus: $error');
      return '';
    }
  }

  Future<void> _handleRefresh() async {
    // Implement the refresh logic here
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proses Page'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Text('Belum ada pesanan')
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var order in orders) ...[
                          FutureBuilder<String>(
                            future: fetchPaymentStatus(order['id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(); // Placeholder for loader
                              } else if (snapshot.hasError) {
                                return Text('Error loading payment status');
                              } else {
                                final paymentStatus = snapshot.data ?? '';

                                return Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Nama: ${order['name']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'No. Pesanan: ${order['id']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Status: $paymentStatus',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Waktu: ${DateFormat.yMMMMd().add_jm().format(DateTime.parse(order['created_at']))}',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Image.asset(
                                                'Images/ls_confirm 1.png'),
                                            Image.asset(
                                                'Images/ls_pickup 1.png'),
                                            Image.asset(
                                                'Images/ls_in_progress 1.png'),
                                            Image.asset('Images/Frame 228.png'),
                                            Image.asset('Images/Frame 229.png'),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPage(
                                                      orderId: order['id']
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text('Lihat Detail'),
                                            ),
                                            if (paymentStatus == 'selesai')
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SelesaiPage(
                                                              orderId: order[
                                                                      'id']
                                                                  .toString()),
                                                    ),
                                                  );
                                                },
                                                child: Text('Nota'),
                                              ),
                                          ],
                                        ),
                                        if (paymentStatus == 'selesai')
                                          Center(
                                            child: Text(
                                              'Pembayaran Selesai',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
