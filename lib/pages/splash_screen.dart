import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dashboard/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0), 
                child: Image.asset(
                  'images/sp.png',
                  fit: BoxFit.contain, 
                ),
              ),
            ),
            
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
