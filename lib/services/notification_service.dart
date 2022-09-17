import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class NotificationService {
  var baseUrl = constants.baseUrl;

  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = "AAAATti_Peo:APA91bHiw-hhsAqgtu12_9CyedKg3SQeGGsSt7zM3V47Mo0gK_IY_OBWBOfi6a1Bl8QnuIw6aVjfE2RsniTon2ZxoIvmn546kGMMgrLJmsX3OV7K6a1ywVfL8m5QY__UJZJrjnVOtQ6r";

  void sendFcm({
    required String title,
    String? body,
    required String fcmToken
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey'
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));

    request.body = jsonEncode({
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
        'sound': 'default'
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> getFcmTokenOwner() async {
    var url = '$baseUrl/fcmTokenOwner';
    String token = await constants.getTokenUser();

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      String token = jsonDecode(response.body)['data'];

      return token;
    } else {
      throw Exception('Data FCM token pemilik toko gagal diambil!');
    }
  }
}