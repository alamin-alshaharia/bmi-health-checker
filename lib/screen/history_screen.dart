import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bmi_health_checker/ads/banner_ad_manager.dart';
import 'bmi_history_graph.dart'; // Import the new graph screen

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _savedResults;
  late BannerAdManager _bannerAdManager;

  @override
  void initState() {
    super.initState();
    _savedResults = _loadSavedResults(); // Initialize saved results
    _bannerAdManager = BannerAdManager(); // Initialize the BannerAdManager
  }

  @override
  void dispose() {
    _bannerAdManager.dispose(); // Dispose of the BannerAdManager
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadSavedResults() async {
    final prefs = await SharedPreferences.getInstance();
    final savedResults = prefs.getStringList('bmi_results') ?? [];

    return savedResults
        .map((result) => jsonDecode(result) as Map<String, dynamic>)
        .toList()
        .reversed
        .toList(); // Show newest first
  }

  Future<void> _deleteHistoryEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final savedResults = prefs.getStringList('bmi_results') ?? [];

    // Remove the specific entry
    savedResults.removeAt(index);
    await prefs.setStringList(
        'bmi_results', savedResults); // Update the saved results

    // Reload the results only if the index is valid
    if (index < savedResults.length) {
      setState(() {
        _savedResults = _loadSavedResults(); // Reload the results
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History entry deleted')),
    );
  }

  Future<void> _deleteAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bmi_results'); // Clear the saved results
    setState(() {
      _savedResults = _loadSavedResults(); // Reload the results
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All history deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('BMI History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Show confirmation dialog before deleting all history
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete All History'),
                  content: const Text(
                      'Are you sure you want to delete all history?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              // If the user confirmed, delete all history
              if (shouldDelete == true) {
                await _deleteAllHistory();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BmiHistoryGraphScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildHistoryList()),
          _bannerAdManager.getAdWidget(),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _savedResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No saved results yet',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final result = snapshot.data![index];
            return GestureDetector(
              onLongPress: () async {
                // Show confirmation dialog before deleting a single entry
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete History Entry'),
                    content: const Text(
                        'Are you sure you want to delete this entry?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                // If the user confirmed, delete the specific entry
                if (shouldDelete == true) {
                  await _deleteHistoryEntry(index);
                }
              },
              child: Card(
                color: Colors.grey[850],
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    'BMI: ${result['bmi'].toStringAsFixed(1)} - ${result['status']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${DateTime.parse(result['date']).toString().split('.')[0]}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Gender: ${result['gender']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Height: ${result['height']} cm',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Weight: ${result['weight']} kg',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
