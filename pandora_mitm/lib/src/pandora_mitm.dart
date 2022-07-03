import 'package:pandora_mitm/src/pandora_mitm_backend.dart';
import 'package:pandora_mitm/src/pandora_mitm_handler.dart';
import 'package:pandora_mitm/src/pandora_mitm_logger.dart';
import 'package:pandora_mitm/src/plugin_manager.dart';

/// An object that can intercept and modify Pandora JSON API requests and
/// responses.
///
/// Typical [PandoraMitm] implementations use an architecture consisting of a
/// [PandoraMitmBackend], [PandoraMitmHandler], and [PandoraMitmLogger]
/// implementation via mixins. Some [PandoraMitmBackend]s may also need a
/// [PandoraMitmRawMessageParser] implementation mixed in as well.
///
/// Consult the API documentation on these classes for more information.
///
/// Note: mitmproxy_ri_client data structures are used to contain some HTTP
/// data, but implementations do not necessarily need to use mitmproxy_ri_client
/// as their HTTP interception backend.
///
/// See also:
///
/// * [ForegroundMitmproxyRiPandoraMitm], a typical [PandoraMitm]
/// implementation.
abstract class PandoraMitm
    implements PandoraMitmBackend, PandoraMitmHandler, PandoraMitmLogger {
  // This class should be implemented, not extended.
  PandoraMitm._();
}

/// A [PandoraMitm] variant that can use [PandoraMitmPlugin]s.
abstract class PluginCapablePandoraMitm implements PandoraMitm, PluginCapable {}
