// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'dart:async';
import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:text_scanner/recognitionscreen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 10), () {
      
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RecognitionScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      
      body: Center(
        child: CustomPaint(
          painter: MyPainter(),
          child: Container(
            width: 200.0,
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fileadd.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

  
    /*final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(size.width, size.height) / 1 + 10.0; 

    for (double angle = 0; angle < 2 * pi; angle += pi / 6) {
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), 10.0, paint);
    }*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
