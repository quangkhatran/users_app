import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

import '../widgets/error_dialog.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_dialog.dart';
import '../mainScreens/home_screen.dart';
import './auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // login
      loginNow();
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: 'Please write email/password',
          );
        },
      );
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: 'Checking credentials',
        );
      },
    );

    User? currentUser;

    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then(
      (auth) {
        currentUser = auth.user!;
      },
    ).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString(),
          );
        },
      );
    });

    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        await sharedPreferences!.setString(
          'uid',
          currentUser.uid,
        );
        await sharedPreferences!.setString(
          'email',
          snapshot.data()!['email'],
        );
        await sharedPreferences!.setString(
          'name',
          snapshot.data()!['name'],
        );
        await sharedPreferences!.setString(
          'photoUrl',
          snapshot.data()!['photoUrl'],
        );

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const HomeScreen()),
        );
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const AuthScreen()),
        );
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: 'No record found.',
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'images/login.png',
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'Email',
                  isObscured: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'Password',
                  isObscured: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () {
              formValidation();
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}