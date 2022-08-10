import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getDocId(int userId) async {
    QuerySnapshot querySnapshot = await firestore.collection('messages').where('userId', isEqualTo: userId).get();
    String docId = querySnapshot.docs[0].id;
    return docId;
  }

  Stream<List<MessageModel>> getMessagesByUserId(int userId) async*{
    try {
      int docSize = await firestore.collection('messages').where('userId', isEqualTo: userId).get().then((value) => value.size);

      if(docSize > 0) {
        yield* firestore.collection('messages')
            .doc(await getDocId(userId))
            .collection('messageContent')
            .orderBy('createdAt', descending: true) //urutannya dibalik krn di listView nnti dipanggil reverse supaya bisa focus on bottom of the list
            .snapshots()
            .map((QuerySnapshot list) {
          var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
            print('cek masuk');
            print(message.data());
            print('cek masuk 2');
            return MessageModel.fromJson(message.data() as Map<String, dynamic>);
          }).toList();

          print('cek masuk 3');
          return result;
        });
      } else {
        yield [];
      }
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
      CollectionReference messageCollection = firestore.collection('messages');

      int docSize = await messageCollection.where('userId', isEqualTo: user.id).get().then((value) => value.size);
      print('size docs where id: $docSize');

      try {
        if(docSize < 1) {
          messageCollection.add({
            'userId': user.id,
            'userName': user.name,
            'userImage': user.profilePhotoUrl,
            'lastUpdatedByCustAt': DateTime.now().toString(),
          }).then((value) => print('Data pengirim pesan baru berhasil disimpan'));
        }

        //simpan detail pesannya di collection messageContent
        messageCollection
        .doc(await getDocId(user.id))
        .collection('messageContent')
        .add({
          'id': uuid.v4(),
          'isFromUser': isFromUser, //NOTE: sbg pelanggan: true, sbg pemilik: false
          'message': message,
          'product': product is UninitializedProductModel
                      ? {} //NOTE: jika user tidak menautkan produk, maka akan disend data berupa map kosong {}
                      : product.toJson(),
          'imageUrl': imageUrl,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
          'isRead': false, //NOTE: isRead awalnya diset false dulu, nanti saat dibuka chatnya baru diupdate jadi true
        }).then((value) => print('Pesan berhasil dikirim'));

        //update last updated
        messageCollection
            .doc(await getDocId(user.id))
            .update({'lastUpdatedByCustAt' : DateTime.now().toString()}) // <-- Updated data
            .then((_) => print('Updated'))
            .catchError((error) => print('Update failed: $error'));
      } catch(e) {
        throw Exception('Pesan gagal dikirim');
      }
  }
}