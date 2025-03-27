import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
// import 'package:week_3_blabla_project/repository/rides_repository.dart';

class RidesPrefProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPrefProvider({required this.repository}) {
    _fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

// Fetch past preferences from the repository
  void _fetchPastPreferences() async {
    final List<RidePreference> fetchedPreferences =
        await repository.getPastPreferences();
    _pastPreferences.addAll(fetchedPreferences);
    notifyListeners();
  }

  // Set current preference and add the previous one to history
  void setCurrentPreferrence(RidePreference pref) {
    if (_currentPreference != null) {
      _addPreference(_currentPreference!);
    }
    _currentPreference = pref;
    notifyListeners();
  }

// Add a preference to history
  void _addPreference(RidePreference preference) {
    _pastPreferences.add(preference);
    notifyListeners();
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
