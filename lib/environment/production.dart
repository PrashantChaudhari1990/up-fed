import 'environment.dart';

class Production extends Environment {
  Production()
      : super(
      baseUrl: 'https://vas-connect-api.oorjaa.tech',
      webAppUrl: 'https://bttoa-connect.oorjaa.tech',
      //webAppUrl: 'http://10.190.191.91:4400',
      appUpdate: true);
}
