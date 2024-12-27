import 'dart:async';
import 'dart:convert';
import 'package:base_mobile_app/constant/session_keys.dart';
import 'package:base_mobile_app/models/auth/validate_otp_request.dart';
import 'package:base_mobile_app/models/user.dart';
import 'package:base_mobile_app/routes.dart';
import 'package:base_mobile_app/services/auth/auth_service.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:base_mobile_app/ui/shared_widget/pin_input_field.dart';
import 'package:base_mobile_app/utils/app_session_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../config/notification_config.dart';
import '../../../themes/styles/typography.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  final _resendOtpCountDown = ValueNotifier<int>(59);
  final _authService = AuthService();

  @override
  void initState() {
    _startOtpCountdown();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendOtpCountDown.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startOtpCountdown() {
    if(_timer?.isActive??false){
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_resendOtpCountDown.value > 0){
        _resendOtpCountDown.value--;
      }else{
        _timer?.cancel();
      }
    });
  }

  _onSubmitOtp(String phoneNumber) async {
    final fcmToken =  await NotificationConfig.fcmToken;
    final validateOtpRequest  = ValidateOtpRequest(phoneNumber: "+91$phoneNumber",otp: _otpController.text,fcmToken: fcmToken);
   _authService.validateOtp(validateOtpRequest).then((response) async {
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
  _onEditPhoneNumber(){
    Navigator.pop(context);
  }
  _onResendOtp(){
    _resendOtpCountDown.value=59;
    _startOtpCountdown();
  }


  @override
  Widget build(BuildContext context) {
    final String phoneNumber = (ModalRoute.of(context)?.settings.arguments??'') as String;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: ()=>Navigator.pop(context),
            child: SvgPicture.asset("assets/icons/back_arrow.svg",fit: BoxFit.scaleDown,)),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: theme.scaffoldBackgroundColor
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('otp_verification.header'.tr(),style: theme.textTheme.headlineSmall,),
                const SizedBox(height: 10,),
                Text('otp_verification.description',style: theme.textTheme.titleSmall?.copyWith(color: ThemeColors.gray4),).tr(),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: _onEditPhoneNumber,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('+91 $phoneNumber',style: linkTextStyleSmall,),
                      const SizedBox(width: 8,),
                      SvgPicture.asset('assets/icons/edit_icon.svg',)
                    ],
                  ),
                ),
                const SizedBox(height: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinInputField.label(
                      label: 'otp_verification.otp',
                      controller: _otpController
                    ),
                    const SizedBox(height: 4,),
                    ValueListenableBuilder(
                        valueListenable: _resendOtpCountDown,
                        builder: (context,value,_) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(onPressed:value > 0 ? null : _onResendOtp,
                                  style: TextButton.styleFrom(
                                      textStyle: linkTextStyleSmall),
                                  child: const Text('otp_verification.resend_otp').tr()),
                              if(value>0)
                              Text('otp_verification.in_sec_count',style: inputHintStyle.copyWith(color: theme.hintColor),).tr(args: ['$value'])
                            ],
                          );
                        }
                    ),
                  ],
                )
              ],
            ),
            ValueListenableBuilder(
                valueListenable: _otpController,
                builder: (context,value,_) {
                  return ElevatedButton(
                      onPressed: value.text.length==4 ? ()=>_onSubmitOtp(phoneNumber) : null,
                      child: const Text('submit').tr());
                }
            )
          ],
        ),
      ),
    );
  }
}