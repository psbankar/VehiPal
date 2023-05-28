import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vehipal/VehicleEntry.dart';
import 'package:vehipal/dashboard.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Obtain the auth details from the Google sign-in
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential using the obtained auth details
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the credential
        final UserCredential? userCredential = await _auth.signInWithCredential(credential);

        if (userCredential != null) {
          // User is successfully authenticated

          // Check if the user has already filled out their profile
          final DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (!snapshot.exists) {
            // Create a new Firestore entry with basic metadata and default values

            // Define the initial data for the user
            Map<String, dynamic> userData = {
              'accountCreated': Timestamp.now(),
              'vehicleArray': [],
              'banned': false,
              'helpfulVotes': 0,
              'unhelpfulVotes': 0
              // Add other default fields and values as needed
            };

            // Create a new document in the 'users' collection using the user's UID
            await FirebaseFirestore.instance
                .collection('users').doc(userCredential.user!.uid).set(
                userData).then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardPage(),
              ),
            ));
          }
        }
      }
    } catch (e) {
      // Handle sign-in errors
      print('Error signing in with Google: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large app logo
            Image.asset(
              'assets/app_logo.png',
              width: 120.0,
              height: 120.0,
            ),
            SizedBox(height: 16.0),
            // App name
            Text(
              'Your App Name',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32.0),
            // Google sign-in button
            ElevatedButton.icon(
              onPressed: () => _signInWithGoogle(context),
              icon: Icon(Icons.login),
              label: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
