import 'package:flutter/material.dart';
import '../layan.dart';

class LayananComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Layanan',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 98, 97, 97),
              ),
            ),
          ),
        ),
        SizedBox(height: 7.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LayananPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 103, 179, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildServiceIcon(Icons.star, 'Premium'),
                _buildServiceIcon(Icons.local_laundry_service, 'Cuci Lipat'),
                _buildServiceIcon(Icons.iron, 'Setrika'),
                _buildServiceIcon(Icons.opacity, 'Khusus'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceIcon(IconData iconData, String label) {
    return Column(
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            iconData,
            color: Color.fromARGB(255, 103, 179, 255),
            size: 30.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.0,
            color: Color.fromARGB(255, 98, 97, 97),
          ),
        ),
      ],
    );
  }
}
