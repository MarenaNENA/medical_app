import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../Utiles/doctor_model.dart';
import '../../providers/doctor_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  String? selectedCategory;
  String userName = "";
  int unreadCount = 0;
  StreamSubscription? notificationSubscription;

  @override
  void initState() {
    super.initState();
    Provider.of<DoctorProvider>(context, listen: false).fetchDoctors();
    getUserName();
    listenToNotifications();
  }

  void listenToNotifications() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    notificationSubscription = FirebaseFirestore.instance
        .collection('notifications')
        .where('patientId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      final count = snapshot.docs.where((doc) => !(doc['isRead'] ?? false)).length;
      setState(() {
        unreadCount = count;
      });
    });
  }

  Future<void> getUserName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      setState(() {
        userName = userDoc.data()?['firstName'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    List<Doctor> doctors = doctorProvider.doctors;

    final List<Map<String, String>> categoriesWithIcons = [
      {
        'name': 'Doctors Accepted'.tr,
        'iconUrl': 'asset/image/apppved.jpg',
      },
      {
        'name': 'Cardiology'.tr,
        'iconUrl': 'asset/image/Cardiology.webp',
      },
      {
        'name': 'Neurology'.tr,
        'iconUrl': 'asset/image/images.jpg',
      },
      {
        'name': 'Pediatrics'.tr,
        'iconUrl': 'asset/image/baby.jpeg',
      },
      {
        'name': 'Orthopedics'.tr,
        'iconUrl': 'asset/image/Orthopedics-1-1.png',
      },
      {
        'name': 'Oncology'.tr,
        'iconUrl': 'asset/image/Oncology.jpg',
      },
      {
        'name': 'Radiology'.tr,
        'iconUrl': 'asset/image/Radiology.jpg',
      },
      {
        'name': 'Internal Medicine'.tr,
        'iconUrl': 'asset/image/Interna_ Medicine.jpg',
      },
      {
        'name': 'General Surgery'.tr,
        'iconUrl': 'asset/image/General Surgery.jpg',
      },
      {
        'name': 'Dermatology'.tr,
        'iconUrl': 'asset/image/Dermatology.jpg',
      },
      {
        'name': 'Psychiatry'.tr,
        'iconUrl': 'asset/image/Psychiatry.webp',
      },
      {
        'name': 'Ophthalmology'.tr,
        'iconUrl': 'asset/image/Ophthalmology.jpg',
      },
      {
        'name': 'ENT'.tr,
        'iconUrl': 'asset/image/ENT.jpg',
      },
      {
        'name': 'Gynecology'.tr,
        'iconUrl': 'asset/image/Gynecology.jpg',
      },
      {
        'name': 'Urology'.tr,
        'iconUrl': 'asset/image/Urology.jpg',
      },
      {
        'name': 'Anesthesiology'.tr,
        'iconUrl': 'asset/image/Anesthesiology.jpg',
      },
      {
        'name': 'Family Medicine'.tr,
        'iconUrl': 'asset/image/Family Medicine.jpg',
      },
      {
        'name': 'Emergency Medicine'.tr,
        'iconUrl': 'asset/image/Emergency Medicine.jpg',
      },
    ];

    List<Doctor> filteredDoctors = doctors;
    if (selectedCategory != null && selectedCategory != "Doctors Accepted") {
      filteredDoctors = doctors.where((doc) => doc.specialization == selectedCategory).toList();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText('welcome,'.tr,
                    style: TextStyle(color: Colors.white70, fontSize: 23),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                AutoSizeText(userName.isNotEmpty ? userName : "",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesWithIcons.length,
              itemBuilder: (context, index) {
                final category = categoriesWithIcons[index];
                final isSelected = selectedCategory == category['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = isSelected ? null : category['name'];
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pinkAccent : Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        category['iconUrl']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: doctorProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
      : selectedCategory == null
          ? Center(
              child: Text(
                "Please select a category".tr,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
                : ListView.builder(
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('appointments')
                            .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .where('doctorId', isEqualTo: doctor.id)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox();
                          }
                          if (snapshot.hasError) {
                            return Text('Error loading appointment'.tr);
                          }

                          final docs = snapshot.data!.docs;

                          // فلترة دكاترة "Doctors Accepted"
                          if (selectedCategory == "Doctors Accepted") {
                            if (docs.isEmpty || docs.first['status'] != 'accepted') {
                              return const SizedBox();
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doctor.name ?? '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(doctor.specialization ?? '',
                                        style: const TextStyle(color: Colors.white70)),
                                    const SizedBox(height: 12),
                               if (docs.isEmpty || docs.first['status'] == 'cancelled')
                                          ElevatedButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance.collection('appointments').add({
                                                'patientId': FirebaseAuth.instance.currentUser!.uid,
                                                'doctorId': doctor.id,
                                                'status': 'booked',
                                                'timestamp': FieldValue.serverTimestamp(),
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Appointment booked successfully".tr)),
                                              );
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                            child: Text('Make Appointment'.tr),
                                          )
                                        else if (docs.first['status'] == 'booked')
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: null,
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                                child: Text(
                                                  'Booked'.tr,
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await docs.first.reference.delete();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("Appointment cancelled successfully".tr),
                                                    ),
                                                  );
                                                  setState(() {});
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                child: Text('Cancel'.tr),
                                              ),
                                            ],
                                          )
                                        else if (docs.first['status'] == 'accepted')
                                          ElevatedButton(
                                            onPressed: null,
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                            child: Text(
                                              'Accepted'.tr,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          )
                                        else
                                          ElevatedButton(
                                            onPressed: null,
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                            child: Text(
                                              docs.first['status'].toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ]),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/notification');
              listenToNotifications();
            },
            backgroundColor: Colors.pinkAccent,
            child: const Icon(Icons.notifications_active),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    notificationSubscription?.cancel();
    super.dispose();
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
}