import 'environment.dart';

class Development extends Environment {
  Development()
      : super(
            baseUrl: 'https://vas-connect-api.dev.oorjaa.tech',
      webAppUrl: 'https://bttoa-connect.oorjaa.tech',
            // webAppUrl: 'http://localhost:4500'
  );
}
