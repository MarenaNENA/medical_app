import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NotificationssScreen extends StatefulWidget {
  const NotificationssScreen({super.key});

  @override
  State<NotificationssScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationssScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // تم حذف _markAfterDelay
  }

  // تم حذف markNotificationsAsRead و _markAfterDelay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Notifications".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('patientId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No notifications yet.".tr,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final message = data['body'] ?? '';
              final timestamp = data['timestamp'] as Timestamp?;
              final time = timestamp?.toDate();

              return ListTile(
                leading:
                    const Icon(Icons.notifications, color: Colors.orangeAccent),
                title: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  time != null ? '${time.toLocal()}' : '',
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
