import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:librarymanagement/models/studentmodel.dart';

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  List<StudentModel> students = [];

  /// Delete a user by ID from the database
  Future<void> deleteUser(String id) async {
    try {
      await FirebaseDatabase.instance.ref("CollegeDatabase").child(id).remove();
      // After deleting, fetch the updated user list
      fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully!')),
      );
    } catch (e) {
      print("Error while deleting: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete record.')),
      );
    }
  }

  /// Fetch users from the database and convert them to a list of StudentModel.
  Future<void> fetchUsers() async {
    try {
      // Get a reference to the database path
      final ref = FirebaseDatabase.instance.ref("CollegeDatabase");

      // Fetch the data snapshot
      final snapshot = await ref.get();

      // Clear the existing list before adding new data
      students.clear();

      // Check if the data exists
      if (snapshot.exists) {
        final users = snapshot.value as Map<dynamic, dynamic>;

        users.forEach((key, value) {
          // Convert each entry into a StudentModel and add it to the list
          students.add(StudentModel(
            id: key,
            studentname: value['Name'] ?? 'N/A',
            studentid: value['Id'] ?? 'N/A',
            studentclass: value['Class'] ?? 'N/A',
          ));
        });
        // Notify the framework that the state has changed
        setState(() {});
      } else {
        print("No users found in the database.");
      }
    } catch (e) {
      print("Error While Fetching: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch data when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("View Students"),
      ),
      body: students.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Container(
                  margin: const EdgeInsets.all(12.0),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      student.studentname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Class: ${student.studentclass}, ID: ${student.studentid}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        // Confirm deletion with a dialog before proceeding
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm Delete"),
                            content: const Text(
                                "Are you sure you want to delete this record?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  deleteUser(student.id);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
