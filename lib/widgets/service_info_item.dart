import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.company,
    required this.name,
    required this.amount,
  });

  final String company;
  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Ajusta el espacio entre las columnas
          children: [
          Flexible(
            child: Text(company),
          ),
          Flexible(
            child: Text(name),
          ),
          Flexible(
            child: Text(amount),
          ),
        ],
        ),
      ),
    );
  }
}