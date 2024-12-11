import 'package:flutter/material.dart';
import 'package:librarymanagement/screens/addstudent.dart';
import 'package:librarymanagement/screens/markattendencescreen.dart';
import 'package:librarymanagement/screens/ourstaff.dart';
import 'package:librarymanagement/screens/viewstudents.dart';

class ReusablecontainerContainer extends StatelessWidget {
  final String title;
  const ReusablecontainerContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == "Add Student") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentScreen()),
          );
        } else if (title == "View Students") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ViewStudentsScreen()),
          );
        } else if (title == "Mark Attendence") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MarkAttendenceScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LibraryStaff()),
          );
        }
      },
      child: Container(
        // margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
