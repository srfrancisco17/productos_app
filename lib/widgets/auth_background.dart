// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

   final Widget child;

  const AuthBackground({
    Key? key, 
    required this.child
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          this.child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        // height: 200,
        // color: Colors.red,
        child: Icon(Icons.person_pin, color: Colors.white, size: 100),
        margin: EdgeInsets.only(top: 30),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 90, left: 280),
          Positioned(child: _Bubble(), top: -40, left: 280),
          Positioned(child: _Bubble(), top: -50, left: -20),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 120, left: 20),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ]
    )
  );
}

class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}