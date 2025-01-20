import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bmi_health_checker/ads/banner_ad_manager.dart';
import 'bmi_history_graph.dart'; // Import the new graph screen
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bmi_health_checker/providers/bmi_history_provider.dart';
import 'package:bmi_health_checker/models/bmi_history_state.dart';
import '../providers/ad_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends ConsumerWidget {
  static const String screenId = 'history_screen';

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(bmiHistoryProvider);
    final historyNotifier = ref.read(bmiHistoryProvider.notifier);
    final bannerAdManager = ref.watch(bannerAdProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.r),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24.r,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: Text(
          'BMI History',
          style: TextStyle(fontSize: 20.sp),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, size: 24.r),
            onPressed: () async {
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

              if (shouldDelete == true) {
                await historyNotifier.clearHistory();
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.r),
            child: IconButton(
              icon: Icon(
                Icons.show_chart,
                size: 30.r,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BmiHistoryGraphScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: history.isEmpty
                ? Center(
                    child: Text(
                      'No saved results yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      return GestureDetector(
                        onLongPress: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete History Entry'),
                              content: const Text(
                                  'Are you sure you want to delete this entry?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true) {
                            await historyNotifier.deleteEntry(index);
                          }
                        },
                        child: _buildHistoryCard(entry),
                      );
                    },
                  ),
          ),
          bannerAdManager.getAdWidget(screenId),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BmiHistoryGraphScreen(),
            ),
          );
        },
        backgroundColor: Colors.purple,
        tooltip: 'View BMI Graph',
        child: Icon(
          Icons.show_chart,
          size: 30.r,
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BmiHistoryEntry entry) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListTile(
        title: Text(
          'BMI: ${entry.bmi.toStringAsFixed(1)} - ${entry.status}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${entry.date.toString().split('.')[0]}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
            Text(
              'Gender: ${entry.gender}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
            Text(
              'Height: ${entry.height} cm',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
            Text(
              'Weight: ${entry.weight} kg',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
