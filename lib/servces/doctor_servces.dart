import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mdicalapp_1/Utiles/doctor_model.dart';

class DoctorService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<Doctor>> fetchDoctors() async {
    try {
      QuerySnapshot snapshot = await _usersCollection
          .where('userType', isEqualTo: 'Doctor')
          .get();

      List<Doctor> doctors = snapshot.docs.map((doc) {
        return Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return doctors;
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }
}
