import 'package:vendor_partner/enums/enums.dart';
import 'package:vendor_partner/models/auth/generate_otp_request.dart';
import 'package:vendor_partner/models/auth/generate_otp_response.dart';
import 'package:vendor_partner/services/auth/auth_service.dart';
import 'package:vendor_partner/themes/styles/theme_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendor_partner/ui/screens/auth/tenant_selection_popup.dart';
import 'package:vendor_partner/utils/app_loader.dart';
import '../../../constant/common_constants.dart';
import '../../../constant/session_keys.dart';
import '../../../models/pre_login_response.dart';
import '../../../routes.dart';
import '../../../themes/styles/typography.dart';
import '../../../utils/app_session_storage.dart';
import '../../shared_widget/custom_snackbar.dart';
import 'forgot_pin_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  final bool isRegistration;
  const LoginScreen({super.key}) : isRegistration = false;

  const LoginScreen.register({super.key}) : isRegistration = true;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  LoginWith _loginWith = LoginWith.otp;
  final _authService = AuthService();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      AppLoader().hide();
      AppLoader().hide();
      AppLoader().hide();
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  _preLogin() async {

      // Call pre-login API first
      try {
        AuthService authService=AuthService();
        final preLoginResponse = await authService.preLogin(context, _phoneNumberController.text);
        //final preLoginResponse = await AuthService.preLogin(context, 'mandar.naik@oorjaa.tech');
        final PreLoginResponse preLogin = PreLoginResponse.fromJson(preLoginResponse.data);

        if (preLogin.statusCode == 200 && preLogin.data != null && preLogin.data!.isNotEmpty) {
          if (preLogin.data!.length > 1) {
            // Multiple tenants - show selection popup
            _showTenantSelectionPopup(preLogin.data!);
          } else {
            // Single tenant - proceed directly
            final selectedTenant = preLogin.data!.first;
            // Save selected tenant information
            await AppSessionStorage()
                .setString(SessionKeys.tenantId, '${selectedTenant.tenantId}');
            CommonConstants.tenantId= '${selectedTenant.tenantId}';
            print( CommonConstants.tenantId);
            _onSubmitClick();
          }
        } else {

          CustomSnackBar.error(context: context, message: preLogin.message ?? 'Pre-login failed');
        }
      } catch (error) {
        CustomSnackBar.error(context: context, message: 'Failed to verify user details');
      }
    }
  void _showTenantSelectionPopup(List<UserData> tenants) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TenantSelectionPopup(
          tenants: tenants,
          onTenantSelected: (UserData selectedTenant) async {
            // Save selected tenant information
            await AppSessionStorage()
                .setString(SessionKeys.tenantId, '${selectedTenant.tenantId}');
            CommonConstants.tenantId= '${selectedTenant.tenantId}';
            _onSubmitClick();
          },
        );
      },
    );
  }
  _onSubmitClick() {
    FocusScope.of(context).unfocus();
    if (_loginWith == LoginWith.otp) {
      final generateOtpRequest =
          GenerateOtpRequest(phoneNumber: _phoneNumberController.text);
      _authService.generateOtp(generateOtpRequest).then((response) {
        if (response != null && response.data != null) {
          Map<String, dynamic> parsedJson = response.data;

          if (mounted) {
            //Navigator.of(context).pushNamed(Routes.otpVerification,arguments: '${ parsedJson["data"]["id"]}');
            Navigator.of(context).pushNamed(
              Routes.otpVerification,
              arguments: {
                'id': parsedJson["data"]["id"],
                'phoneNo': _phoneNumberController.text,
              },
            );
          }
        }
      });
    } else {
      Navigator.of(context).pushNamed(Routes.validatePin,
          arguments: _phoneNumberController.text);
    }
  }

  _onForgotPin(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return const ForgotPinModel();
        });
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
            systemNavigationBarColor: theme.scaffoldBackgroundColor),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                      TextSpan(text: 'login.header'.tr(), children: [
                        TextSpan(
                            text: ' ${'login.header1'.tr()}',
                            style: const TextStyle()
                                .copyWith(color: ThemeColors.primaryColor))
                      ]),
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _loginWith == LoginWith.otp
                        ? 'login.description.otp'
                        : 'login.description.pin',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: ThemeColors.gray4),
                  ).tr(),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'login.phone_number',
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
                              autofocus: false,
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^[0]'))
                              ],
                              style: inputTextStyle.copyWith(
                                  color: theme.colorScheme.onTertiaryContainer),
                              decoration: InputDecoration(
                                  counterText: '',
                                  hintText: "login.phone_number_hint".tr(),
                                  hintStyle: inputHintStyle.copyWith(
                                      color: theme.hintColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(4)),
                                  fillColor:
                                      theme.colorScheme.tertiaryContainer,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  constraints:
                                      const BoxConstraints(maxHeight: 44)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (!widget.isRegistration)
                    Card(
                      elevation: 0,
                      color: ThemeColors.gray1,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Flexible(
                                child: Text(
                              "login.login_with",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(color: ThemeColors.primaryColor),
                            ).tr()),
                            Flexible(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RadioMenuButton(
                                      style: const ButtonStyle(
                                          splashFactory:
                                              NoSplash.splashFactory),
                                      value: LoginWith.otp,
                                      groupValue: _loginWith,
                                      onChanged: (value) {
                                        setState(() {
                                          _loginWith = LoginWith.otp;
                                        });
                                      },
                                      child: const Text("login.otp").tr(),
                                    ),
                                    // RadioMenuButton(
                                    //   value: LoginWith.pin,
                                    //   groupValue: _loginWith,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       _loginWith = LoginWith.pin;
                                    //     });
                                    //   },
                                    //   style: const ButtonStyle(
                                    //       splashFactory:
                                    //           NoSplash.splashFactory),
                                    //   child: const Text("login.pin").tr(),
                                    // ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  if (!widget.isRegistration)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () => _onForgotPin(context),
                          style: TextButton.styleFrom(
                              textStyle: linkTextStyleSmall),
                          child: const Text('validate_pin.forgot_pin').tr()),
                    ),
                ],
              ),
              ValueListenableBuilder(
                  valueListenable: _phoneNumberController,
                  builder: (context, value, _) {
                    return ElevatedButton(
                        onPressed:
                            value.text.length == 10 ? _preLogin : null,
                        child: const Text('submit').tr());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
