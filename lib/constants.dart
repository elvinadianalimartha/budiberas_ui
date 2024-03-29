// const String baseUrl = 'http://192.168.100.36:8000/api';
// const String urlPhoto = 'http://192.168.100.36:8000/storage/';

import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'https://budiberas.pinulusuran.my.id/api';
const String urlPhoto = 'https://budiberas.pinulusuran.my.id/photoProduct/';

const String mapUrl = 'https://nominatim.openstreetmap.org';

Future<String> getTokenUser() async{
  SharedPreferences loginData = await SharedPreferences.getInstance();
  var tokenUser = loginData.getString('token');
  return tokenUser.toString();
}