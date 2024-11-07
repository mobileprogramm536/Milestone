// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import
import 'package:flutter/material.dart';
import 'package:milestone/pages/forgot_password.dart';
import 'package:milestone/pages/codeVerificationScreen.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/forgotPassword',
      routes: {
        '/forgotPassword': (context) => forgotPassword(),
        '/codeVerificationScreen': (context) => codeVerificationScreen(),
      },
    ));
