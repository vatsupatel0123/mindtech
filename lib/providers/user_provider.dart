import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/utils/shared_preference_utility.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:mindtech/models/user_model.dart';

class UserProvider with ChangeNotifier {
  String _name = "";
  String _photo = "";
  String _userType = "";

  String get name => _name;
  String get photo => _photo;
  String get userType => _userType;

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = await SharedPreferencesUtility.getString("userData");
    String? usertype = await SharedPreferencesUtility.getString("userType");
    print(usertype);
    print(AppString.statusUserType);

    if(usertype == AppString.statusUserType){
      if (userDataString != null && userDataString.isNotEmpty) {
        Map<String, dynamic> userDataMap = json.decode(userDataString);
        UserModel user = UserModel.fromJson(userDataMap);
        _name = user.fullName ?? 'Buddy';
        _photo = user.photo ?? '';
        _userType = usertype;
        notifyListeners();
      }
    }else{
      if (userDataString != null && userDataString.isNotEmpty) {
        Map<String, dynamic> userDataMap = json.decode(userDataString);
        ExpertModel user = ExpertModel.fromJson(userDataMap);
        print(user.expertName);
        _name = user.expertName ?? 'Expert';
        _photo = user.photo ?? "";
        _userType = usertype;
        notifyListeners();
      }
    }

  }

}
