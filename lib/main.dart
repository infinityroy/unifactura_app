import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unifactura_app/widgets/service_info_any.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, dynamic> datos = await cargarDatosImportantes();
  runApp(MyApp(datos: datos));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic> datos;
  const MyApp({super.key, required this.datos});

  

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
      home: ListaWidget(datos: datos),
    );
  }
}


class ListaWidget extends StatelessWidget {
  final Map<String, dynamic> datos;

  const ListaWidget({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: ListView(
        children: [
          ItemWidget<String>(
            futureFunction: fetchMFacturadoIce,
            serviceNumber: datos["ice_vainilla"], 
            company: 'ICE Eléctrico',
            name: 'Vainilla',
          ),
          ItemWidget<String>(
            futureFunction: fetchMFacturadoIce,
            serviceNumber: datos["ice_sabana"] as int, 
            company: 'ICE Eléctrico',
            name: 'Sabana Larga',
          ),
          ItemWidget<String>(
            futureFunction: fetchMFacturadoAya,
            serviceNumber: datos["aya_vainilla"] as int, 
            company: 'AYA',
            name: 'Vainilla',
          ),
          ItemWidget<String>(
            futureFunction: fetchMFacturadoAya,
            serviceNumber: datos["aya_sabana"] as int,
            company: 'AYA',
            name: 'Sabana Larga',
          ),
          ItemWidget<String>(
            futureFunction: fetchMFacturadoTelecable,
            serviceNumber: datos["telecable"] as int, 
            company: 'Telecable',
            name: 'Internet',
          ),
          ItemWidget<String>(
            futureFunction: fetchMFacturadoIceTelefonico,
            serviceNumber: datos["telefono_casa"] as int,
            company: 'ICE Teléfono',
            name: 'Telefono de casa',
          ),
          ItemWidget<String>(
            futureFunction: fetchMFacturadoIceTelefonico,
            serviceNumber: datos["celular"] as int, 
            company: 'ICE Celular',
            name: 'Telefono Celular',
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> cargarDatosImportantes() async {
  String jsonString = await rootBundle.loadString('lib/service_numbers.json');
  return json.decode(jsonString);
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
        return '₡0';
      }
    } else {
      throw Exception('Fallo al cargar los datos: ${response.statusCode}');
    }
}



Future<String> fetchMFacturadoTelecable(int numberService) async {
  final response = await http.post(
    Uri.parse('https://pago.telecablecr.com/Pagos/ConsultarMensualidades/?contrato=$numberService'),
  );
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final data = jsonData['Result'];
    if (data != null && data.isNotEmpty) {
      final montos = data.map<String>((entry) => '₡${entry['deuda']}').toList();
      return montos.join(' ');
    } else {
      return '₡0';
    }
  } else {
    throw Exception('Fallo al cargar los datos: ${response.statusCode}');
  }
}

Future<String> fetchMFacturadoAya(int numberService) async {
  // TODO [Parse HTML Response file]
  final response = await http.post(
    Uri.parse('https://websolution.aya.go.cr/ConsultaFacturacion/?nise=$numberService'),
  );
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final data = jsonData['Result'];
    if (data != null && data.isNotEmpty) {
      final montos = data.map<String>((entry) => '₡${entry['deuda']}').toList();
      return montos.join(' ');
    } else {
      return '₡0';
    }
  } else {
    throw Exception('Fallo al cargar los datos: ${response.statusCode}');
  }
}


Future<String> fetchMFacturadoIceTelefonico(int numberService) async {
  final response = await http.post(
    Uri.parse('https://sar.arkkosoft.com/sar/icetel/servicio/obtenerFacturas/?id=$numberService&fav=false'),
  );
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final data = jsonData['datos'];
    if (data != null && data.isNotEmpty) {
      final montos = data.map<String>((entry) => '₡${entry['deuda']}').toList();
      return montos.join(' ');
    } else {
      return '₡0';
    }
  } else {
    throw Exception('Fallo al cargar los datos: ${response.statusCode}');
  }
}

// Telefono casa Patricia
//https://sar.arkkosoft.com/sar/icetel/servicio/obtenerFacturas/?id=22260653&fav=false



