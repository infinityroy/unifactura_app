
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unifactura_app/services/water/water_bill_service.dart';


class BillServiceAya implements WaterBillService {
  @override
  Future<double> getBillAmount(int serviceNumber) async {
    await dotenv.load(fileName: ".env");
    return 0;
  }
}
