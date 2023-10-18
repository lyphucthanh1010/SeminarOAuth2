import 'package:demo_seminar/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DemoOAuth2 extends StatelessWidget {
  const DemoOAuth2({super.key});
  // static String routeName = '/oauth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36.0),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Register Account",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 150),
                    const Text(
                      "Complete your details or continue \n with social media",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            signInWithGoogle(context);
                          },
                          child: const Text("Sign In With Google"),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            signInWithFacebook(LoginBehavior.nativeOnly);
                          },
                          child: const Text("Sign In With Facebook"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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

  signInWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user == null) {
        return null;
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Result(
            displayName: userCredential.user?.displayName ?? "",
            displayEmail: userCredential.user?.email ?? "",
          ),
        ),
      );
      // print(userCredential.user?.displayName);
    } catch (e) {
      return e;
    }
  }

  signInWithFacebook(LoginBehavior behavior) async {
    try {
      final result = await FacebookAuth.instance.login(loginBehavior: behavior);
      switch (result.status) {
        case LoginStatus.success:
          final facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final firebaseUserCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
        // print(firebaseUserCredential.user!.displayName);
        case LoginStatus.cancelled:
          await FacebookAuth.instance.logOut();
          return null;
        case LoginStatus.failed:
          await FacebookAuth.instance.logOut();
          break;
        default:
          await FacebookAuth.instance.logOut();
          break;
      }

      return signInWithFacebook(LoginBehavior.webOnly);
    } catch (error) {
      return null;
    }
  }
}
