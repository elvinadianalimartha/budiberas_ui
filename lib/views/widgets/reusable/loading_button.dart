import 'package:flutter/material.dart';
import 'package:skripsi_budiberas_9701/theme.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, //supaya selebar layar
      child: TextButton(
          onPressed: (){},
          style: TextButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Memuat',
                style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium
                ),
              ),
              const SizedBox(width: 8,),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
