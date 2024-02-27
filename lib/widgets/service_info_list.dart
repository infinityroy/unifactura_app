import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unifactura_app/widgets/service_info_item.dart';


class ServiceInfoList extends StatelessWidget {
  const ServiceInfoList({
    super.key,
    required String title,});

  @override
  Widget build(BuildContext context){
    const items = 7;

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(color: Colors.blue.shade50),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                    items, (index) => const ItemWidget(company: 'ICE', name: 'Sabana Larga', amount: '')),
              ),
            ),
          );
        }),
      ),
    );
  }
}




Future<String> fetchMFacturado() async {
  final response = await http.get(
    Uri.parse('https://apps.grupoice.com/FacturaElectrica/api/FactElecICE/?nise=609747'),
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final data = jsonData['data'];
    if (data != null && data.isNotEmpty) {
      final montos = data.map<String>((entry) => '₡${entry['mfacturado']}').toList();
      return montos.join(' ');
    } else {
      throw Exception('No se encontraron datos');
    }
  } else {
    throw Exception('Fallo al cargar los datos: ${response.statusCode}');
  }
}

