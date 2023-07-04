import 'package:flutter/material.dart';

class BGColor extends StatelessWidget {
  // const BGColor({super.key});
  final Widget child;

  BGColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.teal,
          Colors.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: child,
    );
  }
}
