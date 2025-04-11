import 'package:vendor_partner/environment/develop.dart';
import 'package:vendor_partner/environment/production.dart';
import 'package:vendor_partner/environment/staging.dart';
import '../environment/environment.dart';

const EnvironmentType _environmentType = EnvironmentType.staging;

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
