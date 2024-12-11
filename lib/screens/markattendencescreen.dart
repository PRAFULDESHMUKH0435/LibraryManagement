import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  List<Map<dynamic, dynamic>> students = [];
  List<Map<dynamic, dynamic>> filteredStudents = [];
  TextEditingController searchController = TextEditingController();
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int presentCount = 0;

  // Fetch students from the database
  Future<void> fetchStudents({String? date}) async {
    try {
      final ref = FirebaseDatabase.instance.ref("CollegeDatabase");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final studentsData = snapshot.value as Map<dynamic, dynamic>;

        students.clear();
        studentsData.forEach((key, value) {
          students.add({
            'id': key,
            'name': value['Name'] ?? 'N/A',
            'class': value['Class'] ?? 'N/A',
            'idNumber': value['Id'] ?? 'N/A',
            'isPresent': false, // Default all to absent for the selected date
          });
        });

        filteredStudents = List.from(students);
        updatePresentCount();
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
    setState(() {
      final student = filteredStudents.firstWhere((student) => student['id'] == studentId);
      student['isPresent'] = true;
    });
    updatePresentCount();
  }

  // Update present student count
  void updatePresentCount() {
    setState(() {
      presentCount = filteredStudents.where((student) => student['isPresent']).length;
    });
  }

  // Save present students to Firebase
  Future<void> savePresentStudents() async {
    final confirmSave = await _showSaveAttendanceDialog();

    if (confirmSave) {
      try {
        final presentStudents = filteredStudents.where((student) => student['isPresent']).toList();

        if (presentStudents.isNotEmpty) {
          final ref = FirebaseDatabase.instance.ref("PresentStudentData").child(selectedDate);

          await ref.set({'presentStudents': presentStudents});

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
  }

  // Show dialog to confirm attendance save
  Future<bool> _showSaveAttendanceDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Save"),
            content: Text("Do you want to save attendance for the date: $selectedDate?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Save"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    fetchStudents(); // Fetch data for today
  }

  // Filter students by name
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

  // Select date and refresh student data
  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
      fetchStudents(date: selectedDate); // Fetch data for the selected date
    }
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
            onPressed: savePresentStudents,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: "Search by name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: filterStudents,
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => selectDate(context),
                  child: Text(selectedDate),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Present Students:", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  Text("$presentCount", style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          filteredStudents.isEmpty
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
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
                                ? null
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
