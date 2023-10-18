import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Result extends StatelessWidget {
  const Result(
      {super.key, required this.displayName, required this.displayEmail});
  final String displayName;
  final String displayEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 300),
          child: Column(
            children: [
              Text(
                'Họ và tên: $displayName',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Email sử dụng: $displayEmail',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  GoogleSignIn().signOut();
                  Navigator.pop(context);
                },
                child: const Text("Google Log Out"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
