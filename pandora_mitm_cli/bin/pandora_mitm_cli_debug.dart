// This is a easily debuggable pandora_mitm_cli script that's designed to
// provide rapid debugging functionality.
//
// It enables hot reload and custom plugin injection, and provides a
// hot-reload-compatible debugging HTTP server to perform actions when HTTP
// requests are received.

import 'dart:async';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:hotreloader/hotreloader.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm_cli/pandora_mitm_cli.dart' as pmcli;

// DEBUG: Uncomment the imports below to use inbuilt plugins.
// import 'package:pandora_mitm/plugins.dart' as pmplg;
// import 'package:pandora_mitm_extra/plugins.dart' as pmeplg;

PandoraMitmPlugin _buildTestPlugin() =>
    // DEBUG: Construct a plugin to test here.
    TestPlugin();

Future<void> _handleDebugServerRequest(
  HttpRequest request,
  PluginCapablePandoraMitm pandoraMitm,
) async {
  // ignore: unused_element
  T? plugin<T extends PandoraMitmPlugin>() => pandoraMitm.pluginManager.plugins
      .cast<PandoraMitmPlugin?>()
      .firstWhere((plugin) => plugin is T, orElse: () => null) as T?;

  Object? result;
  switch (request.uri.pathSegments.join('/')) {
    // DEBUG: Add custom debug methods here.
    //        Set [result] to send a value over HTTP.
    case 'stop':
      await pandoraMitm.disconnect();
      break;
    case '':
    default:
      request.response
        ..statusCode = HttpStatus.notFound
        ..writeln('404')
        ..close();
      return;
  }
  request.response.statusCode = HttpStatus.ok;
  // ignore: unnecessary_null_comparison
  if (result != null) {
    request.response.writeln(result);
  }
  request.response.close();
}

// DEBUG: Implement a test plugin here.
class TestPlugin extends PandoraMitmPlugin {
  @override
  // ignore: unnecessary_overrides
  FutureOr<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      super.getRequestSetSettings(
        flowId,
        apiMethod,
        requestSummary,
        responseSummary,
      );

  @override
  // ignore: unnecessary_overrides
  FutureOr<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      super.getResponseSetSettings(
        flowId,
        apiMethod,
        requestSummary,
        responseSummary,
      );

  @override
  // ignore: unnecessary_overrides
  FutureOr<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      super.handleRequest(flowId, apiRequest, response);

  @override
  // ignore: unnecessary_overrides
  FutureOr<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      super.handleResponse(flowId, apiRequest, response);
}

void main(List<String> arguments) async {
  final reloader = await HotReloader.create();
  final serverCompleter = Completer<HttpServer>();
  await pmcli.run(
    'debug',
    arguments,
    extraPluginEntries: const [TestPluginEntry(_buildTestPlugin)],
    onConnect: (pandoraMitm) async {
      serverCompleter.complete(
        await HttpServer.bind(InternetAddress.loopbackIPv6, 8070)
          ..listen(
            (request) => _handleDebugServerRequest(request, pandoraMitm),
          ),
      );
      final server = await serverCompleter.future;
      stdout.writeln(
        'Debug server started on ${server.address.host}:${server.port}.',
      );
    },
  );
  await (await serverCompleter.future).close();
  await reloader.stop();
}

class TestPluginEntry<P extends PandoraMitmPlugin> extends pmcli.PluginEntry {
  final P Function() pluginFactory;

  const TestPluginEntry(this.pluginFactory);

  @override
  String get name => 'test_plugin';

  @override
  String get description => 'A plugin to test.';

  @override
  bool get largePotentialImpact => true;

  @override
  P create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      pluginFactory();
}
