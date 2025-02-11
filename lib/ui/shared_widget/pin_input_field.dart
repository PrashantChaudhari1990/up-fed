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
  final bool showPinIcon;
  final bool autofocus;
  final void Function(String)? onChanged;


  PinInputField({super.key, this.controller, this.obscureText = false,this.onChanged,this.showPinIcon=false,this.autofocus = false}) : _withLabel = false,label="";

  PinInputField.label({super.key,this.controller, this.obscureText = false,required this.label,this.onChanged,this.showPinIcon=false,this.autofocus = false}) : _withLabel = true;
  
  final ValueNotifier<bool> _pinVisible = ValueNotifier<bool>(false);


  final _defaultPinTheme = PinTheme(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(border: Border.all(color: ThemeColors.gray3),borderRadius: BorderRadius.circular(8), color: ThemeColors.gray1));


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context,boxConstraints) {
        return ValueListenableBuilder<bool>(
          builder: (context,pinVisible,_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: showPinIcon ? boxConstraints.maxWidth * 0.85 : boxConstraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(_withLabel)
                        Text(label,style: theme.textTheme.bodySmall?.copyWith(color: ThemeColors.gray4),).tr(),
                      if(_withLabel)
                        const SizedBox(height: 4,),
                      Pinput(
                        autofocus: autofocus,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        obscureText: !pinVisible && obscureText,
                        separatorBuilder: (index)=>SizedBox(width: boxConstraints.maxWidth*0.05,),
                        controller: controller,
                        onChanged: onChanged,
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
                      ),
                    ],
                  ),
                ),
                if(showPinIcon)
                SizedBox(
                    width: boxConstraints.maxWidth * 0.1,
                    child: IconButton(onPressed: (){
                      _pinVisible.value = !_pinVisible.value;
                    }, icon: Icon(pinVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined)))
              ],
            );
          }, valueListenable: _pinVisible,
        );
      }
    );
  }
}
