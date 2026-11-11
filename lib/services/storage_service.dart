import 'dart:convert';

import 'package:presente/models/check_in.dart';
import 'package:presente/models/city.dart';
import 'package:presente/models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _skipOnboardingKey = 'skip_onboarding';
  static const String _contactsKey = 'contacts';
  static const String _checkInsKey = 'check_ins';
  static const String _cityKey = 'city_index';
  static const int _maxCheckIns = 200;

  Future<bool> shouldSkipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_skipOnboardingKey) ?? false;
  }

  Future<void> setSkipOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_skipOnboardingKey, value);
  }

  Future<List<Contact>> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_contactsKey);
    if (raw == null) {
      final defaults = List<Contact>.of(Contact.samples);
      await saveContacts(defaults);
      return defaults;
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => Contact.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return List<Contact>.of(Contact.samples);
    }
  }

  Future<void> saveContacts(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(contacts.map((c) => c.toJson()).toList());
    await prefs.setString(_contactsKey, encoded);
  }

  Future<List<CheckIn>> loadCheckIns() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_checkInsKey);
    if (raw == null) return <CheckIn>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => CheckIn.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return <CheckIn>[];
    }
  }

  Future<void> addCheckIn(CheckIn checkIn) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadCheckIns();
    all.add(checkIn);
    final trimmed = all.length > _maxCheckIns
        ? all.sublist(all.length - _maxCheckIns)
        : all;
    final encoded = jsonEncode(trimmed.map((c) => c.toJson()).toList());
    await prefs.setString(_checkInsKey, encoded);
  }

  Future<City> loadCity() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_cityKey) ?? 0;
    if (index < 0 || index >= City.capitals.length) {
      return City.capitals.first;
    }
    return City.capitals[index];
  }

  Future<void> saveCity(City city) async {
    final prefs = await SharedPreferences.getInstance();
    final index = City.capitals.indexOf(city);
    await prefs.setInt(_cityKey, index < 0 ? 0 : index);
  }
}
