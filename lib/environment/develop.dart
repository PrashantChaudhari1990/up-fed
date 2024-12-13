import 'environment.dart';

class Development extends Environment{
  Development() : super(
      baseUrl: 'http://35.207.242.244:8085',
      webAppUrl: 'http://192.168.1.109:5001'
  );
}