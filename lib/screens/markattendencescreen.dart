import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For getting the current date in 'yyyy-MM-dd' format

class MarkAttendenceScreen extends StatefulWidget {
  const MarkAttendenceScreen({super.key});

  @override
  State<MarkAttendenceScreen> createState() => _MarkAttendenceScreenState();
}

class _MarkAttendenceScreenState extends State<MarkAttendenceScreen> {
  List<Map<dynamic, dynamic>> students = [];
  List<Map<dynamic, dynamic>> filteredStudents = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Fetch students from the database
  Future<void> fetchStudents() async {
    try {
      final ref = FirebaseDatabase.instance.ref("CollegeDatabase");

      // Fetch data snapshot
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final studentsData = snapshot.value as Map<dynamic, dynamic>;

        // Clear the existing list before adding new data
        students.clear();

        studentsData.forEach((key, value) {
          // Add student data into the list
          students.add({
            'id': key,
            'name': value['Name'] ?? 'N/A',
            'class': value['Class'] ?? 'N/A',
            'idNumber': value['Id'] ?? 'N/A',
            'isPresent': value['isPresent'] ?? false,
          });
        });

        // Set filteredStudents to the full list initially
        filteredStudents = List.from(students);

        // Refresh UI after data is fetched
        setState(() {});
      } else {
        print("No students found in the database.");
      }
    } catch (e) {
      print("Error while fetching students: $e");
    }
  }

  // Mark attendance for a student
  Future<void> markAttendance(String studentId) async {
    try {
      final ref = FirebaseDatabase.instance.ref("CollegeDatabase").child(studentId);

      // Update the student's isPresent flag to true
      await ref.update({'isPresent': true});

      // Refresh the list of students
      fetchStudents();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked for student ID: $studentId')),
      );
    } catch (e) {
      print("Error while marking attendance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark attendance')),
      );
    }
  }

  // Add present students to Firebase under "PresentStudentData"
  Future<void> addPresentStudents() async {
    // Show dialog for password entry
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Password"),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            keyboardType: TextInputType.number, // Numeric input
            obscureText: true, // Hide the password text
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Check if the entered password is correct
                if (passwordController.text == '12345') {
                  // Password is correct, proceed to save present students data
                  savePresentStudents();
                  Navigator.pop(context); // Close the dialog
                } else {
                  // Password is incorrect, show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect password')),
                  );
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Save present students to Firebase
  Future<void> savePresentStudents() async {
    try {
      final presentStudents = filteredStudents.where((student) => student['isPresent']).toList();

      if (presentStudents.isNotEmpty) {
        // Get today's date in 'yyyy-MM-dd' format
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        // Add present students under today's date
        final ref = FirebaseDatabase.instance.ref("PresentStudentData").child(todayDate);
        
        // Store present students' data
        await ref.set({
          'presentStudents': presentStudents,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Present students data added to Database')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No students present today')),
        );
      }
    } catch (e) {
      print("Error while adding present students: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add present students')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudents(); // Fetch data when the screen initializes
  }

  // Filter the students list based on the search query
  void filterStudents(String query) {
    final filtered = students.where((student) {
      final name = student['name'].toLowerCase();
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    setState(() {
      filteredStudents = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Mark Attendance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: addPresentStudents, // Add present students to Firebase on button press
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search by name",
                border: OutlineInputBorder(),
              ),
              onChanged: filterStudents, // Filter students as user types
            ),
          ),
          filteredStudents.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return Card(
                        margin: const EdgeInsets.all(12.0),
                        child: ListTile(
                          title: Text(
                            student['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Class: ${student['class']}, ID: ${student['idNumber']}"),
                          trailing: IconButton(
                            icon: Icon(
                              student['isPresent'] ? Icons.check_circle : Icons.check_circle_outline,
                              color: student['isPresent'] ? Colors.green : Colors.grey,
                            ),
                            onPressed: student['isPresent']
                                ? null // Disable the button if attendance is already marked
                                : () {
                                    markAttendance(student['id']);
                                  },
                          ),
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
