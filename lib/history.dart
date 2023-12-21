import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HistoryPage extends StatelessWidget {
  int? userRating;
  final storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> fetchOrderHistory() async {
    try {
      // Retrieve the access token from secure storage
      final accessToken = await storage.read(key: 'accessToken');

      // Replace this URL with the actual endpoint to fetch order history
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/pesanan_laundry'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // print('Response body: ${response.body}'); // Add this line

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData.containsKey('pesanan_laundry')) {
          final List<dynamic> data = responseData['pesanan_laundry'];

          // Process the data and convert it to the desired format
          List<Map<String, dynamic>> orderHistory =
              data.map<Map<String, dynamic>>((item) {
            final createdDateTime = DateTime.parse(item['created_at']);
            final formattedCreatedAt =
                DateFormat.yMMMMd().add_jm().format(createdDateTime);

            return {
              'id': item['id'],
              'created_at': formattedCreatedAt,
              'name': item['name'],
            };
          }).toList();

          return orderHistory;
        } else {
          throw Exception('Field "pesanan_laundry" not found in the response');
        }
      } else {
        throw Exception(
            'Failed to load order history. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching order history: $error');
      throw error;
    }
  }

  Future<void> _ratePesanan(String pesananId, int? rating) async {
    try {
      final accessToken = await storage.read(key: 'accessToken');

      final response = await http.patch(
        Uri.parse('http://127.0.0.1:8000/api/pesanan_laundry/$pesananId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        print('Pesanan rated successfully');
      } else {
        print('Failed to rate pesanan: ${response.statusCode}');
      }
    } catch (error) {
      print('Error rating pesanan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Pemesanan',
          style: TextStyle(
            color: Color.fromARGB(255, 188, 95, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 188, 95, 255),
        ),
      ),
      body: FutureBuilder(
        future: fetchOrderHistory(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> historyList = snapshot.data ?? [];

            return historyList.isEmpty
                ? Center(child: Text('Belum ada pesanan'))
                : ListView.builder(
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final historyItem = historyList[index];
                      return GestureDetector(
                        onTap: () {
                          _showOrderDetailsDialog(context, historyItem);
                        },
                        child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                              color: Color.fromARGB(255, 236, 130, 255),
                              width: 2,
                            ),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nomer Pesanan: ${historyItem['id']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Tanggal: ${historyItem['created_at']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Nama: ${historyItem['name']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }

  void _showOrderDetailsDialog(
      BuildContext context, Map<String, dynamic> historyItem) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Detail Pemesanan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ID: ${historyItem['id']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Tanggal: ${historyItem['created_at']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Rating:',
                    style: TextStyle(fontSize: 16),
                  ),
                  RatingBar.builder(
                    initialRating: userRating?.toDouble() ?? 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        userRating = rating.toInt();
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Beri Rating'),
                  onPressed: () {
                    _ratePesanan(historyItem['id'].toString(), userRating);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void main() => runApp(MaterialApp(
        home: HistoryPage(),
      ));
}
