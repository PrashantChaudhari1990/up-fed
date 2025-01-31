import 'environment.dart';

class Development extends Environment{
  Development() : super(
      baseUrl: 'http://74.225.167.178:8006',
      webAppUrl: 'http://www.kh-shop.dev.oorjaa.tech'
      // webAppUrl: 'http://192.168.1.100:4001'
  );
}