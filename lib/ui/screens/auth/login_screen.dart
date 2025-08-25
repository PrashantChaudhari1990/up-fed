import 'dart:async';
import 'dart:convert';

import 'package:bttoa_ui/enums/enums.dart';
import 'package:bttoa_ui/models/auth/generate_otp_request.dart';
import 'package:bttoa_ui/services/auth/auth_service.dart';
import 'package:bttoa_ui/themes/styles/theme_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bttoa_ui/ui/screens/auth/tenant_selection_popup.dart';
import 'package:bttoa_ui/utils/app_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  List<Map<String, dynamic>> _sliderData = [];
  int _currentSliderIndex = 0;
  PageController _pageController = PageController();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _loadSliderData();
    Future.delayed(Duration.zero, () {
      AppLoader().hide();
      AppLoader().hide();
      AppLoader().hide();
    });
  }

  Future<void> _loadSliderData() async {
    AuthService authService = AuthService();
    final jsonResponse = await authService.sliderImages(context);
    // Decode JSON

    // TODO: Replace with actual API call
    try {
      //Example API call structure (uncomment when API is available):
      final response = await _authService.sliderImages(context);
      if (response != null && response.data != null) {
        final List<dynamic> sliderList = response.data['data'] ?? [];
        _sliderData = sliderList
            .map((item) => {
                  'index': item['index'] ?? 0,
                  'title': item['title'] ?? '',
                  'imageUrl': item['imageUrl'] ?? '',
                  'desc': item['desc'] ?? ''
                })
            .toList();
      }
      print(_sliderData);

      if (mounted) {
        setState(() {});
        _startAutoScroll();
      }
    } catch (error) {
      // Handle API error - keep dummy data
      if (mounted) {
        setState(() {});
        _startAutoScroll();
      }
    }
  }

  void _startAutoScroll() {
    if (_sliderData.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          int nextIndex = (_currentSliderIndex + 1) % _sliderData.length;
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _pageController.dispose();
    _stopAutoScroll();
    super.dispose();
  }

  //check for multiple tenent id check
  _preLogin() async {
    // Call pre-login API first
    try {
      AuthService authService = AuthService();
      final preLoginResponse =
          await authService.preLogin(context, _phoneNumberController.text);
      //final preLoginResponse = await AuthService.preLogin(context, 'mandar.naik@oorjaa.tech');
      final PreLoginResponse preLogin =
          PreLoginResponse.fromJson(preLoginResponse.data);

      if (preLogin.statusCode == 200 &&
          preLogin.data != null &&
          preLogin.data!.isNotEmpty) {
        if (preLogin.data!.length > 1) {
          // Multiple tenants - show selection popup
          _showTenantSelectionPopup(preLogin.data!);
        } else {
          // Single tenant - proceed directly
          final selectedTenant = preLogin.data!.first;
          // Save selected tenant information
          await AppSessionStorage()
              .setString(SessionKeys.tenantId, '${selectedTenant.tenantId}');
          CommonConstants.tenantId = '${selectedTenant.tenantId}';
          _onSubmitClick();
        }
      } else {
        if (mounted) {
          CustomSnackBar.error(
              context: context,
              message: preLogin.message ?? 'Pre-login failed');
        }
      }
    } catch (error) {
      if (mounted) {
        CustomSnackBar.error(
            context: context, message: 'Failed to verify user details');
      }
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
            CommonConstants.tenantId = '${selectedTenant.tenantId}';
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
          GenerateOtpRequest(mobileNumber: _phoneNumberController.text);
      _authService.generateOtp(generateOtpRequest).then((response) {
        if (response != null && response.data != null) {
          Map<String, dynamic> parsedJson = response.data;

          if (mounted) {
            //Navigator.of(context).pushNamed(Routes.otpVerification,arguments: '${ parsedJson["data"]["id"]}');
            Navigator.of(context).pushNamed(
              Routes.otpVerification,
              arguments: {
                'id': parsedJson["data"]["userId"],
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scrollbar(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text.rich(
                              TextSpan(text: ''.tr(), children: [
                                TextSpan(
                                    text: 'BTTOA',
                                    style: const TextStyle().copyWith(
                                        color: ThemeColors.primaryColor))
                              ]),
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Text(
                        //   _loginWith == LoginWith.otp
                        //       ? 'login.description.otp'
                        //       : 'login.description.pin',
                        //   style: theme.textTheme.titleSmall
                        //       ?.copyWith(color: ThemeColors.gray4),
                        // ).tr(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.43,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _sliderData.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentSliderIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final slider = _sliderData[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: slider['imageUrl'].isNotEmpty
                                            ? Container(
                                          margin: EdgeInsets.all(20),
                                              child: SvgPicture.network(
                                                  slider[
                                                      'imageUrl'], // your SVG URL
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  placeholderBuilder: (context) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(), // shows loader while fetching
                                                  ),
                                                ),
                                            )
                                            : Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/gallery_default.png"), // webp image
                                                    fit: BoxFit
                                                        .cover, // fullscreen background
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    if (slider['title'].isNotEmpty ||
                                        slider['desc'].isNotEmpty)
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // if (slider['title'].isNotEmpty)
                                              //   Text(
                                              //     slider['title'],
                                              //     style: theme.textTheme.titleMedium?.copyWith(
                                              //       fontWeight: FontWeight.bold,
                                              //       color: theme.colorScheme.onSurface,
                                              //     ),
                                              //     maxLines: 1,
                                              //     overflow: TextOverflow.ellipsis,
                                              //   ),
                                              if (slider['desc'].isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  slider['desc'],
                                                  style: theme.textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: ThemeColors.gray4,
                                                  ),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if (_sliderData.length > 1)
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _sliderData.length,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentSliderIndex == index
                                        ? ThemeColors.primaryColor
                                        : ThemeColors.gray4.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                        color: theme
                                            .colorScheme.onTertiaryContainer),
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
                                        color: theme
                                            .colorScheme.onTertiaryContainer),
                                    decoration: InputDecoration(
                                        counterText: '',
                                        hintText: "login.phone_number_hint".tr(),
                                        hintStyle: inputHintStyle.copyWith(
                                            color: theme.hintColor),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        fillColor:
                                            theme.colorScheme.tertiaryContainer,
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                      child: InkWell(
                                    onTap: () {
                                      _loadSliderData();
                                    },
                                    child: Text(
                                      "login.login_with",
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              color: ThemeColors.primaryColor),
                                    ).tr(),
                                  )),
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
                                          RadioMenuButton(
                                            value: LoginWith.pin,
                                            groupValue: _loginWith,
                                            onChanged: (value) {
                                              setState(() {
                                                _loginWith = LoginWith.pin;
                                              });
                                            },
                                            style: const ButtonStyle(
                                                splashFactory:
                                                    NoSplash.splashFactory),
                                            child: const Text("login.pin").tr(),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        // if (!widget.isRegistration)
                        //   Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: TextButton(
                        //         onPressed: () => _onForgotPin(context),
                        //         style: TextButton.styleFrom(
                        //             textStyle: linkTextStyleSmall),
                        //         child: const Text('validate_pin.forgot_pin').tr()),
                        //   ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _phoneNumberController,
                            builder: (context, value, _) {
                              return ElevatedButton(
                                  onPressed: value.text.length == 10
                                      ? _onSubmitClick
                                      : null,
                                  child: const Text('submit').tr());
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "POWERED BY ",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: ThemeColors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => const YourMainScreen()));
                              },
                              child: Text(
                                "OORJAA",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: ThemeColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
