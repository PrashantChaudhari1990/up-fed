import 'environment.dart';

class Production extends Environment{
  Production() : super(
      baseUrl: 'https://prod.oorjaa.tech',
      webAppUrl: 'http://dev.oorjaa.tech/oorjaa',
      appUpdate: true
  );
}