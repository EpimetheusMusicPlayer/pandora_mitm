import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitmPlugin] that strips boilerplate fields from API messages for
/// readability purposes.
abstract class BoilerplateStripperPlugin implements PandoraMitmPlugin {
  abstract bool stripBoilerplate;
}
