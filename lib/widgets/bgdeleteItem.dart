import 'package:flutter/material.dart';

class BGDeleteItem extends StatelessWidget {
  // const BGDeleteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).errorColor),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}
