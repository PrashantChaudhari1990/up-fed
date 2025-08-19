import 'dart:async';
import 'dart:convert';
import 'package:bttoa_ui/constant/session_keys.dart';
import 'package:bttoa_ui/models/auth/generate_otp_request.dart';
import 'package:bttoa_ui/models/auth/validate_otp_request.dart';
import 'package:bttoa_ui/models/user.dart';
import 'package:bttoa_ui/routes.dart';
import 'package:bttoa_ui/services/auth/auth_service.dart';
import 'package:bttoa_ui/themes/styles/theme_colors.dart';
import 'package:bttoa_ui/ui/shared_widget/pin_input_field.dart';
import 'package:bttoa_ui/utils/app_session_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bttoa_ui/utils/device_info.dart';
import 'package:bttoa_ui/utils/toast_message.dart';
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

  String userId = '', phoneNumber = '';

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
    if (_timer?.isActive ?? false) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendOtpCountDown.value > 0) {
        _resendOtpCountDown.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  _onSubmitOtp(String phoneNumber) async {
    final deviceDetails = await DeviceInfo.getDetail();
    final validateOtpRequest = ValidateOtpRequest(
        userId: userId,mobileNumber:'+91$phoneNumber',otpCode: _otpController.text, deviceDetail: deviceDetails);
    _authService.validateOtp(validateOtpRequest).then((response) async {
      if (response != null) {
        if (response.data['success'] == true) {
          final userResponse = User.fromJson(response.data);
          if (userResponse.data!.loginResponse!.userId != null) {
            await AppSessionStorage()
                .setString(SessionKeys.user, jsonEncode(response.data["data"]["loginResponse"]));
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.home, (route) => false);
            }
          } else {
            if (mounted) {
              //Dashboard
              Navigator.pushReplacementNamed(context, Routes.home,
                  arguments: userId);
            }
          }
        } else {
          ToastMessage.show(response.data['message']);
        }
      }
    });
  }

  _onEditPhoneNumber() {
    Navigator.pop(context);
  }

  _onResendOtp(String phoneNumber) {
    _resendOtpCountDown.value = 59;
    _startOtpCountdown();
    _authService
        .generateOtp(GenerateOtpRequest(mobileNumber: "91$phoneNumber"))
        .then((response) {
      if (response != null && response.data != null) {
        ToastMessage.show(tr('otp_verification.resend_message'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      phoneNumber = '${args['phoneNo']}';
      userId = '${args['id']}';
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/icons/back_arrow.svg",
              fit: BoxFit.scaleDown,
            )),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: theme.scaffoldBackgroundColor),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                    TextSpan(text: 'otp_verification.enter'.tr(), children: [
                      TextSpan(
                          text: ' ${'otp_verification.otp'.tr()}',
                          style: const TextStyle()
                              .copyWith(color: ThemeColors.primaryColor))
                    ]),
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'otp_verification.description',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: ThemeColors.gray4),
                ).tr(),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: _onEditPhoneNumber,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+91 $phoneNumber',
                        style: linkTextStyleSmall,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        'assets/icons/edit_icon.svg',
                        colorFilter: ColorFilter.mode(
                          ThemeColors.primaryColor,
                          BlendMode.srcIn,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinInputField.label(
                        autofocus: true,
                        label: 'otp_verification.otp',
                        controller: _otpController),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'otp_verification.hint',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: ThemeColors.black),
                        ).tr()),
                    ValueListenableBuilder(
                        valueListenable: _resendOtpCountDown,
                        builder: (context, value, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: value > 0
                                      ? null
                                      : () => _onResendOtp(phoneNumber),
                                  style: TextButton.styleFrom(
                                      textStyle: linkTextStyleSmall),
                                  child:
                                      const Text('otp_verification.resend_otp')
                                          .tr()),
                              if (value > 0)
                                Text(
                                  'otp_verification.in_sec_count',
                                  style: inputHintStyle.copyWith(
                                      color: theme.hintColor),
                                ).tr(args: ['$value'])
                            ],
                          );
                        }),
                  ],
                )
              ],
            ),
            ValueListenableBuilder(
                valueListenable: _otpController,
                builder: (context, value, _) {
                  return ElevatedButton(
                      onPressed: value.text.length == 4
                          ? () => _onSubmitOtp(phoneNumber)
                          : null,
                      child: const Text('submit').tr());
                })
            ],
          ),
        ),
      ),
    );
  }
}
