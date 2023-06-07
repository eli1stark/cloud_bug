import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? uid;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'User: $uid',
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                final c =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: 'example@gmail.com',
                  password: '1234abc',
                );

                setState(() {
                  uid = c.user?.uid;
                });
              },
              child: const Text(
                'createUserWithEmailAndPassword (1)',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final c = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: 'example@gmail.com',
                password: '1234abc',
              );

              setState(() {
                uid = c.user?.uid;
              });
            },
            child: const Text(
              'signInWithEmailAndPassword (2)',
            ),
          ),
          TextButton(
            onPressed: () async {
              if (uid == null) return;

              counter++;

              final ff = FirebaseFirestore.instance;
              final collection = ff.collection('users').doc(uid);

              await ff.runTransaction((transaction) async {
                transaction.set(collection, {
                  'test': counter,
                });
              });
            },
            child: const Text(
              'Run transaction (3)',
            ),
          ),
        ],
      ),
    );
  }
}
