import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/pickup_success_page.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/status_dialog.dart';

import '../providers/transaction_provider.dart';

class PickupConfirmationPage extends StatelessWidget {
  final int transactionId;
  final String invoiceCode;

  const PickupConfirmationPage({
    Key? key,
    required this.transactionId,
    required this.invoiceCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController inputCodeCtrl = TextEditingController(text: '');

    Future<void> wrongCodeAlert() async{
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 1200), () {
              Navigator.pop(context);
            });
            return StatusDialogWidget(
              text: 'Kode yang dimasukkan keliru!',
              backgroundColorIcon: alertColor,
              icon: Icons.cancel,
              colorIcon: alertColor,
            );
          }
      );
    }

    checkPickupCode() async{
      if(await context.read<TransactionProvider>().checkPickupCode(transactionId: transactionId, inputCode: inputCodeCtrl.text)) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PickupSuccessPage(invoiceCode: invoiceCode,)));
      } else {
        wrongCodeAlert();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  child: const Icon(Icons.arrow_back, size: 28,),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 100,),
                Image.asset('assets/mobile_phone.png', width: 60,),
                const SizedBox(height: 20,),
                Text(
                  'Masukkan kode pengambilan',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                Text(
                  'Untuk pesanan: $invoiceCode',
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 8,),
                Text(
                  'Kode ini digunakan untuk memastikan pesanan Anda tidak tertukar '
                      'dengan yang lain',
                  style: greyTextStyle,
                ),
                const SizedBox(height: 24,),
                TextFormField(
                  controller: inputCodeCtrl,
                  style: const TextStyle(fontSize: 20, letterSpacing: 3,),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4),],
                  decoration: InputDecoration(
                    isCollapsed: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: outlinedBtnColor),
                    ),
                    hintText: 'Masukkan 4 digit yang disebutkan pemilik toko',
                    hintStyle: secondaryTextStyle.copyWith(fontSize: 13, letterSpacing: 0),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 70,),
                DoneButton(
                  onClick: () {
                    checkPickupCode();
                  },
                  text: 'Kirim Kode',
                  fontSize: 14,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
