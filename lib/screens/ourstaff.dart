import 'package:flutter/material.dart';

class LibraryStaff extends StatelessWidget {
  const LibraryStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: Colors.red,
        title: const Text("Library Staff",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.all(14.0),
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("StaffName"),
                      Text("Staff Post"),
                      Text("Staff Email"),
                    ],
                  ),
            ),
          ),
          Container(
            height: 200,
            margin: const EdgeInsets.all(14.0),
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
          ),
        ],
      ),
    );
  }
}
