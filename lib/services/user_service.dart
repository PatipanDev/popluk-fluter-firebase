import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
    required String gender,
    required DateTime birthDate,
    required String location,
    required double latitude,
    required double longitude,
    required String lookingForGender,
    int minPreferredAge = 18,
    int maxPreferredAge = 100,
    double preferredDistanceKm = 10.0,
  }) async {
    try {
      // สร้างผู้ใช้ ถ้าอีเมลซ้ำ จะ throw FirebaseAuthException
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) return 'ไม่สามารถสร้างผู้ใช้ได้';

      final newUser = UserModel(
        id: user.uid,
        fullName: fullName,
        email: email,
        phoneNumber: null,
        gender: gender,
        birthDate: birthDate,
        profilePictures: [],
        bio: null,
        interests: [],
        jobTitle: null,
        education: null,
        location: location,
        latitude: latitude,
        longitude: longitude,
        lookingForGender: lookingForGender,
        minPreferredAge: minPreferredAge,
        maxPreferredAge: maxPreferredAge,
        preferredDistanceKm: preferredDistanceKm,
        likedUserIds: [],
        likedByUserIds: [],
        matchedUserIds: [],
        blockedUserIds: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isOnline: false,
        userLevel: 'beginner',
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

      return null; // สำเร็จ
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'อีเมลนี้ถูกใช้งานไปแล้ว';
      }
      return e.message ?? 'เกิดข้อผิดพลาดในการสมัครสมาชิก';
    } catch (e) {
      return e.toString();
    }
  }
}
