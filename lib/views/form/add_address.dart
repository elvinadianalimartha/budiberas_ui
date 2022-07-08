import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/models/regency_district_model.dart';
import 'package:skripsi_budiberas_9701/providers/address_provider.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

import '../../models/address_suggestion_model.dart';
import '../../theme.dart';
import '../widgets/reusable/app_bar.dart';
import '../widgets/reusable/done_button.dart';

class FormAddAddress extends StatefulWidget {
  const FormAddAddress({Key? key}) : super(key: key);

  @override
  _FormAddAddressState createState() => _FormAddAddressState();
}

class _FormAddAddressState extends State<FormAddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ownerNameController = TextEditingController(text: '');
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController detailController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  Object? _value;
  int? _regencyId;
  String? selectedDistrict;

  late AddressProvider addressProvider;

  @override
  void initState() {
    super.initState();
    addressProvider = Provider.of<AddressProvider>(context, listen: false);
  }

  getInit() async {
    Future.wait([
      addressProvider.getLocalRegencies(),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    addressProvider.disposeInputAddress();
  }

  @override
  Widget build(BuildContext context) {

    // resetForm() {
    //   ownerNameController.clear();
    //   phoneNumberController.clear();
    //   detailController.clear();
    // }

    Widget ownerName() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Penerima',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            hintText: 'Masukkan nama penerima pesanan',
            controller: ownerNameController,
          ),
          // Consumer<ProductProvider>(
          //   builder: (context, productProvider, child) {
          //     return TextFormFieldWidget(
          //       hintText: 'Masukkan nama penerima pesanan',
          //       controller: ownerNameController,
          //       validator: (value) {
          //         if (value!.isEmpty) {
          //           return 'Nama produk harus diisi';
          //         } else if(productProvider.checkIfUsed(value)) {
          //           return 'Nama produk sudah pernah digunakan';
          //         }
          //         return null;
          //       },
          //     );
          //   }
          // ),
        ],
      );
    }

    Widget phoneNumber() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No. HP Penerima',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            hintText: 'Masukkan no. HP penerima pesanan',
            controller: phoneNumberController,
            textInputType: TextInputType.number,
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value!.isEmpty) {
                return 'No. HP harus diisi';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget pickRegencies() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kabupaten/Kota',
            style: primaryTextStyle.copyWith(fontWeight: medium),
          ),
          Consumer<AddressProvider>(
            builder: (context, addressProvider, child) {
              List<RegencyModel> listRegencies = addressProvider.regencies;
              return DropdownButtonFormField2(
                decoration: InputDecoration(
                  isCollapsed: true,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: formColor,
                  contentPadding: const EdgeInsets.all(16),
                ),
                hint: Text('Pilih kabupaten/kota', style: secondaryTextStyle,),
                items: listRegencies.map((item) {
                  return DropdownMenuItem<Object>(
                    child: Text(item.name, style: primaryTextStyle.copyWith(fontSize: 14),),
                    value: item.id,
                  );
                }).toList(),
                onChanged: (value) {
                  if(_regencyId != null) {
                    addressProvider.districts = [];
                    selectedDistrict = null; //ini untuk menghilangkan value sebelumnya yg ada di bagian district/kecamatan

                    addressProvider.addressSuggestions = [];
                    addressController.text = '';
                  }
                  _value = value;
                  _regencyId = _value as int;
                  addressProvider.getDistrictsByRegency(_regencyId!);
                }
              );
            }
          )
        ],
      );
    }

    Widget pickDistricts() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kecamatan',
            style: primaryTextStyle.copyWith(fontWeight: medium),
          ),
          Consumer<AddressProvider>(
              builder: (context, addressProvider, child) {
                List<DistrictModel> listDistricts = addressProvider.districts;
                return DropdownButtonFormField2(
                    decoration: InputDecoration(
                      isCollapsed: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: formColor,
                      contentPadding: const EdgeInsets.all(16),
                      // addressProvider.loadingDistricts
                      //   ? const CircularProgressIndicator()
                      //   : null
                    ),
                    hint: Text('Pilih kecamatan', style: secondaryTextStyle,),
                    items: listDistricts.map((item) {
                      return DropdownMenuItem<Object>(
                        child: Text(item.name, style: primaryTextStyle.copyWith(fontSize: 14),),
                        value: item.name,
                      );
                    }).toList(),
                    onChanged: (value) {
                      if(selectedDistrict != null) {
                        //ketika districtnya diganti, alamatnya jg akan ikut terganti shg dihapus
                        addressController.text = '';
                      }
                      setState(() {
                        selectedDistrict = value.toString();
                      });
                      if(selectedDistrict != null) {
                        addressProvider.getAddressSuggestions(selectedDistrict!); //mengambil daftar alamat berdasarkan kecamatan
                      }
                    },
                  value: selectedDistrict,
                );
              }
          )
        ],
      );
    }

    //alamat
    Widget addressAutocomplete() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alamat',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          //kasih loading
          Consumer<AddressProvider>(
            builder: (context, addressProv, child) {
              return TypeAheadFormField(
                itemBuilder: (context, AddressSuggestionModel suggestion) {
                  return ListTile(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    title: Text(suggestion.displayName, style: primaryTextStyle,),
                  );
                },
                debounceDuration: const Duration(milliseconds: 500),
                suggestionsCallback: (String pattern) {
                  //kalo mau dibuat fungsi sendiri di addressProv
                  return addressProv.addressSuggestions.where((suggestion) => suggestion.displayName.toLowerCase().contains(pattern.toLowerCase()));
                },
                onSuggestionSelected: (AddressSuggestionModel suggestion) {
                  addressController.text = suggestion.displayName;
                },
                textFieldConfiguration: TextFieldConfiguration(
                  style: primaryTextStyle,
                  controller: addressController,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.all(16),
                    fillColor: formColor,
                    hintText: 'Masukkan alamat penerima',
                    hintStyle: secondaryTextStyle,
                  ),
                ),
              );
            }
          ),
        ],
      );
    }

    //detail alamat
    Widget detailAddress() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Alamat',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            hintText: 'Gang/blok/patokan/warna rumah',
            controller: detailController,
            textInputType: TextInputType.multiline,
            actionKeyboard: TextInputAction.done,
          ),
        ],
      );
    }

    //map

    //set to default or not
    Widget chooseDefault() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jadikan sebagai alamat utama?',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Consumer<UserDetailProvider>(
            builder: (context, userDetailProvider, child) {
              print(userDetailProvider.selectedValue);
              return Row(
                children: [
                  Flexible(
                    child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      value: 1,
                      groupValue: userDetailProvider.selectedValue,
                      onChanged: (value) {
                        userDetailProvider.changeDefaultVal(value!);
                      },
                      title: Text('Ya', style: primaryTextStyle.copyWith(fontSize: 14),),
                      activeColor: priceColor,
                    ),
                  ),
                  Flexible(
                    child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      value: 0,
                      groupValue: userDetailProvider.selectedValue,
                      onChanged: (value) {
                        userDetailProvider.changeDefaultVal(value!);
                      },
                      title: Text('Tidak', style: primaryTextStyle.copyWith(fontSize: 14)),
                      activeColor: priceColor,
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      );
    }

    Widget saveButton(){
      return SizedBox(
        height: 50,
        width: double.infinity, //supaya selebar layar
        child: DoneButton(
          text: 'Simpan',
          onClick: () {
            if(_formKey.currentState!.validate()) {
              //handleAddData();
            }
          },
        ),
      );
    }

    Widget content() {
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ownerName(),
                const SizedBox(height: 20,),
                phoneNumber(),

                const SizedBox(height: 20,),
                pickRegencies(),
                const SizedBox(height: 20,),
                pickDistricts(),

                const SizedBox(height: 20,),
                addressAutocomplete(),
                const SizedBox(height: 20,),
                detailAddress(),
                const SizedBox(height: 20,),
                chooseDefault(),
                const SizedBox(height: 36,),
                saveButton(),
              ]
          ),
        ),
      );
    }

    Widget loadingGetData() {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20,),
            Text(
              'Sedang mengambil daftar pilihan kota/kabupaten...',
              style: greyTextStyle,
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Form Tambah Alamat'),
      body: Consumer<AddressProvider>(
        builder: (context, data, child) {
          return data.loadingRegencies
              ? loadingGetData()
              : content();
        }
      )
    );
  }
}