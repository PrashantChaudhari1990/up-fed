import 'package:kh_dealer_app/models/auth/set_pin_request.dart';
import 'package:kh_dealer_app/models/base_response.dart';
import 'package:kh_dealer_app/models/user.dart';
import 'package:kh_dealer_app/routes.dart';
import 'package:kh_dealer_app/services/auth/auth_service.dart';
import 'package:kh_dealer_app/ui/shared_widget/kh_app_bar.dart';
import 'package:kh_dealer_app/ui/shared_widget/pin_input_field.dart';
import 'package:kh_dealer_app/utils/toast_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../themes/styles/theme_colors.dart';
class ResetPinScreen extends StatelessWidget {
  final User userResponse;
  ResetPinScreen({super.key, required this.userResponse});

  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  final AuthService _authService = AuthService();

  _onSetPIN(BuildContext context){
    if(_pinController.text.length<4){
      ToastMessage.show('Invalid PIN');
    }else if(_pinController.text != _confirmPinController.text){
      ToastMessage.show('PIN & confirm PIN mismatch.');
    } else{
      SetPinRequest setPinRequest = SetPinRequest(
        phoneNumber: userResponse.phoneNumber1,
        password: _pinController.text
      );
      _authService.setPin(setPinRequest, userResponse.sessionToken).then((response){
        if(response != null){
          final baseResponse =  BaseResponse.fromJson(response.data??'');
          ToastMessage.show(baseResponse.message);
          if(context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context,Routes.login, (route)=>false);
          }
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const KhAppBar(title: '',),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: LayoutBuilder(
          builder: (context,boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('set_pin.header',style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)).tr(),
                    const SizedBox(height: 8,),
                    Text('set_pin.description',style: theme.textTheme.titleSmall?.copyWith(color: ThemeColors.gray4),).tr(),
                    const SizedBox(height: 35,),
                    PinInputField.label(
                      label: 'set_pin.enter_pin',
                      controller: _pinController,
                      showPinIcon: true,
                      obscureText: true,),
                    const SizedBox(height: 20,),
                    PinInputField.label(
                        label: 'set_pin.confirm_pin',
                        controller: _confirmPinController,
                        showPinIcon: true,obscureText: true),
                  ],
                ),
                ElevatedButton(onPressed: ()=>_onSetPIN(context), child: const Text('set_pin.set_pin').tr())
              ],
            );
          }
        ),
      ),
    );
  }
}
