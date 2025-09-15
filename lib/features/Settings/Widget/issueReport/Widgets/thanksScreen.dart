import 'package:flutter/material.dart';

class ThanksScreen extends StatefulWidget {
  const ThanksScreen({super.key});

  @override
  State<ThanksScreen> createState() => _ThanksScreenState();
}

class _ThanksScreenState extends State<ThanksScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 4 seconds, then pop back.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Prevent accidental back until auto-pop
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, size: 72),
              SizedBox(height: 16),
              Text(
                "Thanks!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "We’ve received your issue. We’ll take a look shortly.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
