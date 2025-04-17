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


  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
      if(userCredential.user == null){
        return 'ไม่พบผู้ใช้';
      }
      return null;
    }on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        return 'ไม่พบผู้ใช้งาน';
      }else if(e.code == 'wrong-password'){
        return 'รหัสผ่านไม่ถูกต้อง';
      }
      return e.message ?? 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
    }catch(e){
      return e.toString();
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return doc.data();
    } catch (e) {
      print('เกิดข้อผิดพลาดขณะโหลดข้อมูลผู้ใช้: $e');
      return null;
    }
  }
}
