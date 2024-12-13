
/// Enum [EnvironmentType] is use to set configure environment
enum EnvironmentType { develop, staging, production }


abstract class Environment {
  final String baseUrl;
  final bool appUpdate;
  final String webAppUrl;

  Environment({
    required this.baseUrl,
    required this.webAppUrl,
    this.appUpdate=false
  });
}
