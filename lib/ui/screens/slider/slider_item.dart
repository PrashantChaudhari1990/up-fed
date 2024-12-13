import 'package:flutter/material.dart';
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
        Image.network(carouselSliderData.imageUrl??'',width: screenSize.width,fit: BoxFit.fill,
        errorBuilder: (context,object,stacktrace)=>const Center(child: Text('Slider Image')),
        ),
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
