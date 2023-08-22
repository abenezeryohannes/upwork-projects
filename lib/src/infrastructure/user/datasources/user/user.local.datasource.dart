import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:linko/src/appcore/errors/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain/user/entities/user.entity.dart';

@lazySingleton
class UserLocalDataSource {
  late SharedPreferences cache;
  UserLocalDataSource({required this.cache});
  static String USER_KEY = "USER_KEY";

  Future<UserEntity>? loadUser() async {
    final data = cache.getString(USER_KEY);
    if (data == null) throw CacheFailure(message: "Not logged in yet!");
    return UserEntity.fromJson(json.decode(data));
  }

  Future<bool>? saveUser(UserEntity user) async {
    return await cache.setString(USER_KEY, json.encode(user));
  }

  Future<bool>? removeUser() async {
    return await cache.remove(USER_KEY);
  }
}