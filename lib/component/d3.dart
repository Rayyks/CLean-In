import 'package:flutter/material.dart';

class DiskonComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Paket Khusus',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 98, 97, 97),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7.0),
        Container(
          height: 140.0, // Set tinggi container sesuai kebutuhan Anda
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: 280.0,
                child: _buildSpecialPackageCard(
                  'Terbatas',
                  'Diskon 20%',
                  'Images/gambar_paket_1.png',
                  const Color.fromARGB(255, 93, 182, 255),
                ),
              ),
              Container(
                width: 280.0,
                child: _buildSpecialPackageCard(
                  'Diskon Meriah',
                  'Diskon 35%',
                  'Images/gambar_paket_2.png',
                  const Color.fromARGB(255, 93, 182, 255),
                ),
              ),
              Container(
                width: 280.0,
                child: _buildSpecialPackageCard(
                  'Paket 3',
                  'Diskon 10%',
                  'Images/gambar_paket_1.png',
                  const Color.fromARGB(255, 93, 182, 255),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialPackageCard(
      String package, String discountPrice, String imagePath, Color cardColor) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 105, 209, 254),
              Color.fromARGB(255, 221, 140, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 70.0,
              height: 70.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      discountPrice,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Tambahkan aksi yang ingin Anda lakukan ketika tombol Klaim ditekan
                        },
                        child: const Text('Klaim'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
