/// A [PandoraMitmBackend] should connect to an HTTP message interception
/// backend, and then call the appropriate [PandoraMitmHandler] (or,
/// alternatively, [PandoraMitmRawMessageParser]) methods at the relevant
/// stages.
///
/// See also:
///
/// * [PandoraMitmBackgroundMixin], a [PandoraMitmBackend] implementation that
///   uses a background isolate to handle HTTP message interception and
///   transformation.
/// * [PandoraMitmMitmproxyRiBackendMixin], a [PandoraMitmBackend]
///   implementation that uses mitmproxy and the mitmproxy Remote Interceptions
///   addon.
abstract class PandoraMitmBackend {
  const PandoraMitmBackend._();

  /// A [Future] that completes when the client disconnects from the mitmproxy
  /// Remote Interceptions server.
  Future<void> get done;

  /// Connects to an HTTP message interception backend.
  ///
  /// This method can only be called once in the lifetime of a [PandoraMitm]
  /// object.
  ///
  /// The server [host] and [port] can be overwritten if need be - by default,
  /// they match the mitmproxy Remote Interceptions defaults.
  Future<void> connect({
    String host = 'localhost',
    int port = 8082,
  });

  /// Disconnects from the HTTP message interception backend.
  Future<void> disconnect();
}
