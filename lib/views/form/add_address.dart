import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/places_provider.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/services/places_service.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

import '../../models/address_suggestion_model.dart';
import '../../theme.dart';
import '../widgets/reusable/address_manage_widget.dart';
import '../widgets/reusable/app_bar.dart';
import '../widgets/reusable/done_button.dart';

import 'package:latlong2/latlong.dart' as lat_long;

class FormAddAddress extends StatefulWidget {
  const FormAddAddress({Key? key}) : super(key: key);

  @override
  _FormAddAddressState createState() => _FormAddAddressState();
}

class _FormAddAddressState extends State<FormAddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ownerNameController = TextEditingController(text: '');
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  TextEditingController? detailController;

  bool isAddressFilled = false;
  String? _selectedRegency;
  String? _selectedDistrict;

  late PlacesProvider placesProvider;
  late UserDetailProvider userDetailProvider;

  final MapController _mapController = MapController();
  bool mapIsCreated = false;
  double? latitudeForMap;
  double? longitudeForMap;

  @override
  void initState() {
    super.initState();
    placesProvider = Provider.of<PlacesProvider>(context, listen: false);
    userDetailProvider = Provider.of<UserDetailProvider>(context, listen: false);
    getInit();
  }

  getInit() async {
    Future.wait([
      placesProvider.getLocalRegencies(),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    placesProvider.disposeInputAddress();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget note() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xffFFEDCB),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catatan',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            Text(
              'Saat ini Toko Sembako Budi Beras hanya melayani pengantaran pesanan '
                  'di area Daerah Istimewa Yogyakarta',
              style: primaryTextStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        )
      );
    }

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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Nama penerima harus diisi';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget phoneNumber() {
      return AddressManageWidgets().phoneNumber(
          phoneNumberCtrl: phoneNumberController,
          hintText: 'Masukkan no. HP penerima pesanan'
      );
    }

    Widget pickRegencies() {
      return Consumer<PlacesProvider>(
          builder: (context, placesProv, child) {
            return AddressManageWidgets().pickRegencies(
                placesProvider: placesProv,
                regencyVal: _selectedRegency,
                onChanged: (value) {
                  if(_selectedRegency != null) {
                    //reset value sebelumnya yg ada di bagian district/kecamatan
                    placesProv.districts = [];
                    _selectedDistrict = null;

                    //reset value alamat
                    placesProv.addressSuggestions = [];
                    addressController.text = '';
                  }
                  _selectedRegency = value.toString();
                  placesProv.getDistrictsByRegency(_selectedRegency!);
                }
            );
          }
      );
    }

    Widget pickDistricts() {
      return Consumer<PlacesProvider>(
          builder: (context, placesProv, child) {
            return AddressManageWidgets().pickDistricts(
                placesProvider: placesProv,
                districtVal: _selectedDistrict,
                onChanged: (value) {
                  if(_selectedDistrict != null) {
                    //ketika districtnya diganti, alamatnya jg akan ikut terganti shg dihapus
                    addressController.text = '';
                  }
                  setState(() {
                    _selectedDistrict = value.toString();
                  });
                  if(_selectedDistrict != null) {
                    placesProv.getAddressSuggestions(_selectedDistrict!); //mengambil daftar alamat berdasarkan kecamatan
                  }
                }
            );
          }
      );
    }

    Widget addressAutoComplete() {
      return Consumer<PlacesProvider>(
          builder: (context, placesProv, child) {
            return AddressManageWidgets().addressAutocomplete(
                hintText: 'Masukkan alamat rumah Anda',
                selectedDistrict: _selectedDistrict,
                placesProvider: placesProv,
                onSuggestionSelected: (AddressSuggestionModel suggestion) {
                  addressController.text = suggestion.displayName;
                  setState(() {
                    latitudeForMap = suggestion.lat;
                    longitudeForMap = suggestion.lon;
                  });
                  if(mapIsCreated == true) {
                    _mapController.move(lat_long.LatLng(latitudeForMap!, longitudeForMap!), 14.0);
                  }
                },
                addressController: addressController
            );
          }
      );
    }

    changePoint(double lat, double lon) async{
      AddressSuggestionModel address = await PlaceApi().reverseGeocode(lat, lon);
      print(address.displayName);
      setState(() {
        addressController.text = address.displayName;
      });
    }

    Widget showMapPreview() {
      mapIsCreated = true;
      return AddressManageWidgets().mapPreview(
        mapController: _mapController,
        latitudeForMap: latitudeForMap!,
        longitudeForMap: longitudeForMap!,
        onTapMap: (_, latLong) {
          setState(() {
            latitudeForMap = latLong.latitude;
            longitudeForMap = latLong.longitude;
          });
          //get address based on lat lon clicked by marker
          changePoint(latLong.latitude, latLong.longitude);

          print(latLong.latitude);
          print(latLong.longitude);
        },
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
            builder: (context, addressManageProvider, child) {
              return Row(
                children: [
                  Flexible(
                    child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      value: 1,
                      groupValue: addressManageProvider.selectedValue,
                      onChanged: (value) {
                        addressManageProvider.changeDefaultVal(value!);
                      },
                      title: Text('Ya', style: primaryTextStyle.copyWith(fontSize: 14),),
                      activeColor: priceColor,
                    ),
                  ),
                  Flexible(
                    child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      value: 0,
                      groupValue: addressManageProvider.selectedValue,
                      onChanged: (value) {
                        addressManageProvider.changeDefaultVal(value!);
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

    handleAddNewAddress() async{
      if(await userDetailProvider.createNewAddress(
          addressOwner: ownerNameController.text,
          regency: _selectedRegency!,
          district: _selectedDistrict!,
          address: addressController.text,
          addressNotes: detailController?.text,
          latitude: latitudeForMap!,
          longitude: longitudeForMap!,
          phoneNumber: phoneNumberController.text,
          defaultAddress: userDetailProvider.selectedValue)
      ) {
        await userDetailProvider.getAllDetailUser();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data alamat berhasil tersimpan'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data gagal ditambahkan'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Widget saveButton(){
      return SizedBox(
        height: 50,
        width: double.infinity, //supaya selebar layar
        child: DoneButton(
          text: 'Simpan',
          onClick: () {
            if(_formKey.currentState!.validate()) {
              handleAddNewAddress();
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
                note(),
                const SizedBox(height: 20,),

                ownerName(),
                const SizedBox(height: 20,),
                phoneNumber(),

                const SizedBox(height: 20,),
                pickRegencies(),
                const SizedBox(height: 20,),
                pickDistricts(),

                const SizedBox(height: 20,),
                addressAutoComplete(),
                const SizedBox(height: 20,),
                latitudeForMap != null
                  ? showMapPreview()
                  : const SizedBox(),

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
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Form Tambah Alamat'),
      body: Consumer<PlacesProvider>(
        builder: (context, data, child) {
          return data.loadingRegencies
              ? loadingGetData()
              : content();
        }
      )
    );
  }
}