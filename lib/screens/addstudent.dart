import 'package:flutter/material.dart';
import 'package:librarymanagement/services/firebaseservices.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Controllers for input fields
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rollNoController = TextEditingController();
    final TextEditingController idController = TextEditingController();
    final TextEditingController classController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Add Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the student's name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: "ID",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the ID";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: classController,
                  decoration: const InputDecoration(
                    labelText: "Class",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the class";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FirebaseServices.AddUserToDatabase(nameController.text.toString(),idController.text.toString(),classController.text.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Student added successfully!")),
                        );
          
                        // Clear the fields after submission
                        nameController.clear();
                        rollNoController.clear();
                        idController.clear();
                        classController.clear();
                      }
                    },
                    child: const Text(
                      "Add Student",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
