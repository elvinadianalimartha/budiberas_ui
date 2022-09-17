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
  String? searchQuery;
  final controller = ScrollController();
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    getInit();
    controller.addListener(() {
      if(controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
        if(transactionProvider.endPage > 1) {
          transactionProvider.getNextPageTransaction(searchQuery: searchQuery);
        }
      }
    });
  }

  getInit() async {
    await transactionProvider.getTransactionHistory(searchQuery: null);
    await transactionProvider.pusherTransactionHistory();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    transactionProvider.disposePage();
  }

  @override
  Widget build(BuildContext context) {
    void clearSearch() {
      searchQuery = null;
      searchController.clear();
      searchStatusFilled = false;
      setState(() {
        searchStatusFilled = false;
      });
      context.read<TransactionProvider>().getTransactionHistory(searchQuery: null);
      context.read<TransactionProvider>().disposePage();
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
          onFieldSubmitted: (value) {
            context.read<TransactionProvider>().disposePage();
            context.read<TransactionProvider>().getTransactionHistory(searchQuery: value);
            if(value.isNotEmpty) {
              setState(() {
                searchStatusFilled = true;
                searchQuery = value;
              });
            } else {
              setState(() {
                searchStatusFilled = false;
                searchQuery = null;
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

    Widget historyData(TransactionProvider data) {
      return ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: data.transactions.length + 1,
        itemBuilder: (context, index) {
          if(index < data.transactions.length) {
            TransactionModel transactions = data.transactions[index];
            return TransactionCard(transactions: transactions);
          } else {
            return data.noMoreData
              ? const SizedBox()
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Memuat lebih banyak...',
                      style: greyTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                );
          }
        },
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
                              : historyData(data)
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
