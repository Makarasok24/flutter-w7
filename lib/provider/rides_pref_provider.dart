import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/rides_repository.dart';

class RidesPrefProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidesRepository repository;

  RidesPrefProvider({required this.repository}) {}

  RidePreference? get currentPreference => _currentPreference;
  void setCurrentPreferrence(RidePreference pref) {
    if (_currentPreference != null) {
      _addPreference(_currentPreference!);
    }
    _currentPreference = pref;
    notifyListeners();
  }

  void _addPreference(RidePreference preference) {
    _pastPreferences.add(preference);
    notifyListeners();
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
