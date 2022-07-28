import 'package:flutter/services.dart';

class NumericalRangeFormatter extends TextInputFormatter {
  final int max;

  NumericalRangeFormatter({
    required this.max
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
  ) {
    if(newValue.text != '') {
      if(int.parse(newValue.text) > max) {
        return oldValue;
      } else {
        return newValue;
      }
    }
    return newValue;
  }
}