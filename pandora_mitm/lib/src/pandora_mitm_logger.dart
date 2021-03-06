import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:pandora_mitm/src/pandora_mitm_backend.dart';
import 'package:pandora_mitm/src/pandora_mitm_handler.dart';

/// A [PandoraMitmLogger] logs various events to a [Logger].
///
/// See also:
///
/// * [PandoraMitmLoggingMixin], a standard [PandoraMitmLogger] implementation.
abstract class PandoraMitmLogger {
  @protected
  Logger get log;
}

/// A standard [PandoraMitmLogger] implementation mixin.
///
/// This mixin should be placed last in the mixin list
mixin PandoraMitmLoggingMixin
    on PandoraMitmBackend, PandoraMitmHandler
    implements PandoraMitmLogger {
  @override
  final log = Logger('pandora_mitm');

  @override
  Future<void> connect({
    String host = 'localhost',
    int port = 8082,
    void Function(Object error, StackTrace)? onError,
  }) async {
    log.info('Connecting to HTTP interception backend ($host:$port)...');
    await super.connect(
      host: host,
      port: port,
      onError: (error, stackTrace) {
        log.severe(
          'Connection to HTTP interception backend failed ($host:$port): $error',
        );
        (onError ?? Error.throwWithStackTrace).call(error, stackTrace);
      },
    );
    log.info('Connected to HTTP interception backend ($host:$port).');
    done.then((_) => log.info('Disconnected from HTTP interception backend.'));
  }

  @override
  Future<void> disconnect() async {
    log.info('Disconnecting from HTTP interception backend...');
    await super.disconnect();
  }
}
