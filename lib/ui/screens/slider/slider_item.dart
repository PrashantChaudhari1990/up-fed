import 'package:flutter/material.dart';
import 'package:kh_dealer_app/config/server_config.dart';
import '../../../models/slider_details.dart';
class SliderItem extends StatelessWidget {
  final SliderDetails carouselSliderData;
  final _contentPadding = const EdgeInsets.symmetric(horizontal: 20);

   const SliderItem({required this.carouselSliderData, super.key});
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme =  Theme.of(context);
    return Stack(
      children: [
        SizedBox(
          height: screenSize.height,
          child: Image.network(carouselSliderData.imageUrl??'',width: screenSize.width,fit: BoxFit.fill,
          headers: {
            "referer":"${environment.webAppUrl}/"
          },
          errorBuilder: (context,object,stacktrace)=>const Center(child: Text('Image'),),
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              width: screenSize.width,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white10,Colors.white38,Colors.white60,Colors.white])
              ),
            )),
        if(carouselSliderData.description != null)
        Positioned(
          bottom: 10,
            child: Container(
              width: screenSize.width,
              padding: _contentPadding,
              child: Text(carouselSliderData.description??"",style:theme.textTheme.titleLarge,),
            )),
      ],
    );
  }
}
