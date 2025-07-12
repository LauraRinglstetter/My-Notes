import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State <VerifyEmailView> createState() =>  VerifyEmailViewState();
}

class  VerifyEmailViewState extends State <VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify email')),
      body: Column(
        children: [ 
          const Text('Please verfiy your email address:'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Send email verification'),
          )
        ],
      ),
    );
  }
}