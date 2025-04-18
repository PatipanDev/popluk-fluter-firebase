import 'package:flutter/material.dart';
import 'package:popluk/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController fullNameController;
  late TextEditingController bioController;
  late TextEditingController jobTitleController;
  late TextEditingController educationController;
  late TextEditingController birthDateController;

  bool isInitialized = false;
  bool isUpdating = false; // สถานะ loading

  //เรียกเมื่อสร้าง widget ครั้งแรก
  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    bioController = TextEditingController();
    jobTitleController = TextEditingController();
    educationController = TextEditingController();
    birthDateController = TextEditingController();
  }

  //เรียกหลังเพื่อเซ็ตค่าลงไป
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    // ถ้ายังไม่ได้เซ็ตค่าจาก user และ user โหลดเสร็จแล้ว
    if (!isInitialized && !userProvider.isLoading && user != null) {
      fullNameController.text = user.fullName ?? '';
      bioController.text = user.bio ?? '';
      jobTitleController.text = user.jobTitle ?? '';
      educationController.text = user.education ?? '';
      birthDateController.text =
          user.birthDate != null
              ? DateFormat('dd-MM-yyyy').format(user.birthDate!)
              : '';
      isInitialized = true;
    }
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

  Future<void> confirmUpdateProfile() async {
  // แสดง Dialog ให้ผู้ใช้ยืนยันก่อน
  final shouldUpdate = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('ยืนยันการอัปเดตข้อมูล'),
        content: const Text('คุณต้องการอัปเดตข้อมูลโปรไฟล์ของคุณหรือไม่?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // ผู้ใช้เลือกไม่อัปเดต
            },
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // ผู้ใช้เลือกอัปเดต
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      );
    },
  );

  if (shouldUpdate ?? false) {
    // ถ้าผู้ใช้ยืนยันให้ทำการอัปเดตข้อมูล
    await updateProfile();
  }
}


  //ทำการบันทึกข้อมูล
  Future<void> updateProfile() async {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;

    final updatedUser = user?.copyWith(
      fullName: fullNameController.text,
      bio: bioController.text,
      jobTitle: jobTitleController.text,
      education: educationController.text,
      birthDate: DateFormat('dd-MM-yyyy').parse(birthDateController.text),
    );

    if (updatedUser != null) {
      setState(() => isUpdating = true);
      try {
        await userProvider.updateUserProfile(updatedUser);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('อัปเดตข้อมูลสำเร็จ')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      } finally {
        if (mounted) setState(() => isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final isLoading = userProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขโปรไฟล์')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: fullNameController,
                      decoration: const InputDecoration(labelText: 'ชื่อเต็ม'),
                    ),
                    TextField(
                      controller: bioController,
                      decoration: const InputDecoration(labelText: 'แนะนำตัว'),
                    ),
                    TextField(
                      controller: jobTitleController,
                      decoration: const InputDecoration(labelText: 'อาชีพ'),
                    ),
                    TextField(
                      controller: educationController,
                      decoration: const InputDecoration(labelText: 'การศึกษา'),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(
                            const Duration(days: 365 * 18),
                          ),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            birthDateController.text = DateFormat(
                              'dd-MM-yyyy',
                            ).format(pickedDate);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: birthDateController,
                          decoration: const InputDecoration(
                            labelText: 'วันเกิด',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isUpdating ? null : confirmUpdateProfile,
                      child:
                          isUpdating
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('บันทึก'),
                    ),
                  ],
                ),
              ),
    );
  }
}
