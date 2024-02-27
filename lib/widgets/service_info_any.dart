import 'package:flutter/material.dart';

class ItemWidget<T> extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.futureFunction,
    required this.company,
    required this.name,
    required this.serviceNumber,
  });

  final Future<T> Function(int) futureFunction;
  final String company;
  final String name;
  final int serviceNumber;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: futureFunction(serviceNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          final amount = snapshot.data.toString();
          return _buildItemWidget(amount);
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildItemWidget(String amount) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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