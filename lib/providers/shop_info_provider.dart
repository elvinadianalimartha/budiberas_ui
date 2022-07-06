import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skripsi_budiberas_9701/models/shipping_rates_model.dart';
import 'package:skripsi_budiberas_9701/models/shop_info_model.dart';
import 'package:skripsi_budiberas_9701/services/shop_info_service.dart';

class ShopInfoProvider with ChangeNotifier{
  late ShopInfoModel _shopInfo;

  ShopInfoModel get shopInfo => _shopInfo;

  set shopInfo(ShopInfoModel value) {
    _shopInfo = value;
    notifyListeners();
  }

  //============================================================================

  List<ShippingRatesModel> _shippingRates = [];

  List<ShippingRatesModel> get shippingRates => _shippingRates;

  set shippingRates(List<ShippingRatesModel> value) {
    _shippingRates = value;
    notifyListeners();
  }

  //============================================================================
  double distanceInKm = 0;

  //============================================================================
  //ambil value order total price dari order confirmation provider
  late double _orderTotalPrice;

  set orderTotalPrice(double value) {
    _orderTotalPrice = value;
    notifyListeners();
  }

  Future<void> getShopInfo() async {
    try {
      ShopInfoModel shopInfo = await ShopInfoService().getShopInfo();
      _shopInfo = shopInfo;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getShippingRates() async {
    try {
      List<ShippingRatesModel> shippingRates = await ShopInfoService().getShippingRates();
      _shippingRates = shippingRates;
    } catch (e) {
      print(e);
    }
  }

  //nek gaisa keupdate, berarti mungkin hrs pake notifylistener
  countDistance({
    required double destinationLat,
    required double destinationLong,
  }) {
    double distanceInMeters = Geolocator.distanceBetween(
        _shopInfo.latitude, _shopInfo.longitude,
        destinationLat, destinationLong
    );
    distanceInKm = distanceInMeters/1000;
    return distanceInKm.toStringAsFixed(2); //set 2 decimal places
  }

  countShippingPrice(){
    double roundDistance = double.parse(distanceInKm.toStringAsFixed(1));
    double result =  roundDistance * 2000;

    //2000nya nnti diganti shipping price standar.
    //Cek apakah totalnya nyampe min price dan jaraknya gak max dr list shipping price khusus (pake for)
    return result.round();
  }

  countTotalBill(String shippingType) {
    double total = 0.0;
    if(shippingType.toLowerCase() == 'pesan antar') {
      total = _orderTotalPrice + double.parse(countShippingPrice().toString());
    } else {
      total = _orderTotalPrice;
    }
    return total;
  }
}