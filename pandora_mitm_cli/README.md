# pandora_mitm_cli

A CLI exposing some basic [pandora_mitm] functionality.

## Features
- [mitmproxy] UI enhancements
  - Decryption
  - API response `Content-Type` corrections
  - Request boilerplate removal
- API message object definition inference (served over HTTP)
- Feature unlocking
- Reauthentication
- Logging

## Getting started

### Setup

Follow the [pandora_mitm setup instructions](../pandora_mitm#backend-setup).

### Usage

#### CLI

1. Install the tool (with [Dart](https://dart.dev/get-dart)):
   ```shell
   dart pub global activate -s path ./pandora_mitm_cli
   ```
2. Profit!
   ```
   $ pandora-mitm --help
   
   Pandora MITM CLI (standard edition)
   Program options:
   -h, --help                              Print program or plugin usage information.
   
             [all]                         Print usage information for the program and all plugins.
             [feature_unlock]              Print usage information for the feature_unlock plugin.
             [inference]                   Print usage information for the inference plugin.
             [lite_log]                    Print usage information for the lite_log plugin.
             [log]                         Print usage information for the log plugin.
             [modification_detector]       Print usage information for the modification_detector plugin.
             [reauthenticate]              Print usage information for the reauthenticate plugin.
             [ui_helper]                   Print usage information for the ui_helper plugin.
   
       --host                              The hostname or IP address of the mitmproxy remote interceptions server.
                                           (defaults to "localhost")
       --port                              The port of the mitmproxy remote interceptions server.
                                           (defaults to "8082")
   -t, --template                          A template plugin list to use.
   
             [cli]                         A template for performant CLI logging. (lite_log)
             [ui] (default)                A template to enhance the mitmproxy UI experience. (log,ui_helper)
             [unlock]                      A template for unlocking features. (lite_log,modification_detector,reauthenticate,feature_unlock,modification_detector)
             [unlock-ui]                   A cross between the unlock and ui templates. (log,modification_detector,reauthenticate,feature_unlock,modification_detector,ui_helper)
   
   -p, --plugins                           A comma-separated list of plugins to use.
   
             [feature_unlock]              Unlocks several features in the Pandora app.
             [inference]                   Infers API request and response definitions over time. (large potential performance impact)
             [lite_log]                    Logs all API request and response methods to the console.
             [log]                         Logs detailed API request and response messages to the console. (large potential performance impact)
             [modification_detector]       Detects modifications across a range of plugins.
             [reauthenticate]              Forces the first Pandora client that connects to reauthenticate. (large potential performance impact)
             [ui_helper]                   Improves the experience in the mitmproxy UI. (large potential performance impact)
   
   Plugin options:
   
   lite_log: Logs all API request and response methods to the console.
   
   log: Logs detailed API request and response messages to the console. (large potential performance impact)
       --log-whitelist                     A list of specific API methods to log.
   
   feature_unlock: Unlocks several features in the Pandora app.
   
   reauthenticate: Forces the first Pandora client that connects to reauthenticate. (large potential performance impact)
   
   inference: Infers API request and response definitions over time. (large potential performance impact)
       --serve-inferences                  Serves inferences over HTTP.
   (defaults to on)
       --inference-no-strip-boilerplate    Disables boilerplate JSON field stripping from API requests.
       --inference-port                    The port to use for the inference HTTP server.
                                           (defaults to "46337")
   
   ui_helper: Improves the experience in the mitmproxy UI. (large potential performance impact)
       --ui-helper-no-strip-boilerplate    Disables boilerplate JSON field stripping from API requests.
   
   modification_detector: Detects modifications across a range of plugins.
   ```

#### Dart

This project doubles as a package that lets you build your own CLI distributions with custom plugins and templates.
Consult the API docs for the `run` function for more information.

Native builds made with `dart compile` for easy distribution can also be done.

[pandora_mitm]: ../pandora_mitm
[mitmproxy]: https://mitmproxy.org
