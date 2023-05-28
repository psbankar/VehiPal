// TODO: Create screens and implement functionalities

// Onboarding Screens
// - Welcome Screen
// - Introduction to the App
// - Sign In/Sign Up Options

// Registration and Profile Setup
// - User Registration Form
// - Profile Picture Upload
// - Personal Information Input
// - Vehicle Information Input

// Home Screen
// - Dashboard with key information and alerts
// - Quick Actions or Shortcuts

// Vehicle Registration
// - Option to register a new vehicle
// - Vehicle Details Form
// - QR Code/NFC Tag Setup

// Scan QR Code/NFC
// - Camera screen to scan QR code or tap NFC tag
// - Verification process for scanned vehicles

// Vehicle Details
// - Detailed information about the scanned vehicle
// - Option to contact the vehicle owner

// Report Issues
// - Categories for reporting different issues
// - Form to provide additional details and submit the report

// Notifications and Alerts
// - Real-time notifications and alerts related to vehicle status or reported issues

// Settings
// - User preferences
// - Account settings

// Help and Support
// - Frequently Asked Questions (FAQs)
// - Contact information for customer support

// About
// - Information about the app, its purpose, and the development team

import 'package:flutter/material.dart';
import 'package:vehipal/VehicleEntry.dart';
import 'package:vehipal/dashboard.dart';
import 'package:vehipal/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: DashboardPage(),
    );
  }
}
