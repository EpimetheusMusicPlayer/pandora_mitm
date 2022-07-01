import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/plugins/inference.dart';

class BackgroundInferencePlugin
    extends ForegroundBuildingBackgroundBasePlugin<InferencePlugin> {
  @override
  ForegroundBuildingBackgroundPluginIsolateEntrypoint<InferencePlugin>
      get isolateEntrypoint => BackgroundInferencePluginHost.new;

  @override
  InferencePlugin buildPlugin() => InferencePlugin();
}

class BackgroundInferencePluginHost
    extends ForegroundBuildingBackgroundPluginHost<InferencePlugin> {
  BackgroundInferencePluginHost(super.payload);
}
