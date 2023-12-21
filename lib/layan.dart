import 'package:flutter/material.dart';
import 'package:pra_project/component/harga.dart';
import 'package:pra_project/component/pelayanan.dart';
import 'package:pra_project/component/tentang.dart';

class LayananPage extends StatefulWidget {
  const LayananPage({super.key});

  @override
  State<LayananPage> createState() => _LayananPageState();
}

class _LayananPageState extends State<LayananPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clean In',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Batam',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(width: 16),
          ],
          bottom: TabBar(
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.white,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            tabs: [
              Tab(
                text: 'Tentang',
                icon: Icon(Icons.info),
              ),
              Tab(
                text: 'Pelayanan',
                icon: Icon(Icons.business),
              ),
              Tab(
                text: 'Daftar Harga',
                icon: Icon(Icons.attach_money),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TentangComponent(), // Replace with your component
            ServiceComponent(), // Replace with your component
            HargaList(), // Replace with your component
          ],
        ),
      ),
    );
  }
}
