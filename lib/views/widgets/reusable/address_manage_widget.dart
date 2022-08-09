import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skripsi_budiberas_9701/views/widgets/reusable/text_field.dart';

import '../../../models/address_suggestion_model.dart';
import '../../../models/regency_district_model.dart';
import '../../../providers/places_provider.dart';
import '../../../theme.dart';

import 'package:latlong2/latlong.dart' as lat_long;

class AddressManageWidgets {
  Widget phoneNumber({
    required TextEditingController phoneNumberCtrl,
    required String hintText
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No. HP',
          style: primaryTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 8,),
        TextFormFieldWidget(
          hintText: hintText,
          controller: phoneNumberCtrl,
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

  Widget pickRegencies({
    required PlacesProvider placesProvider,
    required void Function(Object?) onChanged,
    String? regencyVal,
  }) {
    List<RegencyModel> listRegencies = placesProvider.regencies;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kabupaten/Kota',
          style: primaryTextStyle.copyWith(fontWeight: semiBold),
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField2(
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
          hint: Text('Pilih kabupaten/kota', style: secondaryTextStyle.copyWith(fontSize: 14),),
          items: listRegencies.map((item) {
            return DropdownMenuItem<Object>(
              child: Text(item.name, style: primaryTextStyle.copyWith(fontSize: 14),),
              value: item.name,
            );
          }).toList(),
          value: regencyVal,
          onChanged: onChanged
        ),
      ],
    );
  }

  Widget pickDistricts({
    required PlacesProvider placesProvider,
    required void Function(Object?) onChanged,
    String? districtVal,
  }) {
    List<DistrictModel> listDistricts = placesProvider.districts;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kecamatan',
          style: primaryTextStyle.copyWith(fontWeight: semiBold),
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField2(
          dropdownMaxHeight: 200,
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
          hint: Text('Pilih kecamatan', style: secondaryTextStyle.copyWith(fontSize: 14),),
          items: listDistricts.map((item) {
            return DropdownMenuItem<Object>(
              child: Text(item.name, style: primaryTextStyle.copyWith(fontSize: 14),),
              value: item.name,
            );
          }).toList(),
          onChanged: onChanged,
          value: districtVal,
        )
      ],
    );
  }

  //pilih alamat
  Widget addressAutocomplete({
    required PlacesProvider placesProvider,
    required void Function(AddressSuggestionModel) onSuggestionSelected,
    String? selectedDistrict,
    required TextEditingController addressController,
    required String hintText
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alamat',
          style: primaryTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
        Text(
          'Jika alamat tidak tersedia pada daftar, silakan pilih '
              'alamat yang paling mendekati lalu sesuaikan titik lokasi yang '
              'ada pada peta',
          style: secondaryTextStyle,
        ),
        const SizedBox(height: 8,),
        TypeAheadFormField<AddressSuggestionModel>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          itemBuilder: (context, AddressSuggestionModel suggestion) {
            return ListTile(
              title: Text(suggestion.displayName, style: primaryTextStyle.copyWith(fontSize: 14),),
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
          onSuggestionSelected: onSuggestionSelected,
          textFieldConfiguration: TextFieldConfiguration(
            enabled: selectedDistrict == null ? false : true,
            style: primaryTextStyle.copyWith(fontSize: 14),
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
              hintText: hintText,
              hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  //preview open street map
  Widget mapPreview({
    required MapController? mapController,
    required double latitudeForMap,
    required double longitudeForMap,
    required onTapMap
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 200,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: onTapMap,
          center: lat_long.LatLng(latitudeForMap, longitudeForMap),
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
                point: lat_long.LatLng(latitudeForMap, longitudeForMap),
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
  Widget detailAddress({
    required TextEditingController detailController
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Alamat',
          style: primaryTextStyle.copyWith(
            fontWeight: semiBold,
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
}