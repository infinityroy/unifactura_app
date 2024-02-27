import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unifactura_app/widgets/service_info_any.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'unifactura_app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListaWidget()
    );
  }
}


class ListaWidget extends StatelessWidget {
  const ListaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: ListView( // Utiliza un ListView para mostrar una lista
        children: const [
          
          ItemWidget<String>(futureFunction: fetchMFacturadoIce,serviceNumber: 609747,company: 'ICE',name: 'Sabana Larga',),
          
          // Puedes agregar más ListTile según sea necesario
        ],
      ),
    );
  }
}



Future<String> fetchMFacturadoIce(int numberService) async {
    final response = await http.get(
      Uri.parse('https://apps.grupoice.com/FacturaElectrica/api/FactElecICE/?nise=$numberService'),
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




