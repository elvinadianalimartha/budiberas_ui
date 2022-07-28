import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/cancel_button.dart';

import '../providers/page_provider.dart';

class PickupSuccessPage extends StatelessWidget {
  final String invoiceCode;

  const PickupSuccessPage({
    Key? key,
    required this.invoiceCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: fourthColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.check_circle, size: 70, color: thirdColor,)
              ),
              const SizedBox(height: 20,),
              Text(
                'Pesanan $invoiceCode \n berhasil diambil',
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 20,),
              Text(
                'Terima kasih! Mari belanja lagi di Budi Beras',
                style: secondaryTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CancelButton(
                  onClick: () {
                    context.read<PageProvider>().currentIndex = 3;
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  text: 'Kembali',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
