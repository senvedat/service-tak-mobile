import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences? _preferences;

  LocalStorageService() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }
  static final LocalStorageService _instance = LocalStorageService();
  static LocalStorageService get instance => _instance;

  Future onInitialize() async {
    instance._preferences = await SharedPreferences.getInstance();
  }

  Future<void> setString(LocalStorageKeys key, String value) async {
    await _preferences!.setString(key.toString(), value);
  }

  Future<void> setInt(LocalStorageKeys key, int value) async {
    await _preferences!.setInt(key.toString(), value);
  }

  Future<void> setStringList(LocalStorageKeys key, List<String> value) async {
    await _preferences!.setStringList(key.toString(), value);
  }

  Future<void> setBool(LocalStorageKeys key, value) async {
    await _preferences!.setBool(key.toString(), value);
  }

  String  getString(LocalStorageKeys key) =>
      _preferences!.getString(key.toString()) ?? '';

  int getInt(LocalStorageKeys key) => _preferences!.getInt(key.toString()) ?? 0;

  List<String> getStringList(LocalStorageKeys key) =>
      _preferences!.getStringList(key.toString()) ?? [];

  bool getBool(LocalStorageKeys key) =>
      _preferences!.getBool(key.toString()) ?? false;

  void clear() {
    _preferences!.clear();
  }

  Future<void> deleteItem(LocalStorageKeys key) =>
      _preferences!.remove(key.toString());

  Future<void> allItemClear() async {
    try {
      for (var key in LocalStorageKeys.values) {
        LocalStorageService.instance.deleteItem(key);
      }
      true;
    } catch (e) {
      debugPrint("allItemClear Error!");
      debugPrint(e.toString());
      false;
    }
  }
}
