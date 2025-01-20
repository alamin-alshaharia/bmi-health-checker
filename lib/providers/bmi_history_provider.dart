import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/bmi_history_state.dart';

final bmiHistoryProvider =
    StateNotifierProvider<BmiHistoryNotifier, List<BmiHistoryEntry>>((ref) {
  return BmiHistoryNotifier();
});

class BmiHistoryNotifier extends StateNotifier<List<BmiHistoryEntry>> {
  BmiHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedResults = prefs.getStringList('bmi_results') ?? [];

    state = savedResults
        .map((str) => BmiHistoryEntry.fromJson(jsonDecode(str)))
        .toList()
        .reversed
        .toList();
  }

  Future<void> addEntry(BmiHistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final savedResults = prefs.getStringList('bmi_results') ?? [];

    savedResults.add(jsonEncode(entry.toJson()));
    await prefs.setStringList('bmi_results', savedResults);

    state = [entry, ...state];
  }

  Future<void> deleteEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final savedResults = prefs.getStringList('bmi_results') ?? [];

    if (index < savedResults.length) {
      savedResults.removeAt(savedResults.length - 1 - index);
      await prefs.setStringList('bmi_results', savedResults);

      state = [...state]..removeAt(index);
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bmi_results');
    state = [];
  }

  List<double> getBmiData() {
    return state.map((entry) => entry.bmi).toList();
  }

  List<String> getDateLabels() {
    return state
        .map((entry) => '${entry.date.day}/${entry.date.month}')
        .toList();
  }
}
