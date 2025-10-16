import 'package:flutter/material.dart';
import 'package:itodev_task/feature_1/example_carousel_page.dart';
import 'package:itodev_task/feature_2/presentation/accelometer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ExampleCarouselPage()),
            ),
            child: Text('Go to Carousel Example'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AccelerometerPage()),
            ),
            child: Text('Go to accelometer graph'),
          ),
        ],
      ),
    );
  }
}
