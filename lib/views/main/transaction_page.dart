import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/models/transaction_model.dart';
import 'package:skripsi_budiberas_9701/providers/transaction_provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/transaction_card.dart';

import '../../theme.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<TransactionProvider>(context, listen: false).getTransactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController(text: '');

    Widget search() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          style: primaryTextStyle,
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Cari transaksi',
            hintStyle: secondaryTextStyle,
            prefixIcon: Icon(Icons.search, color: secondaryTextColor, size: 20,),
            // suffixIcon: _statusFilled
            //     ? InkWell(
            //     onTap: () {
            //       clearSearch();
            //     },
            //     child: Icon(Icons.cancel, color: secondaryTextColor, size: 20,)
            // )
            // : null,
          ),
          // onChanged: (value) { //onChanged atau onSubmitted enaknya?
          //   productProvider.searchProduct(value);
          //   if(value.isNotEmpty) {
          //     _statusFilled = true;
          //   } else {
          //     _statusFilled = false;
          //   }
          // },
        ),
      );
    }

    Widget content() {
      return Column(
        children: [
          search(),
          Flexible(
              child: Consumer<TransactionProvider>(
                builder: (context, data, child) {
                  return SizedBox(
                      child: data.loadingGetData ?
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.transactions.length,
                        itemBuilder: (context, index) {
                          TransactionModel transactions = data.transactions[index];
                          return TransactionCard(transactions: transactions);
                        },
                      )
                  );
                },
              )
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
          title: Text('Transaksi', style: whiteTextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 16,
          ),
        ),
      ),
      body: content(),
    );
  }
}
