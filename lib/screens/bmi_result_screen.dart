import 'package:flutter/material.dart';

class BMIResultScreen extends StatelessWidget {
  final double bmi;
  final String weightStatus;
  final double minHealthyWeight;
  final double maxHealthyWeight;
  final double ponderalIndex;

  const BMIResultScreen({
    Key? key,
    required this.bmi,
    required this.weightStatus,
    required this.minHealthyWeight,
    required this.maxHealthyWeight,
    required this.ponderalIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.cyan),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'YOUR Summary',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // BMI Result Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your BMI is',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'kg/m2',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BMI Scale indicator
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.green,
                            Colors.yellow,
                            Colors.orange,
                            Colors.red,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Your weight is ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          weightStatus,
                          style: const TextStyle(
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Healthy BMI range: 18.5 kg/m2 - 25 kg/m2',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      'Healthy weight for that height: ${minHealthyWeight.toStringAsFixed(1)}kgs - ${maxHealthyWeight.toStringAsFixed(1)}kgs',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      'Ponderal Index: ${ponderalIndex.toStringAsFixed(1)} kg/m3',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Bottom action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.cyan),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.save_alt, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
