import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LibraryStaff extends StatefulWidget {
  const LibraryStaff({super.key});

  @override
  State<LibraryStaff> createState() => _LibraryStaffState();
}

class _LibraryStaffState extends State<LibraryStaff> {
  List<Map<dynamic, dynamic>> presentStudents = [];
  String selectedDate = DateTime.now().toString().split(' ')[0]; // Default to today's date

  // Fetch present students for the selected date
  Future<void> fetchPresentStudents(String date) async {
    try {
      final ref = FirebaseDatabase.instance.ref("PresentStudentData/$date/presentStudents");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final studentsData = snapshot.value as List<dynamic>;
        setState(() {
          presentStudents = studentsData.cast<Map<dynamic, dynamic>>();
        });
      } else {
        setState(() {
          presentStudents = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No attendance data found for $date')),
        );
      }
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch attendance data')),
      );
    }
  }

  // Select a date to view attendance
  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final formattedDate = pickedDate.toString().split(' ')[0];
      setState(() {
        selectedDate = formattedDate;
      });
      fetchPresentStudents(formattedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPresentStudents(selectedDate); // Fetch today's data initially
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(14.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Selected Date:",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  selectedDate,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: presentStudents.isEmpty
                ? const Center(child: Text("No students present on this date"))
                : ListView.builder(
                    itemCount: presentStudents.length,
                    itemBuilder: (context, index) {
                      final student = presentStudents[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                        child: ListTile(
                          title: Text(
                            student['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Class: ${student['class']}, ID: ${student['idNumber']}"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}