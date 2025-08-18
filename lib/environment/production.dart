import 'environment.dart';

class Production extends Environment {
  Production()
      : super(
            baseUrl: 'vas-connect-api.oorjaa.tech',
            webAppUrl: 'https://bttoa-connect.oorjaa.tech',
            appUpdate: true);
}
