import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../../themes/styles/theme_colors.dart';
import '../../themes/styles/typography.dart';

class PinInputField extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final String label;
  final bool _withLabel;


  PinInputField({super.key, this.controller, this.obscureText = false}) : _withLabel = false,label="";

  PinInputField.label({super.key,this.controller, this.obscureText = false,required this.label}) : _withLabel = true;


  final _defaultPinTheme = PinTheme(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: ThemeColors.gray1));


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(_withLabel)
        Text(label,style: theme.textTheme.bodySmall?.copyWith(color: ThemeColors.gray4),).tr(),
        if(_withLabel)
        const SizedBox(height: 4,),
        Pinput(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          obscureText: obscureText,
          controller: controller,
          pinAnimationType: PinAnimationType.slide,
          preFilledWidget: Text('-',style: inputHintStyle),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          defaultPinTheme: _defaultPinTheme,
          focusedPinTheme: _defaultPinTheme.copyWith(
              decoration: _defaultPinTheme.decoration?.copyWith(
                  color: ThemeColors.primaryColor.shade50,
                  border: Border.all(color: ThemeColors.primaryColor,width: 0.5)
              )),
        )
      ],
    );
  }
}
