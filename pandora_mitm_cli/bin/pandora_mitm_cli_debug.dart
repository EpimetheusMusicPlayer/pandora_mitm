import 'package:hotreloader/hotreloader.dart';
import 'package:pandora_mitm_cli/pandora_mitm_cli.dart' as pmcli;

void main(List<String> arguments) async {
  final reloader = await HotReloader.create();
  await pmcli.run('standard', arguments);
  await reloader.stop();
}
