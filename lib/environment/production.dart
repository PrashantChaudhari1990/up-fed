import 'environment.dart';

class Production extends Environment {
  Production()
      : super(
            baseUrl: 'https://tms-api.oorjaa.tech',
            webAppUrl: 'https://vendor-partner.oorjaa.tech',
            appUpdate: true);
}
