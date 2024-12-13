import 'package:base_mobile_app/routes.dart';
import 'package:base_mobile_app/services/common_service.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:base_mobile_app/ui/screens/slider/slider_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../config/localization_config.dart';
import '../../../models/slider_details.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final _carouselIndex = ValueNotifier<int>(0);
  final commonService = CommonService();
  final List<SliderDetails> _carouselDataList = [];
  final _contentPadding = const EdgeInsets.symmetric(horizontal: 20);


  @override
  void initState() {
    commonService.getUiConstantByKey('SLIDER_DETAILS').then((response){
      if(response?.data != null && response?.data?.runtimeType == List){
      response.data.forEach((detail){
        _carouselDataList.add(SliderDetails.fromJson(detail));
      });
      setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 1,
              child: Stack(
                children: [
                  CarouselSlider(
                      items: List.generate(_carouselDataList.length, (i) => SliderItem(carouselSliderData: _carouselDataList[i])),
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            _carouselIndex.value = index;
                          },
                          autoPlay: true,
                          viewportFraction: 1,
                          height: double.maxFinite)),
                  Positioned(
                    top: kToolbarHeight-10,
                    child: Container(
                      width: screenSize.width,
                      padding: _contentPadding,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/images/svg/app_header_logo.svg'),
                          IconButton(onPressed: ()=>LocalizationConfig.changeLang(context),
                              icon: SvgPicture.asset('assets/icons/translation_icon.svg'))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Column(
              children: [
                if(_carouselDataList.isNotEmpty)
                Align(
                  alignment: Alignment.topLeft,
                  child: ValueListenableBuilder(
                    valueListenable: _carouselIndex,
                    builder: (BuildContext context, int value, Widget? child) {
                      return AnimatedSmoothIndicator(
                          effect: ExpandingDotsEffect(
                              expansionFactor: 2.5,
                              dotHeight: 10,
                              dotWidth: 10,
                              activeDotColor: ThemeColors.primaryColor
                          ),
                          activeIndex: value,
                          count: _carouselDataList.length);
                    },
                  ),
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: OutlinedButton(
                          onPressed: () async {
                            Navigator.of(context).pushReplacementNamed(Routes.login);
                          },
                          child: const Text('get_started').tr(),
                        )),
                    const SizedBox(width: 16,),
                    Flexible(
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pushNamed(Routes.home);
                            },
                            child: const Text('sign_up').tr()))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
