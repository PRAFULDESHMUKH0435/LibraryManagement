import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,  // Remove default padding
        children: [
          // Drawer Header (Optional)
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,  // Set a color for the header
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Renuka MahaVidyalaya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'An investment in knowledge pays the best interest.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Home section
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigate to home screen (you can replace with actual screen)
              Navigator.pop(context);
            },
          ),

          // About Us section
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              // Navigate to About Us screen (you can replace with actual screen)
              Navigator.pushNamed(context, '/aboutUs');
            },
          ),

          // Contact Us section
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Us'),
            onTap: () {
              // Navigate to Contact Us screen (you can replace with actual screen)
              Navigator.pushNamed(context, '/contactUs');
            },
          ),
        ],
      ),
    );
  }
}
