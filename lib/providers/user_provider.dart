import 'package:flutter/material.dart';
import 'package:popluk/models/user_model.dart';
import 'package:popluk/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final _userService = UserService();

  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  //ดึงข้อมูลมาเก็บไว้ที่หน้าหน้าแก้ไขข้อมูล
  Future<void> loadUser() async{
    _isLoading = true;
    notifyListeners();

    _user = await _userService.getUserProfile();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserProfile(UserModel updateUser) async{
    await _userService.updateUserProfile(updateUser);
    _user = updateUser;
    notifyListeners();
  }
}