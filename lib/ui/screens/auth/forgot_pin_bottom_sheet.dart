import 'package:supervisor_ui/models/auth/generate_otp_request.dart';
import 'package:supervisor_ui/models/auth/generate_otp_response.dart';
import 'package:supervisor_ui/models/auth/validate_otp_request.dart';
import 'package:supervisor_ui/services/auth/auth_service.dart';
import 'package:supervisor_ui/themes/styles/theme_colors.dart';
import 'package:supervisor_ui/ui/screens/auth/set_pin_screen.dart';
import 'package:supervisor_ui/ui/shared_widget/pin_input_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/user.dart';
import '../../../themes/styles/typography.dart';

class ForgotPinModel extends StatefulWidget {
  const ForgotPinModel({super.key});

  @override
  State<ForgotPinModel> createState() => _ForgotPinModelState();
}

class _ForgotPinModelState extends State<ForgotPinModel> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _authService = AuthService();
  GenerateOtpResponse? generateOtpResponse;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  _onSubmitClick() {
    FocusScope.of(context).unfocus();
    final generateOtpRequest =
        GenerateOtpRequest(phoneNumber: "+91${_phoneNumberController.text}");
    _authService.forgotPin(generateOtpRequest).then((response) {
      if (response != null && response.data != null) {
        generateOtpResponse = GenerateOtpResponse.fromJson(response.data);
        setState(() {});
      }
    });
  }

  _onValidateOTP() {
    ValidateOtpRequest validateOtpRequest = ValidateOtpRequest(
        phoneNumber: generateOtpResponse?.phoneNumber,
        otp: _otpController.text);
    _authService.validateOtp(validateOtpRequest).then((response) async {
      if (response != null) {
        final userResponse = User.fromJson(response.data);
        if (userResponse.id != null) {
          if (mounted) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResetPinScreen(
                          userResponse: userResponse,
                        )));
          }
        }
      }
    });
  }

  bool get otpVisible {
    return (generateOtpResponse?.existingUser ?? false) &&
        generateOtpResponse?.phoneNumber == "+91${_phoneNumberController.text}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + mediaQuery.viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                        TextSpan(text: 'forgot_pin.forgot'.tr(), children: [
                          TextSpan(
                              text: ' ${'forgot_pin.pin'.tr()}',
                              style: const TextStyle()
                                  .copyWith(color: ThemeColors.primaryColor))
                        ]),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.zero,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'forgot_pin.phone_number',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: ThemeColors.gray4),
                    ).tr(),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                              color: ThemeColors.gray1,
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            '+91',
                            style: inputTextStyle.copyWith(
                                color: theme.colorScheme.onTertiaryContainer),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            enabled: !otpVisible,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(RegExp(r'^[0]'))
                            ],
                            style: inputTextStyle.copyWith(
                                color: theme.colorScheme.onTertiaryContainer),
                            decoration: InputDecoration(
                                counterText: '',
                                hintText: "forgot_pin.phone_number_hint".tr(),
                                hintStyle: inputHintStyle.copyWith(
                                    color: theme.hintColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(4)),
                                fillColor: theme.colorScheme.tertiaryContainer,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                constraints:
                                    const BoxConstraints(maxHeight: 44)),
                          ),
                        ),
                        if (otpVisible)
                          IconButton(
                            onPressed: () {
                              generateOtpResponse = null;
                              _otpController.clear();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.edit_square,
                              size: 18,
                              color: Colors.black,
                            ),
                          )
                      ],
                    ),
                    if (otpVisible)
                      const SizedBox(
                        height: 30,
                      ),
                    if (otpVisible)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: PinInputField.label(
                          label: 'enter_otp',
                          controller: _otpController,
                          obscureText: true,
                        ),
                      )
                  ],
                )
              ],
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.1,
            ),
            Visibility(
                visible: otpVisible,
                replacement: ValueListenableBuilder(
                    valueListenable: _phoneNumberController,
                    builder: (context, value, _) {
                      return ElevatedButton(
                          onPressed:
                              value.text.length == 10 ? _onSubmitClick : null,
                          child: const Text('send_otp').tr());
                    }),
                child: ValueListenableBuilder(
                    valueListenable: _otpController,
                    builder: (context, value, _) {
                      return ElevatedButton(
                          onPressed:
                              value.text.length == 4 ? _onValidateOTP : null,
                          child: const Text('submit').tr());
                    }))
          ],
        ),
      ),
    );
  }
}
