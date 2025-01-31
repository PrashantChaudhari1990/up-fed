import 'environment.dart';

class Staging extends Environment{
  Staging() : super(
      baseUrl: 'http://74.225.188.40:8006',
      webAppUrl: 'http://www.kh-shop.stage.oorjaa.tech'
  );
}