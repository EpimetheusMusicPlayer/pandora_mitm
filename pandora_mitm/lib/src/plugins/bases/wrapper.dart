import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/plugins/group.dart';

/// A [PandoraMitmPlugin] implementation that wraps another [PandoraMitmPlugin].
///
/// This plugin base is useful to extend functionality of other plugins without
/// extending or implementing their classes.
///
/// Thw wrapped plugin will be hosted from inside this class, and should not be
/// added to a [PluginManager] directly.
///
/// Flow messages will be passed through the wrapped plugin first.
abstract class WrapperBasePlugin<T extends PandoraMitmPlugin>
    extends PandoraMitmPlugin {
  @protected
  final T inner;

  const WrapperBasePlugin(this.inner);

  @override
  FutureOr<void> attach() async {
    await super.attach();
    await inner.attach();
    await outerAttach();
  }

  @override
  FutureOr<void> detach() async {
    await outerDetach();
    await inner.detach();
    await super.detach();
  }

  @override
  FutureOr<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      PluginGroup.combineMessageSetSettings([
        inner.getRequestSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
        getOuterRequestSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      ]);

  @override
  FutureOr<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      PluginGroup.combineMessageSetSettings([
        inner.getResponseSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
        getOuterResponseSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      ]);

  @override
  FutureOr<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      PluginGroup.combineMessageSets(
        apiRequest,
        response,
        [
          (apiRequest, response) => inner.handleRequest(
                flowId,
                apiRequest,
                response,
              ),
          (apiRequest, response) => handleOuterRequest(
                flowId,
                apiRequest,
                response,
              ),
        ],
      );

  @override
  FutureOr<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      PluginGroup.combineMessageSets(
        apiRequest,
        response,
        [
          (apiRequest, response) => inner.handleResponse(
                flowId,
                apiRequest,
                response,
              ),
          (apiRequest, response) => handleOuterResponse(
                flowId,
                apiRequest,
                response,
              ),
        ],
      );

  @protected
  @mustCallSuper
  FutureOr<void> outerAttach() => super.attach();

  @protected
  @mustCallSuper
  FutureOr<void> outerDetach() => super.detach();

  @protected
  FutureOr<MessageSetSettings> getOuterRequestSetSettings(
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

  @protected
  FutureOr<MessageSetSettings> getOuterResponseSetSettings(
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

  @protected
  FutureOr<PandoraMessageSet> handleOuterRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      super.handleRequest(flowId, apiRequest, response);

  @protected
  FutureOr<PandoraMessageSet> handleOuterResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      super.handleResponse(flowId, apiRequest, response);
}
