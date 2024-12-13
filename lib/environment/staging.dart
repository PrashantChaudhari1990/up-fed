import 'environment.dart';

class Staging extends Environment{
  Staging() : super(
      baseUrl: 'https://stage.oorjaa.tech',
      webAppUrl: 'http://dev.oorjaa.tech/oorjaa'
  );
}