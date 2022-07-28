import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/models/midtrans_model.dart';
import 'package:skripsi_budiberas_9701/providers/order_confirmation_provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/page_provider.dart';
import '../theme.dart';

class PaymentMethodPage extends StatefulWidget {
  final String transactionToken;

  const PaymentMethodPage({
    Key? key,
    required this.transactionToken,
  }) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    saveToTransaction(MidtransModel midtrans) async{
      if(await context.read<OrderConfirmationProvider>().savePaymentInfo(
          midtransOrderId: midtrans.orderId,
          paymentMethod: midtrans.paymentMethod,
          bankName: midtrans.bankName,
          vaNumber: midtrans.vaNumber,
          transactionStatus: midtrans.transactionStatus,
      )) {
        //get transaksi & arahin ke transaksi
        context.read<PageProvider>().currentIndex = 3;
        Navigator.of(context)
          ..pop()
          ..pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Transaksi berhasil dilakukan'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Transaksi gagal'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
          ..pop()
          ..pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: customAppBar(text: 'Pilih Metode Pembayaran'),
        body: WebView(
          //initialUrl: widget.transactionToken,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (_controller) {
            webViewController = _controller;
            loadHtmlFromAssets();
          },
          gestureNavigationEnabled: true,
          javascriptChannels: <JavascriptChannel>{
            JavascriptChannel(
              name: 'PayResponse',
              onMessageReceived: (JavascriptMessage receiver) {
                print(receiver.message);
                print('==========>>>>>>>>>>>>>> BEGIN');
                if (receiver.message != null || receiver.message != 'undefined') {
                  if (receiver.message == 'close') {
                    Navigator.pop(context);
                  } else {
                    //resultnya didecode
                    var data = jsonDecode(receiver.message);
                    MidtransModel midtrans = MidtransModel.fromJson(data);

                    //simpan transaksinya ke dalam database
                    saveToTransaction(midtrans);
                  }
                }
                print('==========>>>>>>>>>>>>>> END');
              },
            ),
          },
        ),
      ),
    );
  }

  loadHtmlFromAssets() {
    webViewController.loadUrl(Uri.dataFromString('''<html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script 
          type="text/javascript"
          src="https://app.sandbox.midtrans.com/snap/snap.js"
          data-client-key="SB-Mid-client-d-acOm2J5JfLs0yh"
        ></script>
      </head>
      <body onload="setTimeout(function(){pay()}, 1000)">
        <script type="text/javascript">
            function pay() {
                snap.pay('${widget.transactionToken}', {
                  onSuccess: function(result) {
                    PayResponse.postMessage(JSON.stringify(result));
                  },
                  onPending: function(result) {
                    PayResponse.postMessage(JSON.stringify(result));
                  },
                  onError: function(result) {
                    PayResponse.postMessage(JSON.stringify(result));
                  },
                  onClose: function() {
                    PayResponse.postMessage('close');
                  }
                });
            }
        </script>
      </body>
    </html>''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
