import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../providers/shop_info_provider.dart';
import '../../../theme.dart';
import 'cancel_button.dart';
import 'done_button.dart';

class OrderConfirmWidget {
  var formatter = NumberFormat.decimalPattern('id');

//==================== REUSABLE WIDGET FOR SHIPPING TYPE =====================
  Widget changeBtn({
    required VoidCallback onTap,
    required String textData,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: fourthColor.withOpacity(0.4),
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: thirdColor,
          ),
        ),
        child: Text(
          textData,
          style: priceTextStyle,
        ),
      ),
    );
  }

  Widget shippingField({
    required Widget iconData,
    required String typeName,
    required List<Widget> listNotes,
    required VoidCallback onBtnTap,
    required String labelBtn,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thirdColor,
                ),
                padding: const EdgeInsets.all(6),
                child: iconData,
              ),
              const SizedBox(width: 20,),
              Expanded(
                child: Text(
                  typeName,
                  style: primaryTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
                ),
              ),
              changeBtn(
                  onTap: onBtnTap,
                  textData: labelBtn
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listNotes,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> dialogChangePickupMethod({
    required BuildContext buildContext,
    required String imagePath,
    required String question,
    required TextSpan subtitles,
    required VoidCallback onCancelClick,
    required VoidCallback onDoneClick,
    required String textOnDoneBtn,
  }) async{
    return showDialog(
        context: buildContext,
        builder: (BuildContext context) => AlertDialog(
          insetPadding: const EdgeInsets.all(40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 90,),
                const SizedBox(height: 12,),
                Text(
                  question,
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12,),
                RichText(
                  textAlign: TextAlign.center,
                  text: subtitles,
                ),
                const SizedBox(height: 20,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CancelButton(
                        onClick: onCancelClick,
                        text: 'Batal',
                        fontSize: 14,
                      ),
                      const SizedBox(width: 16,),
                      DoneButton(
                        onClick: onDoneClick,
                        text: textOnDoneBtn,
                        fontSize: 14,
                      ),
                    ]
                )
              ],
            ),
          ),
        )
    );
  }
//==============================================================================

//======================= POP UP S&K GRATIS ONGKIR =============================
  Widget textRules(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u2022',
          style: greyTextStyle.copyWith(fontSize: 20),
        ),
        const SizedBox(width: 12,),
        Flexible(
          child: Text(
            text,
            style: primaryTextStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Future<void> showDialogSpecialShipRules({
    required BuildContext buildContext,
    required ShopInfoProvider shopInfoProvider
  }) {
    return showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel, color: alertColor,)
                    ),
                    const SizedBox(width: 12,),
                    Flexible(
                      child: Text(
                        'Syarat dan Ketentuan Diskon/Gratis Ongkir',
                        style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.5,),
                textRules('Gunakan metode ambil mandiri untuk dapat gratis ongkir'),
                shopInfoProvider.rulesToGetFreeShip().isNotEmpty
                    ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: Text('S&K diskon/gratis ongkir untuk metode pesan antar: ', style: orderNotesTextStyle.copyWith(fontSize: 14),),
                      ),
                      Flexible(
                        child: Column(
                          children:
                          shopInfoProvider.rulesToGetFreeShip().map((e){
                            num formattedMaxDistance;
                            var decimalNumber = e.maxDistance! % 1; //get decimal value (angka di belakang koma)
                            if(decimalNumber == 0) {
                              formattedMaxDistance = e.maxDistance!.toInt(); //remove .0
                            } else {
                              formattedMaxDistance = e.maxDistance!;
                            }
                            return textRules('Pembelian minimal Rp ${formatter.format(e.minOrderPrice)}, '
                                'jarak antar maksimal ${formattedMaxDistance.toString()} km '
                                'supaya ongkir menjadi Rp ${formatter.format(e.shippingPrice)}\n');
                          }).toList(),
                        ),
                      )
                    ]
                )
                    : const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
//==============================================================================
}