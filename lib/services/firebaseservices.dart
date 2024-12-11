import 'dart:math';
import 'package:firebase_database/firebase_database.dart';

class FirebaseServices {
  static void AddUserToDatabase(
      String studentname, String studentid, String studentclass) async {
    print("Inside AddUsertodatabase");
    Random random = Random();
    String id = random.nextInt(10000).toString();
    try {
      Map<String, String> user = {
        "Name": studentname,
        "Id": studentid,
        "Class": studentclass,
      };
      final res = FirebaseDatabase.instance.ref("CollegeDatabase");
      res
          .push()
          .set(user) // Automatically generates a unique ID.
          .then((value) {
        print("Data saved successfully");
      }).catchError((error) {
        print("Error: $error");
      });
    } catch (e) {
      print("Exception : $e");
    }
  }
}
