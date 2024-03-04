import 'package:envied/envied.dart';

part 'env_model.g.dart';

@Envied(path: ".env")
class Env {
  @EnviedField(varName: "GOOGLE_MAP_API_KEY", obfuscate: true)
  static final String googleMapApiKey = _Env.googleMapApiKey;

  @EnviedField(varName: "CLOUD_MAP_ID", obfuscate: true)
  static final String cloudMapID = _Env.cloudMapID;
}
