import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popluk/services/user_service.dart';
import 'package:intl/intl.dart';

class SignupQuestionsPage extends StatefulWidget {
  const SignupQuestionsPage({super.key});

  @override
  State<SignupQuestionsPage> createState() => _SignupQuestionsPageState();
}

class _SignupQuestionsPageState extends State<SignupQuestionsPage> {
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  int _currentPage = 0;

  // เก็บค่าคำตอบ
  String fullName = '';
  String email = '';
  String password = '';
  String gender = 'male';
  DateTime? birthDate;
  String location = 'Bangkok, Thailand';
  double latitude = 13.7563;
  double longitude = 100.5018;
  String lookingForGender = 'female';

  final UserService _userService = UserService();

  //เมื่อมีการเออเร่อ
  String? birthDateError;

  void nextPage() {
    if (_formKey.currentState!.validate()) {
      // ตรวจสอบวันเกิด
      if (_currentPage == 4) {
        // ตรวจสอบเฉพาะหน้า "วันเกิด"
        if (birthDate == null) {
          setState(() {
            birthDateError = 'กรุณาเลือกวันเกิด';
          });
          return;
        }
        final error = _validateBirthDate(birthDate!);
        if (error != null) {
          setState(() {
            birthDateError = error;
          });
          return;
        }
      }

      if (_currentPage < 6) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submit();
      }
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submit() async {
    if (birthDate == null) return;

    final result = await _userService.signUp(
      fullName: fullName,
      email: email,
      password: password,
      gender: gender,
      birthDate: birthDate!,
      location: location,
      latitude: latitude,
      longitude: longitude,
      lookingForGender: lookingForGender,
    );

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')));
      // TODO: ไปหน้าหลัก
      context.go('/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  String? _validateNotEmpty(String? val, String fieldName) {
    if (val == null || val.isEmpty) {
      return 'กรุณากรอก$fieldName';
    }
    return null;
  }

  String? _validateEmail(String? val) {
    if (val == null || val.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    if (!RegExp(r"^[\w\.-]+@([\w-]+\.)+[\w-]{2,10}$").hasMatch(val)) {
      return 'กรุณากรอกอีเมลให้ถูกต้อง';
    }
    return null;
  }

  // ฟังก์ชันตรวจสอบวันเกิด (อายุมากกว่า 18 ปี)
  String? _validateBirthDate(DateTime date) {
    final today = DateTime.now();
    final age =
        today.year -
        date.year -
        (today.month < date.month ||
                (today.month == date.month && today.day < date.day)
            ? 1
            : 0);
    if (age < 18) {
      return 'คุณต้องมีอายุอย่างน้อย 18 ปี';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            buildQuestion(
              question: 'คุณชื่ออะไร?',
              child: TextFormField(
                onChanged: (val) => fullName = val,
                validator: (val) => _validateNotEmpty(val, 'ชื่อ'),
                decoration: const InputDecoration(hintText: 'ชื่อ - นามสกุล'),
              ),
            ),
            buildQuestion(
              question: 'อีเมลของคุณ?',
              child: TextFormField(
                onChanged: (val) => email = val,
                validator: _validateEmail,
                decoration: const InputDecoration(
                  hintText: 'example@email.com',
                ),
              ),
            ),
            buildQuestion(
              question: 'รหัสผ่านที่คุณต้องการ',
              child: TextFormField(
                obscureText: true,
                onChanged: (val) => password = val,
                validator:
                    (val) =>
                        val != null && val.length >= 6
                            ? null
                            : 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร',
                decoration: const InputDecoration(
                  hintText: 'อย่างน้อย 6 ตัวอักษร',
                ),
              ),
            ),
            buildQuestion(
              question: 'คุณเป็นเพศอะไร?',
              child: DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('ชาย')),
                  DropdownMenuItem(value: 'female', child: Text('หญิง')),
                ],
                onChanged: (val) => setState(() => gender = val!),
                validator: (val) => val == null ? 'กรุณาเลือกเพศ' : null,
                decoration: const InputDecoration(),
              ),
            ),
            buildQuestion(
              question: 'คุณเกิดวันที่เท่าไหร่ ?',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          birthDate = date;
                          birthDateError = _validateBirthDate(date);
                        });
                      }
                    },
                    child: Text(
                      birthDate == null
                          ? 'เลือกวันเกิด'
                          : DateFormat('dd MMM yyyy').format(birthDate!),
                    ),
                  ),
                  if (birthDateError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        birthDateError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),

            buildQuestion(
              question: 'คุณกำลังมองหาเพศไหน?',
              child: DropdownButtonFormField<String>(
                value: lookingForGender,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('ทุกเพศ')),
                  DropdownMenuItem(value: 'male', child: Text('ชาย')),
                  DropdownMenuItem(value: 'female', child: Text('หญิง')),
                ],
                onChanged: (val) => setState(() => lookingForGender = val!),
                decoration: const InputDecoration(),
              ),
            ),
            buildQuestion(
              question: 'ยืนยันการสมัครสมาชิก',
              child: Text('คุณพร้อมที่จะหาคนที่รู้ใจแล้วหรือยัง?'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion({required String question, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          child,
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                OutlinedButton(
                  onPressed: previousPage,
                  child: const Text('ย้อนกลับ'),
                ),
              ElevatedButton(
                onPressed: nextPage,
                child: Text(_currentPage < 6 ? 'ถัดไป' : 'ยืนยัน'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
