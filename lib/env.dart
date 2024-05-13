import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String d = _Env.d;
}
