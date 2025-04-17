import 'package:flutter/material.dart';
import 'package:popluk/services/user_service.dart'; // 👈 import service
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 👈 ต้อง import สำหรับ Timestamp

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userService = UserService();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userData = await userService.getUserProfile();
    if (userData != null) {
      fullNameController.text = userData['fullName'] ?? '';
      bioController.text = userData['bio'] ?? '';
      jobTitleController.text = userData['jobTitle'] ?? '';
      educationController.text = userData['education'] ?? '';

      // ✅ แปลง Timestamp -> DateTime -> String
      if (userData['birthDate'] != null && userData['birthDate'] is Timestamp) {
        final Timestamp birthTimestamp = userData['birthDate'];
        final DateTime birthDate = birthTimestamp.toDate();
        birthDateController.text = DateFormat('yyyy-MM-dd').format(birthDate);
      }
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    bioController.dispose();
    jobTitleController.dispose();
    educationController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขโปรไฟล์')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: fullNameController, decoration: const InputDecoration(labelText: 'ชื่อเต็ม')),
                  TextField(controller: bioController, decoration: const InputDecoration(labelText: 'แนะนำตัว')),
                  TextField(controller: jobTitleController, decoration: const InputDecoration(labelText: 'อาชีพ')),
                  TextField(controller: educationController, decoration: const InputDecoration(labelText: 'การศึกษา')),
                  TextField(controller: birthDateController, decoration: const InputDecoration(labelText: 'วันเกิด')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: เพิ่มปุ่มอัปเดต
                    },
                    child: const Text('บันทึก'),
                  ),
                ],
              ),
            ),
    );
  }
}
