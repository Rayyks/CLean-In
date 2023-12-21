import 'package:flutter/material.dart';

class TentangComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          _buildLogo(),
          SizedBox(height: 20),
          _buildSectionTitle('Tentang Clean.in Laundry'),
          _buildDescription(
            'Clean.in Laundry adalah layanan laundry profesional dengan fokus pada kepuasan pelanggan. Kami berkomitmen untuk memberikan pelayanan terbaik dalam mencuci dan merawat pakaian Anda. Dengan teknologi canggih dan tim profesional, kami memberikan hasil terbaik untuk setiap cucian Anda.',
          ),
          SizedBox(height: 20),
          _buildSectionTitle('Alamat Kami'),
          _buildDescription('Jl. Contoh No. 123, Kota Contoh'),
          SizedBox(height: 20),
          _buildContactButton(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(
          //       'assets/cleanin_logo.png'), // Ganti dengan path logo Clean.in Laundry
          //   fit: BoxFit.contain,
          // ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Ganti dengan navigasi atau fungsi untuk menghubungi Clean.in Laundry
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.purple,
        onPrimary: Colors.white,
      ),
      child: Text('Hubungi Kami'),
    );
  }
}
