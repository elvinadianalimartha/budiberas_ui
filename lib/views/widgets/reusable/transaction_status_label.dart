import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/theme.dart';

class TransactionStatusLabel {
  Widget redLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xffffdeeb).withOpacity(0.5),
      ),
      child: Text(
        text,
        style: alertTextStyle.copyWith(fontSize: 12)
      ),
    );
  }
  
  Widget yellowLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xffFFEDCB).withOpacity(0.5),
      ),
      child: Text(
        text,
        style: yellowTextStyle.copyWith(fontSize: 12)
      ),
    );
  }
  
  Widget greenLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: fourthColor.withOpacity(0.5),
      ),
      child: Text(
        text,
        style: priceTextStyle.copyWith(fontSize: 12),
      ),
    );
  }

  Widget blueLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.lightBlueAccent.withOpacity(0.2),
      ),
      child: Text(
        text,
        style: orderNotesTextStyle.copyWith(fontSize: 12),
      ),
    );
  }

  Widget greyLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: secondaryTextColor.withOpacity(0.2),
      ),
      child: Text(
        text,
        style: greyTextStyle.copyWith(fontSize: 12),
      ),
    );
  }

  labellingStatus(String status) {
    switch(status.toLowerCase()) {
      case 'cancelled':
        return redLabel('Pesanan Dibatalkan');
      case 'pending':
        return yellowLabel('Menunggu Pembayaran');
      case 'success': //pembayaran sukses
        return yellowLabel('Menunggu Konfirmasi');
      case 'processed':
        return yellowLabel('Diproses');
      case 'delivered':
        return yellowLabel('Sedang Diantar');
      case 'arrived':
        return blueLabel('Tiba di Tujuan');
      case 'ready to take':
        return blueLabel('Siap Diambil');
      case 'done':
        return greenLabel('Selesai');
      default:
        return greyLabel(status);
    }
  }

  Widget cancelledDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.cancel, color: alertColor.withOpacity(0.7),),
        const SizedBox(width: 8,),
        Flexible(
          child: Text(
            'Pesanan Anda otomatis dibatalkan oleh sistem karena melebihi jangka waktu pembayaran',
            style: primaryTextStyle.copyWith(fontSize: 13),
          )
        )
      ],
    );
  }

  Widget pendingDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.account_balance_wallet, color: btnColor.withOpacity(0.7),),
        const SizedBox(width: 8,),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menunggu pembayaran',
                style: primaryTextStyle.copyWith(fontSize: 13),
              ),
              const SizedBox(width: 4,),
              Text(
                'Pesanan Anda akan diproses setelah Anda menyelesaikan pembayaran',
                style: secondaryTextStyle.copyWith(fontSize: 12),
              )
            ],
          )
        )
      ],
    );
  }

  Widget waitingConfirmationDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.access_time_filled, color: btnColor.withOpacity(0.7),),
        const SizedBox(width: 8,),
        Flexible(
          child: Text(
            'Menunggu konfirmasi dari pemilik toko',
            style: primaryTextStyle.copyWith(fontSize: 13),
          ),
        )
      ],
    );
  }

  Widget processedDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.all_inbox, color: btnColor.withOpacity(0.7),),
        const SizedBox(width: 8,),
        Flexible(
          child: Text(
            'Pesanan Anda sedang diproses oleh pemilik toko',
            style: primaryTextStyle.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget deliveredDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/delivery_icon.png', color: btnColor.withOpacity(0.7), width: 24,),
        const SizedBox(width: 8,),
        Flexible(
          child: Text(
            'Pesanan Anda sedang diantar',
            style: primaryTextStyle.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget arrivedDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.pin_drop, color: fourthColor,),
        const SizedBox(width: 8,),
        Flexible(
          child: Text(
            'Pesanan Anda sudah tiba di tujuan',
            style: primaryTextStyle.copyWith(fontSize: 13),
          ),
        )
      ],
    );
  }

  Widget doneDetail({required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: fourthColor,),
        const SizedBox(width: 8,),
        Flexible(
          child: Text(
            text,
            style: primaryTextStyle.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }

  statusDetail(String status) {
    switch(status.toLowerCase()) {
      case 'cancelled':
        return cancelledDetail();
      case 'pending':
        return pendingDetail();
      case 'success':
        return waitingConfirmationDetail();
      case 'processed':
        return processedDetail();
      case 'delivered':
        return deliveredDetail();
      case 'arrived':
        return arrivedDetail();
      case 'ready to take':
        return doneDetail(text: 'Pesanan Anda sudah siap diambil');
      case 'done':
        return doneDetail(text: 'Selesai');
      default:
        return const SizedBox();
    }
  }
}
