import 'environment.dart';

class Development extends Environment {
  Development()
      : super(
            baseUrl: 'https://tms-api.dev.oorjaa.tech',
            webAppUrl: 'supervisor.dev.oorjaa.tech');
}
