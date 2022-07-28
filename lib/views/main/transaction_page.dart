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
  TextEditingController searchController = TextEditingController(text: '');
  bool searchStatusFilled = false;

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<TransactionProvider>(context, listen: false).getTransactionHistory(searchQuery: null);
    await Provider.of<TransactionProvider>(context, listen: false).pusherTransactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    void clearSearch() {
      searchController.clear();
      searchStatusFilled = false;
      setState(() {
        searchStatusFilled = false;
      });
      context.read<TransactionProvider>().getTransactionHistory(searchQuery: null);
    }

    Widget search() {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          style: primaryTextStyle.copyWith(fontSize: 14),
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: secondaryTextColor),
            ),
            hintText: 'Cari produk/kode nota/nama penerima',
            hintStyle: secondaryTextStyle.copyWith(fontSize: 13),
            prefixIcon: Icon(Icons.search, color: secondaryTextColor, size: 20,),
            suffixIcon: searchStatusFilled
                ? InkWell(
                onTap: () {
                  clearSearch();
                },
                child: Icon(Icons.cancel, color: secondaryTextColor, size: 20,)
            )
            : null,
          ),
          onChanged: (value) {
            Future.delayed(const Duration(milliseconds: 500), () {
              //context.read<TransactionProvider>().transactions = [];
              context.read<TransactionProvider>().getTransactionHistory(searchQuery: value);
            });
            if(value.isNotEmpty) {
              setState(() {
                searchStatusFilled = true;
              });
            } else {
              setState(() {
                searchStatusFilled = false;
              });
            }
          },
        ),
      );
    }

    Widget loadingWidget() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    Widget emptyDataWidget() {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80,),
            Image.asset('assets/empty-icon.png', width: MediaQuery.of(context).size.width - (15 * defaultMargin),),
            const SizedBox(height: 16,),
            Text(
              'Pencarian transaksi tidak ditemukan',
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 16),
            )
          ],
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
                      child: data.loadingGetData
                          ? loadingWidget()
                          : data.transactions.isEmpty
                              ? emptyDataWidget()
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
