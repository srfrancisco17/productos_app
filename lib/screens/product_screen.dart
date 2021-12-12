// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}