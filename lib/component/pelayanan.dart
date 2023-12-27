import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pra_project/proses.dart';

class ServiceComponent extends StatefulWidget {
  @override
  _ServiceComponentState createState() => _ServiceComponentState();
}

class _ServiceComponentState extends State<ServiceComponent> {
  DateTime selectedPickupDate = DateTime.now();
  TimeOfDay selectedPickupTime = TimeOfDay.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedLaundryType = '';
  String selectedDetergenType = '';
  TextEditingController pickupDateTimeController = TextEditingController();

  Map<String, bool> laundryItemsMap = {
    'Baju': false,
    'Celana': false,
    'Jaket': false,
    'Kemeja': false,
    'Selimut': false,
    'Karpet': false,
    'Alas Kasur': false,
    'Boneka': false,
  };

  Map<String, int> laundryItemsQuantity = {
    'Baju': 0,
    'Celana': 0,
    'Jaket': 0,
    'Kemeja': 0,
    'Selimut': 0,
    'Karpet': 0,
    'Alas Kasur': 0,
    'Boneka': 0,
  };

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userName = await storage.read(key: 'userName') ?? "";
      final userAddress = await storage.read(key: 'userAddress') ?? "";

      setState(() {
        nameController.text = userName;
        addressController.text = userAddress;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: selectedPickupDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        )) ??
        DateTime.now();

