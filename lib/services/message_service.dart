import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessagesByUserId(int userId) {
    try {
      return firestore.collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
            var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
              print('cek masuk');
              print(message.data());
              print('cek masuk 2');
              return MessageModel.fromJson(message.data() as Map<String, dynamic>);
            }).toList();

            print('cek masuk 3');
            result.sort(
              (MessageModel a, MessageModel b) =>
                a.createdAt.compareTo(b.createdAt),
              );
            return result;
          });
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> addMessage({
    required UserModel user,
    required bool isFromUser,
    required String message,
    required ProductModel product,
    String? imageUrl,
  }) async {
      var uuid = const Uuid();
      try {
        //NOTE: collection(nama id yg udah dibikin di firestore console)
        firestore.collection('messages').add({
          'id': uuid.v4(),
          'userId': user.id,
          'userName': user.name,
          'userImage': user.profilePhotoUrl,
          'isFromUser': isFromUser, //NOTE: sbg pelanggan: true, sbg pemilik: false
          'message': message,
          'product': product is UninitializedProductModel
                      ? {} //NOTE: jika user tidak menautkan produk, maka akan disend data berupa map kosong {}
                      : product.toJson(),
          'imageUrl': imageUrl,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
          'isRead': false, //NOTE: isRead awalnya diset false dulu, nanti saat dibuka chatnya baru diupdate jadi true
        }).then((value) => print('Message is delivered'));
      } catch(e) {
        throw Exception('Message fail to delivered');
      }
  }
}