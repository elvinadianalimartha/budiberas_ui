import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/providers/auth_provider.dart';
import 'package:skripsi_budiberas_9701/providers/places_provider.dart';
import 'package:skripsi_budiberas_9701/theme.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/address_manage_widget.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/done_button.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/loading_button.dart';

import '../../models/address_suggestion_model.dart';
import '../../services/places_service.dart';

import 'package:latlong2/latlong.dart' as lat_long;

class RegistrationFormPage2 extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const RegistrationFormPage2({
    Key? key,
    required this.name,
    required this.email,
    required this.password
  }) : super(key: key);

  @override
  State<RegistrationFormPage2> createState() => _RegistrationFormPage2State();
}

class _RegistrationFormPage2State extends State<RegistrationFormPage2> {
  final _regisForm2Key = GlobalKey<FormState>();

  String? _selectedRegency;
  String? _selectedDistrict;

  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  TextEditingController detailController = TextEditingController(text: '');

  final MapController _mapController = MapController();
  bool mapIsCreated = false;
  double? latitudeForMap;
  double? longitudeForMap;

  bool isAddressFilled = false;

  late PlacesProvider placesProvider;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    placesProvider = Provider.of<PlacesProvider>(context, listen: false);
    getInit();
  }

  getInit() async {
    await placesProvider.getLocalRegencies();
  }

  @override
  void dispose() {
    super.dispose();
    placesProvider.disposeInputAddress();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget back() {
      return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)
      );
    }

    Widget phoneNumber() {
      return AddressManageWidgets().phoneNumber(
          phoneNumberCtrl: phoneNumberController,
          hintText: 'Masukkan no. HP Anda'
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

    handleRegister() async {
      setState(() {
        isLoading = true;
      });

      String? token = await FirebaseMessaging.instance.getToken();
      if(await context.read<AuthProvider>().register(
          name: widget.name,
          email: widget.email,
          password: widget.password,
          fcmToken: token!,
          regency: _selectedRegency!,
          district:  _selectedDistrict!,
          address: addressController.text,
          addressNotes: detailController.text,
          latitude: latitudeForMap!,
          longitude: longitudeForMap!,
          phoneNumber: phoneNumberController.text
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Selamat! Registrasi sukses'),
              backgroundColor: secondaryColor,
              duration: const Duration(seconds: 1),
            )
        );
        Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal registrasi!'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 1),
          )
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget allContent() {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _regisForm2Key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                back(),
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
                AddressManageWidgets().detailAddress(detailController: detailController),
                const SizedBox(height: 50,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: isLoading
                    ? const LoadingButton()
                    : DoneButton(
                      text: 'Daftar',
                      onClick: () {
                        if(_regisForm2Key.currentState!.validate()) {
                          handleRegister();
                        }
                      }
                    ),
                )
              ],
            ),
          )
        )
      );
    }

    Widget loadingGetData() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
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
        ),
      );
    }

    return Scaffold(
      body: Consumer<PlacesProvider>(
        builder: (context, data, child) {
          return data.loadingRegencies
            ? loadingGetData()
            : allContent();
        }
      )
    );
  }
}