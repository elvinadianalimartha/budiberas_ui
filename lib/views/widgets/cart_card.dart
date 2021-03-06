import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/are_you_sure_dialog.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/cancel_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/numerical_range_fomatter.dart';

import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../theme.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class CartCard extends StatefulWidget {
  late final CartModel cart;
  final Key? key;
  CartCard({
    this.key,
    required this.cart,
  }) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  bool _isDisabledDecrement = false;
  bool _isDisabledIncrement = false;

  @override
  void initState() {
    super.initState();
    getInitPusherStock();
  }

  getInitPusherStock() async{
    await Provider.of<CartProvider>(context, listen: false).pusherStock();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController editQtyManualCtrl = TextEditingController(text: '${widget.cart.quantity}',);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    TextEditingController textOrderNoteCtrl = TextEditingController(text: widget.cart.orderNotes);

    var formatter = NumberFormat.decimalPattern('id');

    //Qty di cart min. 1
    if(widget.cart.quantity <= 1) {
      setState(() {
        _isDisabledDecrement = true;
      });
    } else {
      setState(() {
        _isDisabledDecrement = false;
      });
    }

    //Batas max qty adalah stok produk saat ini
    if(widget.cart.quantity >= widget.cart.product.stock) {
      setState(() {
        _isDisabledIncrement = true;
      });
    } else {
      setState(() {
        _isDisabledIncrement = false;
      });
    }

    Future<void> handleUpdateQty() async{
      if(await cartProvider.updateQtyCart(
        id: widget.cart.id,
        quantity: widget.cart.quantity,
        token: authProvider.user!.token!,
      )) {
        print('update qty succeed');
      }else {
        print('update qty failed');
      }
    }

    Widget editQty() {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: secondaryTextColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              icon: Icon(
                  Icons.remove_circle,
                  color: _isDisabledDecrement
                      ? secondaryTextColor
                      : secondaryColor
              ),
              onPressed: () {
                _isDisabledDecrement
                    ? (){}
                    : [cartProvider.decrementQty(widget.cart.id), handleUpdateQty()];
              },
            ),
            Flexible(
              child: TextFormField(
                decoration: const InputDecoration(
                  constraints: BoxConstraints(
                    maxWidth: 65,
                  ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [NumericalRangeFormatter(max: widget.cart.product.stock)],
                controller: editQtyManualCtrl,
                textAlign: TextAlign.center,
                onFieldSubmitted: (value) {
                  if(value != '') {
                    setState(() {
                      widget.cart.quantity = int.parse(value);
                    });

                    //fungsi utk hitung total harga scr realtime
                    cartProvider.manualEditQty(widget.cart.id, int.parse(value));

                    //update qty yg baru ke server
                    handleUpdateQty();
                  } else {
                    setState(() {
                      editQtyManualCtrl.text = widget.cart.quantity.toString();
                    });
                  }
                },
              ),
            ),
            IconButton(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              onPressed: () {
                _isDisabledIncrement
                  ? () {}
                  : [cartProvider.incrementQty(widget.cart.id), handleUpdateQty()];
              },
              icon: Icon(
                Icons.add_circle,
                color: _isDisabledIncrement
                  ? secondaryTextColor
                  : secondaryColor
              ),
            ),
          ],
        ),
      );
    }

    Future<void> handleDeleteCart() async{
      if(await cartProvider.deleteCart(
        id: widget.cart.id,
        token: authProvider.user!.token!,
      )) {
        //cartProvider.getCartsByUser(authProvider.user!.token!);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Produk berhasil dihapus',
                style: whiteTextStyle,
              ),
              backgroundColor: secondaryColor,
              duration: const Duration(milliseconds: 700),
            )
        );
        print('delete cart succeed');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Produk gagal dihapus',
                style: whiteTextStyle,
              ),
              backgroundColor: alertColor,
              duration: const Duration(milliseconds: 700),
            )
        );
        print('delete cart failed');
      }
      Navigator.pop(context);
    }

    Future<void> areYouSureToDelete() async{
      return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialogWidget(
            text: 'Apakah Anda yakin ingin menghapus produk ${widget.cart.product.name} dari keranjang belanja?',
            childrenList: [
              CancelButton(
                onClick: (){
                  Navigator.pop(context);
                },
              ),
              DoneButton(
                onClick: () {
                  handleDeleteCart();
                },
                text: 'Ya, hapus',
              ),
            ],
          )
      );
    }

    Widget deleteBtn() {
      return GestureDetector(
        onTap: () {
          areYouSureToDelete();
        },
        child: Row(
          children: [
            Icon(Icons.delete_rounded, color: alertColor, size: 18,),
            const SizedBox(width: 4,),
            Text(
              'Hapus',
              style: primaryTextStyle.copyWith(
                color: alertColor,
                fontWeight: light,
              ),
            )
          ],
        ),
      );
    }

    Future<void> handleUpdateNote() async{
      if(await cartProvider.updateOrderNotes(
        id: widget.cart.id,
        token: authProvider.user!.token!,
        orderNotes: textOrderNoteCtrl.text,
      )) {
        //cartProvider.getCartsByUser(authProvider.user!.token!);
        print('order note updated');
      }else {
        print('order note fail to update');
      }
    }

    Widget showTextFormForOrderNotes() {
      return TextFormField(
        controller: textOrderNoteCtrl,
        maxLines: 1,
        style: primaryTextStyle,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: secondaryTextColor, width: 1),
          ),
          suffixIcon: InkWell(
              onTap: () {
                cartProvider.clickToRemoveForm(widget.cart.id);
                textOrderNoteCtrl.clear();
                handleUpdateNote();
              },
              child: const Icon(Icons.close, size: 20,)
          ),
          labelText: 'Tulis catatan',
        ),
        onEditingComplete: () {
          handleUpdateNote();
          FocusScope.of(context).unfocus();
        },
      );
    }

    Widget clickToWrite() {
      return GestureDetector(
        onTap: () {
          cartProvider.clickShowTextForm(widget.cart.id);
        },
        child: Text(
          'Tulis Catatan',
          style: orderNotesTextStyle.copyWith(
              decoration: TextDecoration.underline
          ),
        ),
      );
    }

    Widget productInCart() {
      return Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: widget.cart.product.galleries.isNotEmpty
                  ? Image.network(
                constants.urlPhoto + widget.cart.product.galleries[0].url.toString(),
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Container(color: secondaryTextColor.withOpacity(0.2), child: Icon(Icons.image_not_supported_rounded, color: secondaryTextColor, size: 70,));
                },
              )
                  : Container(
                  color: secondaryTextColor.withOpacity(0.2),
                  child: Icon(Icons.image, color: secondaryTextColor, size: 70,)
              )
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cart.product.name,
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4,),
                Text(
                  'Rp ${formatter.format(widget.cart.product.price)}',
                  style: priceTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    }

    //simpan value checkbox to server
    updateCheckedVal(bool val) async {
      int isSelectedInt = val? 1 : 0;
      if(await cartProvider.updateValSelectedCart(
          id: widget.cart.id,
          token: authProvider.user!.token!,
          isSelected: isSelectedInt)
      ) {
        return print('sukses update is_selected');
      } else {
        return print('gagal update is_selected');
      }
    }

    Widget checkBox() {
      return CheckboxListTile(
        activeColor: primaryColor,
        onChanged: (bool? value) {
          updateCheckedVal(value!);

          widget.cart.isSelected = value;
          cartProvider.setCheckAllValue();

          if(widget.cart.isSelected == true) {
            cartProvider.selectCart(widget.cart);
          } else {
            cartProvider.removeFromSelectedCart(widget.cart.id);
          }
        },
        value: widget.cart.isSelected,
        controlAffinity: ListTileControlAffinity.leading,
        title: productInCart(),
      );
    }

    Widget cartContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          checkBox(),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: widget.cart.noteIsNull == true
                      ? clickToWrite() : showTextFormForOrderNotes(),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    deleteBtn(),
                    const SizedBox(width: 40,),
                    editQty(),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    }

    return Column(
      children: [
        const SizedBox(height: 12,),
        cartContent(),
        const SizedBox(height: 12,),
        const Divider(
          thickness: 2,
        )
      ],
    );
  }
}