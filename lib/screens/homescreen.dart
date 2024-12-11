import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:librarymanagement/constants/ReUsableContainer.dart';
import 'package:librarymanagement/constants/customdrawer.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'assets/images/banner1.jpg',
      'assets/images/banner2.jpg',
      'assets/images/banner3.jpg',
    ];

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.red,
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: Colors.red,
        title: const Text(
          "Renuka MahaVidyalaya",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Top Container (CarouselSlider) takes 30% of the height
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: CarouselSlider(
              options: CarouselOptions(
                height: double.infinity,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: bannerImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          // Bottom Container (GridView) takes 70% of the height
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12.0), // Fixed margin value
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  // Titles for the grid items
                  final titles = [
                    "Add Student",
                    "View Students",
                    "Mark Attendence",
                    "Our Staff",
                  ];
                  return ReusablecontainerContainer(title: titles[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
