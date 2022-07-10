import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_budiberas_9701/models/regency_district_model.dart';
import 'package:skripsi_budiberas_9701/providers/address_management_provider.dart';
import 'package:skripsi_budiberas_9701/providers/places_provider.dart';
import 'package:skripsi_budiberas_9701/providers/user_detail_provider.dart';
import 'package:skripsi_budiberas_9701/services/places_service.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

import '../../models/address_suggestion_model.dart';
import '../../theme.dart';
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
  String? _regencyName;
  String? selectedRegency;
  String? selectedDistrict;

  late PlacesProvider placesProvider;
  late AddressManagementProvider addressManagementProvider;
  late UserDetailProvider userDetailProvider;

  final MapController _mapController = MapController();
  bool mapIsCreated = false;
  double? latitudeForMap;
  double? longitudeForMap;

  @override
  void initState() {
    super.initState();
    placesProvider = Provider.of<PlacesProvider>(context, listen: false);
    addressManagementProvider = Provider.of<AddressManagementProvider>(context, listen: false);
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

    clearAddress() {
      addressController.clear();
      setState(() {
        isAddressFilled = false;
      });
    }

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
              } else if(value.length < 10) {
                return 'No. HP minimal 10 digit';
              } else if(value.length > 13) {
                return 'No. HP maksimal 13 digit';
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
          Consumer<PlacesProvider>(
            builder: (context, placesProvider, child) {
              List<RegencyModel> listRegencies = placesProvider.regencies;
              return DropdownButtonFormField2(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if(value == null) {
                    return 'Kabupaten/kota harus dipilih';
                  }
                  return null;
                },
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
                    value: item.name,
                  );
                }).toList(),
                onChanged: (value) {
                  if(_regencyName != null) {
                    //reset value sebelumnya yg ada di bagian district/kecamatan
                    placesProvider.districts = [];
                    selectedDistrict = null;

                    //reset value alamat
                    placesProvider.addressSuggestions = [];
                    addressController.text = '';
                  }
                  _regencyName = value.toString();
                  placesProvider.getDistrictsByRegency(_regencyName!);
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
          Consumer<PlacesProvider>(
              builder: (context, placesProvider, child) {
                List<DistrictModel> listDistricts = placesProvider.districts;
                return DropdownButtonFormField2(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if(value == null) {
                      return 'Kecamatan harus dipilih';
                    }
                    return null;
                  },
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
                      placesProvider.getAddressSuggestions(selectedDistrict!); //mengambil daftar alamat berdasarkan kecamatan
                    }
                  },
                  value: selectedDistrict,
                );
              }
          )
        ],
      );
    }

    //pilih alamat
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
          Text(
            'Jika alamat tidak tersedia pada daftar, silakan pilih '
                'alamat yang paling mendekati lalu sesuaikan titik lokasi yang '
                'ada pada peta',
            style: secondaryTextStyle,
          ),
          Consumer<PlacesProvider>(
            builder: (context, placesProvider, child) {
              return TypeAheadFormField<AddressSuggestionModel>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                itemBuilder: (context, AddressSuggestionModel suggestion) {
                  return ListTile(
                    title: Text(suggestion.displayName, style: primaryTextStyle,),
                  );
                },
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Alamat harus dipilih';
                  }
                  return null;
                },
                debounceDuration: const Duration(milliseconds: 500),
                suggestionsCallback: (String pattern) {
                  return placesProvider.addressSuggestions.where((suggestion) => suggestion.displayName.toLowerCase().contains(pattern.toLowerCase()));
                },
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
                textFieldConfiguration: TextFieldConfiguration(
                  enabled: selectedDistrict == null ? false : true,
                  style: primaryTextStyle,
                  controller: addressController,
                  onChanged: (value) {
                    if(value.isNotEmpty) {
                      setState(() {
                        isAddressFilled = true;
                      });
                    } else {
                      setState(() {
                        isAddressFilled = false;
                      });
                    }
                  },
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
                    suffixIcon: isAddressFilled
                    ? InkWell(
                        onTap: () {
                          clearAddress();
                        },
                        child: const Icon(Icons.cancel)
                      )
                    : null,
                  ),
                ),
              );
            }
          ),
        ],
      );
    }

    changePoint(double lat, double lon) async{
      AddressSuggestionModel address = await PlaceApi().reverseGeocode(lat, lon);
      print(address.displayName);
      setState(() {
        addressController.text = address.displayName;
      });
    }

    //preview open street map
    Widget mapPreview() {
      mapIsCreated = true;
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 200,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onTap: (_, latLong) {
              setState(() {
                latitudeForMap = latLong.latitude;
                longitudeForMap = latLong.longitude;
              });
              //get address based on lat lon clicked by marker
              changePoint(latLong.latitude, latLong.longitude);

              print(latLong.latitude);
              print(latLong.longitude);
            },
            center: lat_long.LatLng(latitudeForMap!, longitudeForMap!),
            minZoom: 11.0,
            maxZoom: 18.0,
            zoom: 14.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 20.0,
                  height: 20.0,
                  point: lat_long.LatLng(latitudeForMap!, longitudeForMap!),
                  builder: (context) => const SizedBox(
                    child: Icon(Icons.location_on, color: Colors.red, size: 30,),
                  ),
                )
              ],
            )
          ],
        ),
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
          Consumer<AddressManagementProvider>(
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
      if(await addressManagementProvider.createNewAddress(
          addressOwner: ownerNameController.text,
          regency: _regencyName!,
          district: selectedDistrict!,
          address: addressController.text,
          addressNotes: detailController?.text,
          latitude: latitudeForMap!,
          longitude: longitudeForMap!,
          phoneNumber: phoneNumberController.text,
          defaultAddress: addressManagementProvider.selectedValue)
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
                addressAutocomplete(),
                const SizedBox(height: 20,),
                latitudeForMap != null
                  ? mapPreview()
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
            )
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