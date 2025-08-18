import 'environment.dart';

class Staging extends Environment {
  Staging()
      : super(
            baseUrl: 'https://tms-api.stage.oorjaa.tech',
            webAppUrl: 'bttoa.stage.oorjaa.tech');
}
