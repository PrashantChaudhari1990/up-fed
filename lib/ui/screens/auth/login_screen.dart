import 'dart:convert';

import 'package:base_mobile_app/enums/enums.dart';
import 'package:base_mobile_app/models/auth/generate_otp_request.dart';
import 'package:base_mobile_app/models/auth/generate_otp_response.dart';
import 'package:base_mobile_app/services/auth/auth_service.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../routes.dart';
import '../../../themes/styles/typography.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  LoginWith _loginWith = LoginWith.otp;
  final _authService= AuthService();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }


  _onSubmitClick(){
    FocusScope.of(context).unfocus();
    if(_loginWith  == LoginWith.otp){
      final generateOtpRequest = GenerateOtpRequest(phoneNumber: "+91${_phoneNumberController.text}");
      _authService.generateOtp(generateOtpRequest).then((response){
        if(response != null && response.data != null){
          GenerateOtpResponse generateOtpResponse = GenerateOtpResponse.fromJson(response.data);
          if(generateOtpResponse.existingUser??false){
            if(mounted){
              Navigator.of(context).pushNamed(Routes.otpVerification,arguments: _phoneNumberController.text);
            }
          }
        }
      });
      // Navigator.of(context).pushNamed(Routes.otpVerification,arguments: _phoneNumberController.text);
    }else{
      Navigator.of(context).pushNamed(Routes.validatePin,arguments: _phoneNumberController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: theme.scaffoldBackgroundColor
        ),
      ),
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('login.header'.tr(),style: theme.textTheme.headlineSmall,),
                  const SizedBox(height: 10,),
                  Text('login.description',style: theme.textTheme.titleSmall?.copyWith(color: ThemeColors.gray4),).tr(),
                  const SizedBox(height: 40,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('login.phone_number',style: theme.textTheme.bodySmall?.copyWith(color: ThemeColors.gray4),).tr(),
                      const SizedBox(height: 4,),
                      Row(
                        children: [
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: ThemeColors.gray1,
                              borderRadius: BorderRadius.circular(4)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                            child: Text('+91',style: inputTextStyle.copyWith(color: theme.colorScheme.onTertiaryContainer),),
                          ),
                          const SizedBox(width: 8,),
                          Flexible(
                            child: TextField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: inputTextStyle.copyWith(color: theme.colorScheme.onTertiaryContainer),
                              decoration: InputDecoration(
                                  counterText: '',
                                  hintText: "login.phone_number_hint".tr(),
                                  hintStyle: inputHintStyle.copyWith(color: theme.hintColor),
                                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                                  fillColor: theme.colorScheme.tertiaryContainer,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  constraints: const BoxConstraints(maxHeight: 44)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 25,),
                  Card(
                    elevation: 0,
                    color: ThemeColors.gray1,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Flexible(
                              child: Text(
                            "login.login_with",
                            style: theme.textTheme.titleMedium?.copyWith(color: ThemeColors.primaryColor),
                          ).tr()),
                          Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  RadioMenuButton(
                                    style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                                    value: LoginWith.otp,
                                    groupValue: _loginWith,
                                    onChanged: (value) {
                                      setState(() {
                                        _loginWith = LoginWith.otp;
                                      });
                                    },
                                    child: const Text("login.otp").tr(),
                                  ),
                                  RadioMenuButton(
                                    value: LoginWith.pin,
                                    groupValue: _loginWith,
                                    onChanged: (value) {
                                      setState(() {
                                        _loginWith = LoginWith.pin;
                                      });
                                    },
                                    style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                                    child: const Text("login.pin").tr(),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              ValueListenableBuilder(
                valueListenable: _phoneNumberController,
                builder: (context,value,_) {
                  return ElevatedButton(
                      onPressed: value.text.length==10 ? _onSubmitClick:null,
                      child: const Text('submit').tr());
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
