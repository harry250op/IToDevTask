import 'package:flutter/material.dart';
import 'package:itodev_task/feature_1/carousel_widget.dart';

class ExampleCarouselPage extends StatelessWidget {
  const ExampleCarouselPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Carousel Example'),
      automaticallyImplyLeading: true,
    ),

    body: Center(
      child: SizedBox(
        height: 250,
        child: Carousel(
          autoPlay: true,
          loop: true,
          enableScaleEffect: true,
          enableParallax: true,
          scaleFactor: 0.2,
          parallaxOffset: 50,
          viewportFraction: 0.85,
          items: [
            _buildCard('Card 1', Colors.red),
            _buildCard('Card 2', Colors.green),
            _buildCard('Card 3', Colors.blue),
            _buildCard('Card 4', Colors.orange),
            _buildCard('Card 5', Colors.purple),
          ],
        ),
      ),
    ),
  );

  Widget _buildCard(String title, Color color) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
