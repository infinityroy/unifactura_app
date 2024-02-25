import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unifactura_app/services/electric/electric_bill_service.dart';
import 'package:http/http.dart' as http;

class IceBillService implements ElectricBillService {

  @override
  Future<double> getBillAmount(int serviceNumber) async {

    double resp = 0;

    // Get enviroments  variables from .env file
    await dotenv.load(fileName: ".env");

    final url = dotenv.get('GET_AMOUNT_BILL_ICE_URL') + serviceNumber.toString();

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];
      for (var item in data) {
        var mfacturado = item['mfacturado'];
        log('Valor de mfacturado: $mfacturado');
      }
      
    } else{
      throw Exception('Failed to get Bild Information');
    }

    return resp;
  }
}