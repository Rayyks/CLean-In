import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pra_project/proses.dart';
import 'package:pra_project/selesai.dart';

class PembayaranPage extends StatefulWidget {
  final bool cashViaCourier;
  final bool transferBank;

  PembayaranPage({
    required this.cashViaCourier,
    required this.transferBank,
  });

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final storage = FlutterSecureStorage();
  List<Map<String, dynamic>> userOrders = [];
  int? selectedOrderId;
  double? selectedOrderPrice;
  bool _isCashViaCourierChecked = false;
  String paymentStatus = '';

  Future<void> _refreshPage() async {
    await fetchUserOrders();
    if (selectedOrderId != null) {
      await updatePrice(selectedOrderId! as double);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
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
          userOrders =
              List<Map<String, dynamic>>.from(responseData['pesanan_laundry']);
        });
      } else {
        // Handle error scenarios
        // Print an error message or show a snackbar
      }
    } catch (error) {
      // Handle exceptions
      // Print an error message or show a snackbar
    }
  }

  Future<double> fetchPrice(int? orderId) async {
    try {
      if (orderId == null) {
        return 0.0;
      }

      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/pesanan_laundry/$orderId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final price = responseData['pesanan_laundry']['price'];

        print('Fetched Price: $price'); // Add this print statement

        return double.parse(price ?? '0.0');
      } else {
        // Handle error scenarios
        // Print an error message or show a snackbar
        return 0.0;
      }
    } catch (error) {
      // Handle exceptions
      // Print an error message or show a snackbar
      return 0.0;
    }
  }

  Future<void> updatePrice(double orderId) async {
    if (selectedOrderId != null) {
      final price = await fetchPrice(orderId as int?);
      setState(() {
        selectedOrderPrice = price;
      });
    }
  }

  Future<void> fetchPaymentStatus(int? orderId) async {
    try {
      if (orderId == null) {
        return;
      }

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
          setState(() {
            paymentStatus = payment['status'] ?? '';
          });
        }
      } else {
        // Handle error scenarios
        // Print an error message or show a snackbar
        return;
      }
    } catch (error) {
      // Handle exceptions
      // Print an error message or show a snackbar
      return;
    }
  }

  Future<void> submitPayment() async {
    if (selectedOrderId != null) {
      try {
        final accessToken = await storage.read(key: 'accessToken');

        // Fetch payment status
        await fetchPaymentStatus(selectedOrderId);

        // Check payment status and update UI
        if (paymentStatus == 'selesai') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Pembayaran Selesai'),
                content: Text('Pesanan ini sudah dibayar.'),
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
        } else {
          // Submit the payment price
          final responsePayment = await http.patch(
            Uri.parse(
                'http://127.0.0.1:8000/api/pesanan_laundry/$selectedOrderId'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: json.encode({'status': 'selesai'}),
          );

          if (responsePayment.statusCode == 200) {
            // Payment submitted successfully
            print('Payment submitted successfully');

            // Remove the successfully paid order from the dropdown list
            setState(() {
              userOrders.removeWhere((order) => order['id'] == selectedOrderId);
              selectedOrderId = null; // Clear the selectedOrderId
            });

            // Fetch user orders again to reflect the changes
            await fetchUserOrders();

            // Show a Snackbar for payment success
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Pembayaran Berhasil!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // Handle payment submission error
            print('Failed to submit payment');
          }
        }
      } catch (error) {
        // Handle exceptions
        print('Error submitting payment: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 202, 120, 246),
                              width: 1.0,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                          ),
                          margin: const EdgeInsets.all(10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButton<int?>(
                              items: userOrders.map((order) {
                                return DropdownMenuItem<int?>(
                                  value: order['id'],
                                  child: Text('Pesanan ${order['id']}'),
                                );
                              }).toList(),
                              onChanged: (int? selectedOrderId) async {
                                if (selectedOrderId != null) {
                                  setState(() {
                                    this.selectedOrderId = selectedOrderId;
                                  });
                                  // Remove the await from here
                                  fetchPrice(selectedOrderId);
                                }
                              },
                              value: selectedOrderId,
                              hint: const Text('Pilih Pesanan'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 202, 120, 246),
                              width: 1.0,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                          ),
                          margin: const EdgeInsets.all(10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: selectedOrderId != null
                                ? FutureBuilder<double>(
                                    future: fetchPrice(selectedOrderId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error loading price');
                                      } else {
                                        // Update the selectedOrderPrice
                                        selectedOrderPrice = snapshot.data!;
                                        return Text(
                                          'Harga: ${formatAsIDR(selectedOrderPrice!)}',
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : Text('Pilih pesanan terlebih dahulu'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  const Text(
                    'Metode Pembayaran:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 202, 120, 246),
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    margin: const EdgeInsets.all(10.0),
                    child: Opacity(
                      opacity: selectedOrderPrice == 0.0 ? 0.5 : 1.0,
                      child: CheckboxListTile(
                        title: const Text('Cash melalui kurir'),
                        value: _isCashViaCourierChecked,
                        onChanged: selectedOrderPrice == 0.0
                            ? null
                            : (bool? isChecked) {
                                if (isChecked != null) {
                                  setState(() {
                                    _isCashViaCourierChecked = isChecked;
                                  });
                                }
                              },
                      ),
                    ),
                  ),

                  // Add a "Next" button to navigate to the "Selesai" page
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedOrderId != null) {
                        // Fetch payment status
                        await fetchPaymentStatus(selectedOrderId);

                        // Check payment status and update UI
                        if (paymentStatus == 'selesai') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Pembayaran Selesai'),
                                content: Text('Pesanan ini sudah dibayar.'),
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
                        } else {
                          // Call the function to submit payment
                          submitPayment();

                          // Comment out the navigation to "Selesai" page
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ProsesPage(),
                          //   ),
                          // );
                        }
                      }
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatAsIDR(double amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return format.format(amount);
  }
}
