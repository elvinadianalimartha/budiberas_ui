import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/address_card_to_select.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';

import '../../theme.dart';
import 'address_card.dart';

class AddressPage extends StatefulWidget {
  final bool isFromConfirmationPage;

  const AddressPage({
    Key? key,
    required this.isFromConfirmationPage,
  }) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() async {
    await Provider.of<UserDetailProvider>(context, listen: false).getAllDetailUser();
  }

  @override
  Widget build(BuildContext context) {
    Widget btnAddAddress() {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topRight,
            child: SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-address');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: priceColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: const EdgeInsets.all(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outlined, color: fourthColor,),
                      const SizedBox(width: 11,),
                      Flexible(
                        child: Text(
                          'Tambah Alamat',
                          style: whiteTextStyle.copyWith(
                            fontWeight: medium,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ),
          ),
        ),
      );
    }

    Widget content() {
      return Column(
        children: [
          btnAddAddress(),
          Flexible(
              child: Consumer<UserDetailProvider>(
                builder: (context, data, child) {
                  return SizedBox(
                      child: data.loadingAll ?
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.listUserDetail.length,
                          itemBuilder: (context, index) {
                            UserDetailModel userDetails = data.listUserDetail[index];
                            if(widget.isFromConfirmationPage) {
                              return AddressCardToSelect(detail: userDetails, indexDetail: index,);
                            } else {
                              return AddressCard(detail: userDetails, indexDetail: index,);
                            }
                        },
                      )
                  );
                },
              )
          ),
        ],
      );
    }

    Widget btnDone() {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          child: DoneButton(
            text: 'Selesai',
            onClick: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.isFromConfirmationPage ? 'Pilih Alamat' : 'Kelola Alamat & No. HP',
          style: whiteTextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 16,
          ),
        ),
      ),
      body: content(),
      bottomNavigationBar: widget.isFromConfirmationPage ? btnDone() : const SizedBox(),
    );
  }
}
