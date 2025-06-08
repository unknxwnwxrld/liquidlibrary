import 'package:flutter/material.dart';


class InstanceSources extends StatelessWidget {
  final String label;
  final IconData icon;

  const InstanceSources({
    super.key,
    required this.label,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0), // Margin around the card
      child: SizedBox(
        height: 150.0,
        width: 150.0, // Fixed height for the card
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              // Handle tap action
            },
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 36.0, // Icon size
                    ),
                    SizedBox(height: 8.0), // Space between icon and text
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}