import 'package:mhassoc_ui/environment/develop.dart';
import 'package:mhassoc_ui/environment/production.dart';
import 'package:mhassoc_ui/environment/staging.dart';
import '../environment/environment.dart';

const EnvironmentType _environmentType = EnvironmentType.production;
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