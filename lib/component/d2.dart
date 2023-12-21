import 'package:flutter/material.dart';

class PenawaranComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Penawaran',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 98, 97, 97),
              ),
            ),
          ),
        ),
        SizedBox(height: 7.0),
        SizedBox(
          height: 200.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildOfferCard(
                'Images/baju.jpg',
                'Judul 1',
              ),
              _buildOfferCard(
                'Images/jemur.jpg',
                'Judul 2',
              ),
              _buildOfferCard(
                'Images/setrika.jpg',
                'Judul 3',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(String imagePath, String title) {
    return Card(
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 150.0,
            width: 250.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
