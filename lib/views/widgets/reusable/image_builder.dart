
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class ImageBuilderWidgets{
  Widget imageFromNetwork({
    required String imageUrl,
    required double width,
    required double height,
    required double sizeIconError,
  }) {
    return Image.network(
        constants.urlPhoto + imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Container(
            color: secondaryTextColor.withOpacity(0.2),
            child: Icon(Icons.image_not_supported_rounded, color: secondaryTextColor, size: sizeIconError,));
        },
    );
  }

  Widget blankImage({
    required double sizeIcon,
  }) {
    return Container(
        color: secondaryTextColor.withOpacity(0.2),
        child: Icon(Icons.image, color: secondaryTextColor, size: sizeIcon,)
    );
  }
}