    selectedPickupDate = picked;
    updatePickupDateTimeController();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
          context: context,
          initialTime: selectedPickupTime,
        )) ??
        TimeOfDay.now();

    selectedPickupTime = picked;
    updatePickupDateTimeController();
  }

  void updatePickupDateTimeController() {
    final formattedDate = DateFormat.yMd().format(selectedPickupDate);
    final formattedTime = selectedPickupTime.format(context);
    pickupDateTimeController.text = '$formattedDate $formattedTime';
  }

  Future<void> sendRequest() async {
    BuildContext currentContext = context;

    try {
      // Check if at least one item is selected
      if (laundryItemsMap.values.every((value) => !value)) {
        // Show alert because no item is selected
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Tidak ada item yang di pilih'),
              content: Text('Tolong pilih sedikitnya 1 item.'),
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
        return; // Do not proceed with the API request
      }

      final accessToken = await storage.read(key: 'accessToken');

      List<Map<String, dynamic>> itemsData = [];
      for (String item in laundryItemsMap.keys) {
        if (laundryItemsMap[item]!) {
          itemsData.add({
            'item': item,
            'quantity': laundryItemsQuantity[item] ?? 0,
          });
        }
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/pesanan_laundry'),
        body: {
          'name': nameController.text,
          'address': addressController.text,
          'laundry_type': selectedLaundryType,
          'detergen_type': selectedDetergenType,
          'pickup_at': pickupDateTimeController.text,
          'laundry_items': json.encode(itemsData),
        },
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          currentContext, // Use the stored context
          MaterialPageRoute(
            builder: (context) => ProsesPage(),
          ),
        );
        showSuccessNotification(currentContext);
      } else {
        final errorMessage = json.decode(response.body)['message'];
        print(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void showSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil Memesan!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Pelayanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            _buildNameTextField(),
            SizedBox(height: 16),
            _buildLaundryTypeDropdown(),
            SizedBox(height: 16),
            _buildDetergenTypeDropdown(),
            SizedBox(height: 16),
            _buildAddressTextField(),
            SizedBox(height: 16),
            _buildLaundryItemsCheckboxList(),
            SizedBox(height: 16),
            _buildPickupDateTimeTextField(),
            SizedBox(height: 16),
            _buildSendRequestButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      controller: nameController,
      readOnly: true, // Make it not editable
      decoration: InputDecoration(
        labelText: 'Nama',
        border: OutlineInputBorder(),
        hintText: 'Masukkan nama Anda',
        prefixIcon: Icon(Icons.person),
      ),
    );
  }

  Widget _buildLaundryTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Pelayanan',
        border: OutlineInputBorder(),
      ),
      items: [
        'Premium',
        'Cuci Setrika',
        'Setrika',
        'Khusus',
      ].map((String method) {
        return DropdownMenuItem<String>(
          value: method,
          child: Text(method),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedLaundryType = value ?? '';
          // Clear selected items when laundry type changes
          laundryItemsMap.clear();
          laundryItemsQuantity.forEach((key, value) {
            laundryItemsMap[key] = false;
          });
        });
      },
    );
  }

  Widget _buildDetergenTypeDropdown() {
    // Show detergent type dropdown only if the laundry method is not "Setrika"
    if (selectedLaundryType != 'Setrika') {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Jenis Detergen',
          border: OutlineInputBorder(),
        ),
        items: ['Cair', 'Bubuk', 'Krim', 'Kapsul'].map((String detergent) {
          return DropdownMenuItem<String>(
            value: detergent,
            child: Text(detergent),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedDetergenType = value ?? '';
          });
        },
      );
    } else {
      // If laundry method is "Setrika," hide detergent type dropdown
      return SizedBox.shrink();
    }
  }

  Widget _buildAddressTextField() {
    return TextFormField(
      maxLines: 3,
      controller: addressController,
      readOnly: true, // Make it not editable
      decoration: InputDecoration(
        labelText: 'Alamat',
        border: OutlineInputBorder(),
        hintText: 'Masukkan alamat Anda',
        prefixIcon: Icon(Icons.location_on),
      ),
    );
  }

  Widget _buildLaundryItemsCheckboxList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedLaundryType == 'Premium') ...[
          for (String item in laundryItemsQuantity.keys)
            _buildCheckboxRow(item),
        ],
        if (selectedLaundryType == 'Cuci Setrika' ||
            selectedLaundryType == 'Setrika') ...[
          for (String item in ['Baju', 'Celana', 'Jaket', 'Kemeja'])
            _buildCheckboxRow(item),
        ],
        if (selectedLaundryType == 'Khusus') ...[
          for (String item in ['Selimut', 'Karpet', 'Alas Kasur', 'Boneka'])
            _buildCheckboxRow(item),
        ],
      ],
    );
  }

  Widget _buildCheckboxRow(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: laundryItemsMap[item] ?? false,
            onChanged: (bool? value) {
              setState(() {
                laundryItemsMap[item] = value ?? false;
              });
            },
          ),
          Text(item),
          Spacer(),
          _buildQuantityControlRow(item),
        ],
      ),
    );
  }

  Widget _buildQuantityControlRow(String item) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              laundryItemsQuantity[item] =
                  (laundryItemsQuantity[item] ?? 0) + 1;
            });
          },
          child: Text('+'),
        ),
        SizedBox(width: 10),
        Text('${laundryItemsQuantity[item]}'),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (laundryItemsQuantity[item]! > 0) {
                laundryItemsQuantity[item] =
                    (laundryItemsQuantity[item] ?? 0) - 1;
              }
            });
          },
          child: Text('-'),
        ),
      ],
    );
  }

  Widget _buildPickupDateTimeTextField() {
    return TextFormField(
      controller: pickupDateTimeController,
      readOnly: true, // Make it not editable
      decoration: InputDecoration(
        labelText: 'Tanggal dan Waktu Penjemputan',
        border: OutlineInputBorder(),
        hintText: 'Pilih tanggal dan waktu',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () {
        _selectDate(context);
        _selectTime(context);
      },
    );
  }

  Widget _buildSendRequestButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Check if at least one item is selected with a non-zero quantity
          bool hasValidItems = false;

          for (String item in laundryItemsMap.keys) {
            if (laundryItemsMap[item]! && laundryItemsQuantity[item]! > 0) {
              hasValidItems = true;
            } else if (laundryItemsMap[item]! &&
                laundryItemsQuantity[item] == 0) {
              // Show alert because a checked item has quantity 0
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Item tidak valid'),
                    content: Text(
                        'Item "$item" harus memiliki jumlah lebih dari 0.'),
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
              return; // Do not proceed with the API request
            }
          }

          if (!hasValidItems) {
            // Show alert because no valid item is selected
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Tidak ada item yang di pilih'),
                  content: Text(
                      'Tolong pilih paling sedikit 1 item dan jumlahnya lebih dari 0.'),
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
            return; // Do not proceed with the API request
          }

          sendRequest();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.purple,
          onPrimary: Colors.white,
        ),
        child: Text('Kirim'),
      ),
    );
  }
}
