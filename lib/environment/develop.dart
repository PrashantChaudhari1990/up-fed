import 'environment.dart';

class Development extends Environment{
  Development() : super(
      baseUrl: 'http://api.shared-tp.dev.oorjaa.tech:8006',
      webAppUrl: 'http://www.kh-shop.dev.oorjaa.tech'
  );
}