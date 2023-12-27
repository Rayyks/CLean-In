import 'package:flutter/material.dart';
import 'package:pra_project/pembayaran.dart';
import 'package:pra_project/proses.dart';
import 'package:pra_project/selesai.dart';

class StatusTab extends StatefulWidget {
  @override
  _StatusTabState createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  int _selectedTabIndex = 0;

  final List<String> tabTitles = ['Proses', 'Pembayaran', 'Selesai'];

  bool cashViaCourier = false;

  late ProsesPage prosesPage;
  late PembayaranPage pembayaranPage;
  late SelesaiPage selesaiPage;

  @override
  void initState() {
    super.initState();
    prosesPage = ProsesPage();
    pembayaranPage = PembayaranPage(
      cashViaCourier: cashViaCourier,
    );
    selesaiPage = SelesaiPage(
      orderId: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 191, 0, 255),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedTabIndex == index
                              ? Color.fromARGB(255, 209, 131, 255)
                              : Colors.grey,
                        ),
                        child: Icon(
                          index == 0
                              ? Icons.track_changes
                              : index == 1
                                  ? Icons.payment
                                  : Icons.check_circle,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        tabTitles[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _selectedTabIndex == 0
                  ? prosesPage
                  : (_selectedTabIndex == 1
                      ? pembayaranPage
                      : SizedBox()), // Remove selesaiPage
            ),
          ),
        ],
      ),
    );
  }
}
