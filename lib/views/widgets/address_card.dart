import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';

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

    Widget deleteButton() {
      return OutlinedButton(
        onPressed: () {

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
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                detail.addressOwner,
                style: primaryTextStyle.copyWith(fontWeight: semiBold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.phoneNumber,
                    style: greyTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2,),
                  Text(
                    detail.address,
                    style: greyTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            trailing: detail.defaultAddress == 1
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
