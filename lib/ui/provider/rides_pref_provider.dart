import 'package:flutter/material.dart';
import '../../model/ride/ride_pref.dart';
import '../../ui/provider/async_value.dart';
import '../../data/repository/ride_preferences_repository.dart';
// import 'package:week_3_blabla_project/repository/rides_repository.dart';

class RidesPrefProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences = AsyncValue.loading();

  final RidePreferencesRepository repository;

  RidesPrefProvider({required this.repository}) {
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

// Fetch past preferences from the repository
  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      final pastPrefs = await repository.getPastPreferences();
      pastPreferences = AsyncValue.success(pastPrefs);
    } catch (e) {
      pastPreferences = AsyncValue.error(e);
    }
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
  Future<void> _addPreference(RidePreference preference) async {
    try {
      await repository.addPreference(preference);
      pastPreferences.data?.add(preference);
    } catch (e) {
      pastPreferences = AsyncValue.error(e);
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory {
    return pastPreferences.data?.reversed.toList() ?? [];
  }
}
