import 'environment.dart';

class Development extends Environment{
  Development() : super(
      baseUrl: 'https://tms-api.dev.oorjaa.tech',
      webAppUrl: 'https://vendor-partner.dev.oorjaa.tech' //not confirm
  );
}