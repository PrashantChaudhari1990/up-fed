import 'package:base_mobile_app/environment/develop.dart';
import 'package:base_mobile_app/environment/production.dart';
import 'package:base_mobile_app/environment/staging.dart';
import '../environment/environment.dart';

const EnvironmentType _environmentType = EnvironmentType.develop;

Environment get environment {
  switch (_environmentType) {
    case EnvironmentType.develop:
      return Development();
    case EnvironmentType.staging:
      return Staging();
    case EnvironmentType.production:
      return Production();
    default:
      return Development();
  }
}
