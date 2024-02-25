import 'package:unifactura_app/services/bill_service.dart';

class BillControllerIce{

  final BillService _billServiceIce; 

  BillControllerIce(this._billServiceIce); 

  Future<double> getBillAmount(int serviceNumber) async {
    return await _billServiceIce.getBillAmount(serviceNumber); 
  }

}