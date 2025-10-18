import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  String userName = "";
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchDoctorName();
  }

  void fetchDoctorName() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (doc.exists) {
      final data = doc.data();
      setState(() {
        userName = data?['firstName'] ?? "";
      });
    }
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e".tr)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // عندنا تابين
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: Row(
            children: [
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText('welcome,'.tr,
                      style: const TextStyle(color: Colors.white70, fontSize: 25),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  AutoSizeText(
                      userName.isNotEmpty ? 'Dr.$userName' : "",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              )
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => logout(context),
            ),
            IconButton(
        icon: const Icon(Icons.language, color: Colors.white),
        onPressed: () {
          // تغيير اللغة فورًا
          if (Get.locale?.languageCode == 'en') {
            Get.updateLocale(Locale('ar'));
          } else {
            Get.updateLocale(Locale('en'));
          }
        },
        tooltip: 'Language'.tr, // لو حابب Tooltip
      ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'New Appointments'.tr),
              Tab(text: 'Accepted'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildAppointmentsList('booked'),
            buildAppointmentsList('accepted'),
          ],
        ),
      ),
    );
  }

  Widget buildAppointmentsList(String statusFilter) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId', isEqualTo: currentUserId)
            .where('status', isEqualTo: statusFilter)
            .snapshots(),
        builder: (context, appointmentSnapshot) {
          if (appointmentSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointmentDocs = appointmentSnapshot.data!.docs;

          if (appointmentDocs.isEmpty) {
            return Center(
              child: Text(
                statusFilter == 'booked'
                    ? 'No new appointments yet'.tr
                    : 'No accepted appointments'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: appointmentDocs.length,
            itemBuilder: (context, index) {
              final appointment = appointmentDocs[index];
              final patientId = appointment['patientId'];
              final appointmentId = appointment.id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(patientId)
                    .get(),
                builder: (context, patientSnapshot) {
                  if (!patientSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final patientData = patientSnapshot.data!.data() as Map<String, dynamic>;
                  final patientName = "${patientData['firstName']} ${patientData['lastName'] ?? ''}";
                  final medicalRecord = patientData['medicalRecord'] ?? 'Not Provided';
                  final medicine = patientData['medicineTaken'] ?? 'Not Provided';

                  return Card(
                    margin: const EdgeInsets.all(10),
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: $patientName'.tr,
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text('Medical Record: $medicalRecord'.tr,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          Text('Medicine Taken: $medicine'.tr,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 12),
                          if (statusFilter == 'booked')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('appointments')
                                          .doc(appointmentId)
                                          .update({'status': 'accepted'});

                                      await FirebaseFirestore.instance.collection('notifications').add({
                                        'patientId': appointment['patientId'],
                                        'doctorName': userName,
                                        'status': 'accepted',
                                        'timestamp': FieldValue.serverTimestamp(),
                                        'body':
                                            'Your appointment has been accepted by Dr. $userName'.tr,
                                        'isRead': false,
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Appointment accepted ✅')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to accept appointment')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                                  child: Text('Accept'.tr),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('appointments')
                                        .doc(appointmentId)
                                        .update({'status': 'cancelled'});

                                    await FirebaseFirestore.instance.collection('notifications').add({
                                      'patientId': appointment['patientId'],
                                      'doctorName': userName,
                                      'status': 'cancelled',
                                      'timestamp': FieldValue.serverTimestamp(),
                                      'body':
                                          'Your appointment has been cancelled by Dr. $userName'.tr,
                                      'isRead': false,
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: Text('Cancel'.tr),
                                ),
                              ],
                            )
                          else
                            const Text(
                              'Accepted ✅',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
