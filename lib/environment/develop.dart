import 'environment.dart';

class Development extends Environment{
  Development() : super(
      baseUrl: 'https://dev.oorjaa.tech:8089',
      webAppUrl: 'https://vendor-partner.stage.oorjaa.tech'
      // webAppUrl: 'http://192.168.1.100:4001'
  );
}