import 'dart:convert';
import 'package:base_mobile_app/models/auth/login_request.dart';
import 'package:base_mobile_app/services/auth/auth_service.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:base_mobile_app/ui/shared_widget/kh_app_bar.dart';
import 'package:base_mobile_app/utils/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constant/session_keys.dart';
import '../../../models/user.dart';
import '../../../routes.dart';
import '../../../utils/app_session_storage.dart';
import '../../shared_widget/pin_input_field.dart';

class ValidatePinScreen extends StatefulWidget {
  const ValidatePinScreen({super.key});

  @override
  State<ValidatePinScreen> createState() => _ValidatePinScreenState();
}

class _ValidatePinScreenState extends State<ValidatePinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  _onSubmitPin(String phoneNumber) async {
    final deviceDetails = await DeviceInfo.getDetail();
    LoginRequest loginRequest = LoginRequest(
      username: "+91$phoneNumber",
      password: _pinController.text,
      deviceDetails: deviceDetails
    );
    _authService.login(loginRequest).then((response) async {
      if(response != null){
        final userResponse = User.fromJson(response.data);
        if(userResponse.existingUser??false){
          await AppSessionStorage().setString(SessionKeys.user, jsonEncode(response.data));
          if(mounted){
            Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route)=>false);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = (ModalRoute.of(context)?.settings.arguments??'') as String;
    final theme = Theme.of(context);
    return Scaffold(
      appBar:const KhAppBar(title: '',),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('validate_pin.header'.tr(),style: theme.textTheme.headlineSmall,),
                const SizedBox(height: 10,),
                Text('validate_pin.description',style: theme.textTheme.titleSmall?.copyWith(color: ThemeColors.gray4),).tr(),
                const SizedBox(height: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinInputField.label(
                      label: "validate_pin.pin",
                        controller: _pinController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 4,)
                  ],
                )
              ],
            ),
            ValueListenableBuilder(
                valueListenable: _pinController,
                builder: (context,value,_) {
                  return ElevatedButton(
                      onPressed: value.text.length==4 ? ()=>_onSubmitPin(phoneNumber) : null,
                      child: const Text('submit').tr());
                }
            )
          ]
        ),
      ),
    );
  }
}