import 'environment.dart';

class Production extends Environment {
  Production()
      : super(
      baseUrl: 'https://vas-connect-api.oorjaa.tech',
      webAppUrl: 'https://bttoa-connect.oorjaa.tech',
      appUpdate: true);
}
