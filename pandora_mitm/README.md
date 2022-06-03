# pandora_mitm

A Dart package featuring a [mitmproxy Remote Interceptions client][ri] that can analyse and modify Pandora JSON API messages.

### [Looking for the CLI?][cli]

## Features

- Decrypt, analyse and modify Pandora JSON API messages with high-level APIs
- Modular extensibility with plugins, including inbuilt solutions for:
  - Logging
  - Recording
  - Feature unlocking
  - Reauthentication
  - mitmproxy UI enhancement
- Parsing and decryption can be done in a background thread for maximum performance

## Getting started

### Setup

1. Set up [mitmproxy].
2. Install the [mitmproxy] HTTPS certificate as a trusted CA on your device or emulator.
   - [On Android emulators](https://docs.mitmproxy.org/stable/howto-install-system-trusted-ca-android)
   - [On rooted Android devices](https://github.com/NVISOsecurity/MagiskTrustUserCerts)

   Alternatively, mod the Android app to disable certificate pinning.
3. Add [mitmproxy] as a proxy server on your device.
   - On Android, [this app may be useful](https://github.com/theappbusiness/android-proxy-toggle).
     Note that most apps that route traffic to proxy servers via a VPN service will not work.
4. Get the [mitmproxy Remote Interceptions][ri] addon.
5. Run `mitmproxy` (or `mitmweb` or `mitmdump`)
   ```shell
   mitmproxy -s path/to/mitmproxy_remote_interceptions.py --allow-hosts android-tuner.pandora.com --set view_filter='^https://android-tuner\.pandora\.com/services/json.*$'
   ```

### CLI

If you just want to use or analyse the Pandora app with some basic inbuilt plugins, this can be done with the [CLI][cli]
project.

### Dart

See the [example](example/pandora_mitm_example.dart) project.

#### Custom plugin creation

Import the plugin development library:

```dart
import 'package:pandora_mitm/plugin_dev.dart';
```

Then, extend the `PandoraMitmPlugin` or a higher-level base class. 

[cli]: https://github.com/EpimetheusMusicPlayer/pandora_mitm_cli
[mitmproxy]: https://mitmproxy.org
[ri]: https://github.com/hacker1024/mitmproxy_remote_interceptions
