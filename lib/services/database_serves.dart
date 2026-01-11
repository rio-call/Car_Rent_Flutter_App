import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  //  a reference to the root of Firebase Realtime Database.
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  //create or update data
  // replacing any existing data at that node.



  Future<void> saveData(String path, Map<String, dynamic> data) async {
    await _dbRef.child(path).set(data);
  }
// read data from a specific path if it exists or return null
  Future<DataSnapshot?> getData(String path) async {
    final snapshot = await _dbRef.child(path).get();
    return snapshot.exists ? snapshot : null;
  }
// Updates only the specified fields at the given path (does not overwrite the whole node).
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await _dbRef.child(path).update(data);
  }



// deletes the entire node from the database.
  Future<void> deleteData(String path) async {
    await _dbRef.child(path).remove();
  }

}
