// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String gender;
  final DateTime birthDate;
  final List<String> profilePictures;
  final String? bio;
  final List<String>? interests;
  final String? jobTitle;
  final String? education;
  final String location; // เช่น "Bangkok, Thailand"
  final double latitude;
  final double longitude;

  // Preferences
  final String lookingForGender;
  final int minPreferredAge;
  final int maxPreferredAge;
  final double preferredDistanceKm;

  // Matching system
  final List<String> likedUserIds;
  final List<String> likedByUserIds;
  final List<String> matchedUserIds;
  final List<String> blockedUserIds;

  // Other
  final DateTime createdAt;
  final DateTime updatedAt;

  // New fields
  final bool isOnline; // สถานะออนไลน์
  final String userLevel; // ระดับผู้ใช้ (เช่น "beginner", "intermediate", "advanced")

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.gender,
    required this.birthDate,
    required this.profilePictures,
    this.bio,
    this.interests,
    this.jobTitle,
    this.education,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.lookingForGender,
    required this.minPreferredAge,
    required this.maxPreferredAge,
    required this.preferredDistanceKm,
    required this.likedUserIds,
    required this.likedByUserIds,
    required this.matchedUserIds,
    required this.blockedUserIds,
    required this.createdAt,
    required this.updatedAt,
    required this.isOnline,
    required this.userLevel,
  });

  // Add copyWith method
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    DateTime? birthDate,
    List<String>? profilePictures,
    String? bio,
    List<String>? interests,
    String? jobTitle,
    String? education,
    String? location,
    double? latitude,
    double? longitude,
    String? lookingForGender,
    int? minPreferredAge,
    int? maxPreferredAge,
    double? preferredDistanceKm,
    List<String>? likedUserIds,
    List<String>? likedByUserIds,
    List<String>? matchedUserIds,
    List<String>? blockedUserIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOnline,
    String? userLevel,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      profilePictures: profilePictures ?? this.profilePictures,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      jobTitle: jobTitle ?? this.jobTitle,
      education: education ?? this.education,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lookingForGender: lookingForGender ?? this.lookingForGender,
      minPreferredAge: minPreferredAge ?? this.minPreferredAge,
      maxPreferredAge: maxPreferredAge ?? this.maxPreferredAge,
      preferredDistanceKm: preferredDistanceKm ?? this.preferredDistanceKm,
      likedUserIds: likedUserIds ?? this.likedUserIds,
      likedByUserIds: likedByUserIds ?? this.likedByUserIds,
      matchedUserIds: matchedUserIds ?? this.matchedUserIds,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOnline: isOnline ?? this.isOnline,
      userLevel: userLevel ?? this.userLevel,
    );
  }

  // Convert Firestore data into a UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return UserModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'],
      gender: data['gender'] ?? '',
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      profilePictures: List<String>.from(data['profilePictures'] ?? []),
      bio: data['bio'],
      interests: List<String>.from(data['interests'] ?? []),
      jobTitle: data['jobTitle'],
      education: data['education'],
      location: data['location'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      lookingForGender: data['lookingForGender'] ?? '',
      minPreferredAge: data['minPreferredAge'] ?? 18,
      maxPreferredAge: data['maxPreferredAge'] ?? 100,
      preferredDistanceKm: data['preferredDistanceKm'] ?? 10.0,
      likedUserIds: List<String>.from(data['likedUserIds'] ?? []),
      likedByUserIds: List<String>.from(data['likedByUserIds'] ?? []),
      matchedUserIds: List<String>.from(data['matchedUserIds'] ?? []),
      blockedUserIds: List<String>.from(data['blockedUserIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isOnline: data['isOnline'] ?? false, // สถานะออนไลน์
      userLevel: data['userLevel'] ?? 'beginner', // ระดับผู้ใช้
    );
  }

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'birthDate': Timestamp.fromDate(birthDate),
      'profilePictures': profilePictures,
      'bio': bio,
      'interests': interests,
      'jobTitle': jobTitle,
      'education': education,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'lookingForGender': lookingForGender,
      'minPreferredAge': minPreferredAge,
      'maxPreferredAge': maxPreferredAge,
      'preferredDistanceKm': preferredDistanceKm,
      'likedUserIds': likedUserIds,
      'likedByUserIds': likedByUserIds,
      'matchedUserIds': matchedUserIds,
      'blockedUserIds': blockedUserIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isOnline': isOnline, // บันทึกสถานะออนไลน์
      'userLevel': userLevel, // บันทึกระดับผู้ใช้
    };
  }

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
