import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popluk/theme/colors.dart';


class LogInOrSignUpPage extends StatelessWidget {
  const LogInOrSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔶 โลโก้
                Image.asset(
                  'assets/icon/icon.png', // เปลี่ยนตามชื่อไฟล์ของคุณ
                  height: 300,
                ),
                const SizedBox(height: 200),

                // 🔷 ปุ่มเข้าสู่ระบบ
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: ทำการเข้าสู่ระบบ
                      context.push('/login_page');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18, color: AppColors.primary),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 ปุ่มสมัครสมาชิก
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: ไปหน้าสมัครสมาชิก
                      context.push('/signup_page');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.fontcolor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: AppColors.fontcolor),
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
