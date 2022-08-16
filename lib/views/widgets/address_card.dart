import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/views/form/edit_address.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/are_you_sure_dialog.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/cancel_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../../theme.dart';

class AddressCard extends StatelessWidget {
  final UserDetailModel detail;

  const AddressCard({
    Key? key,
    required this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget editButton() {
      return OutlinedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FormEditAddress(addressToEdit: detail,)));
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: btnColor,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.all(8),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: btnColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.edit, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 11,),
            Text(
              'Ubah',
              style: yellowTextStyle.copyWith(
                fontWeight: medium,
                fontSize: 12,
              ),
            )
          ],
        ),
      );
    }

    handleDeleteAddress() async{
      if(await context.read<UserDetailProvider>().deleteAddress(
          id: detail.id,)
      ) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data alamat berhasil dihapus'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data gagal dihapus'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Future<void> showDialogAreYouSure() async{
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialogWidget(
          text: 'Apakah Anda yakin ingin menghapus alamat milik ${detail.addressOwner}?',
          noteText: '(${detail.address})',
          childrenList: [
            CancelButton(
              onClick: () {
                Navigator.pop(context);
              },
              text: 'Tidak',
              fontSize: 14,
            ),
            const SizedBox(width: 16,),
            DoneButton(
              onClick: () {
                handleDeleteAddress();
              },
              text: 'Ya, hapus',
              fontSize: 14,
            ),
          ],
        )
      );
    }

    Widget deleteButton() {
      return OutlinedButton(
        onPressed: () {
          showDialogAreYouSure();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: alertColor,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.all(8),
        ),
        child: Row(
          children: [
            Icon(Icons.delete_rounded, color: alertColor, size: 23,),
            const SizedBox(width: 8,),
            Text(
              'Hapus',
              style: alertTextStyle.copyWith(
                fontWeight: medium,
                fontSize: 12,
              ),
            )
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: secondaryTextColor.withOpacity(0.8), width: 0.5),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  detail.addressOwner,
                  style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                ),
                detail.defaultAddress == 1
                  ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: fourthColor.withOpacity(0.5),
                    ),
                    child: Text(
                      'Utama',
                      style: priceTextStyle,
                    ),
                  )
                  : const SizedBox()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.phoneNumber,
                  style: greyTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4,),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: detail.address,
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                      detail.addressNotes != '' && detail.addressNotes != null
                        ? TextSpan(
                            text: ' (${detail.addressNotes})',
                            style: greyTextStyle.copyWith(fontSize: 14),
                          )
                        : const TextSpan()
                    ]
                  )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 20),
            child: Row(
              children: [
                editButton(),
                const SizedBox(width: 30,),
                deleteButton(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
