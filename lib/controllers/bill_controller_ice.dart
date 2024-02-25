

import 'package:unifactura_app/services/electric/electric_bill_service.dart';

class ElectricBillController{

  final ElectricBillService _electricBillService;

  ElectricBillController(this._electricBillService);

  Future<double> getBillAmount(int serviceNumber) async {
    return await _electricBillService.getBillAmount(serviceNumber); 
  }

}