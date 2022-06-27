import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/chat_bubble.dart';

import '../../models/message_model.dart';
import '../../models/product_model.dart';
import '../../providers/message_provider.dart';
import '../../services/message_service.dart';
import '../../theme.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class ChatPage extends StatefulWidget {
  ProductModel? product;
  ChatPage({
    this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late MessageProvider messageProvider;

  @override
  void initState() {
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    messageProvider.resetToUninitialized();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController(text: '');
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    var formatter = NumberFormat.decimalPattern('id');

    handleAddMessage() async {
      await MessageService().addMessage(
        isFromUser: true,
        message: messageController.text,
        user: authProvider.user!,
        product: widget.product!,
        imageUrl: null,
      );

      //clear after send message
      setState(() {
        widget.product = UninitializedProductModel();
        messageController.text = '';
      });
      messageProvider.resetToUninitialized();
    }

    Widget productPreview() {
      return Container(
        width: 225,
        height: 74,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: fourthColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: widget.product!.galleries.isNotEmpty
                  ? Image.network(
                constants.urlPhoto + widget.product!.galleries[0].url.toString(),
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Container(color: secondaryTextColor.withOpacity(0.2), child: Icon(Icons.image_not_supported_rounded, color: secondaryTextColor, size: 45,));
                },
              )
                  : Container(
                  color: secondaryTextColor.withOpacity(0.2),
                  child: Icon(Icons.image, color: secondaryTextColor, size: 45,)
              )
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product!.name,
                    style: primaryTextStyle.copyWith(
                      fontSize: 12
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2,),
                  Text(
                    'Rp ${formatter.format(widget.product!.price)}',
                    style: priceTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8,),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.product = UninitializedProductModel();
                });
                messageProvider.resetToUninitialized();
              },
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget textInput() {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: MediaQuery.of(context).viewInsets, //supaya gak ketutupan keyboard
        child: Column(
          mainAxisSize: MainAxisSize.min, //supaya ngambil ruang seminimal mungkin
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product is UninitializedProductModel ? const SizedBox() : productPreview(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: formColor,
                    ),
                    child: Center(
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        controller: messageController,
                        style: primaryTextStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Ketik pesanmu di sini...',
                          hintStyle: greyTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: btnColor,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, size: 20,),
                    color: Colors.white,
                    onPressed: handleAddMessage,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget emptyChat(){
      return Center(
          child: widget.product?.id == 0
            ? SingleChildScrollView(
              child: SizedBox(
                width: double.infinity, //spy warna selebar layar
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icon_headset.png', width: 80, color: secondaryColor,),
                    const SizedBox(height: 20,),
                    Text(
                      'Ada yang bisa dibantu?',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Budi Beras siap melayani',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
            : const SizedBox()
      );
    }

    Widget content() {
      return StreamBuilder<List<MessageModel>>(
        stream: MessageService().getMessagesByUserId(authProvider.user!.id!),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data!.isEmpty) {
              return emptyChat();
            }
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              children: snapshot.data!.map(
                (MessageModel message) => ChatBubble(
                  isSender: message.isFromUser,
                  text: message.message,
                  product: message.product,
                )
              ).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: primaryColor,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/small_logo.png', width: 45,),
              const SizedBox(width: 20,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Toko Sembako Budi Beras',
                      style: whiteTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                      maxLines: null,
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      'Aktif',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: content(),
      bottomNavigationBar: textInput(),
    );
  }
}
