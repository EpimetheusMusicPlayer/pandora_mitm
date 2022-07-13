# pandora_mitm

A Dart package for analysing and modifying Pandora JSON API messages.

### Looking for the [GUI][gui] or [CLI][cli]?

## Features

- Decrypt, analyse and modify Pandora JSON API messages with high-level APIs
- Modular extensibility with plugins, including inbuilt solutions for:
  - Logging
  - Recording
  - API message object definition inference
  - Feature unlocking
  - Reauthentication
  - mitmproxy UI enhancement
- An extremely modular architecture, meaning
  - Multithreading is easily accessible
    - Parsing and decryption can be done in a background thread for maximum performance
    - Plugins can manage their own background threads
  - HTTP interception backends can be implemented with ease, with inbuilt
    solutions for:
    - [mitmproxy Remote Interceptions][ri]

## Getting started

### Backend setup

#### mitmproxy Remote Interceptions
1. Set up [mitmproxy].
2. Install the [mitmproxy] HTTPS certificate as a trusted CA on your device or emulator.
   - [On Android emulators](https://docs.mitmproxy.org/stable/howto-install-system-trusted-ca-android)
   - [On rooted Android devices](https://github.com/NVISOsecurity/MagiskTrustUserCerts)

   Alternatively, on non-rooted Android devices, [mod the Android app](https://erev0s.com/blog/new-flag-in-apktool-for-automatic-generic-network-configuration) to disable certificate pinning.
3. Add [mitmproxy] as a proxy server on your device.
   - On Android, [this app may be useful](https://github.com/theappbusiness/android-proxy-toggle).
     Note that most apps that route traffic to proxy servers via a VPN service will not work.
4. Get the [mitmproxy Remote Interceptions][ri] addon.
5. Run `mitmproxy` (or `mitmweb` or `mitmdump`)
   ```shell
   mitmproxy -s path/to/mitmproxy_remote_interceptions.py --allow-hosts android-tuner.pandora.com --set view_filter='^https://android-tuner\.pandora\.com/services/json.*$'
   ```

### GUI
A useful [GUI][gui] is provided.

### CLI

If you just want to use or analyse the Pandora app with some basic inbuilt plugins, this can be done with the [CLI][cli]
project.

### Dart

1. Add the package to your `pubspec.yaml`:
   ```yaml
   dependencies:
     pandora_mitm:
       git:
         url: 'https://github.com/EpimetheusMusicPlayer/pandora_mitm.git'
         path: pandora_mitm
         ref: master # Or a tag, commit, secondary branch, etc.
   ```
2. Import the libraries:
   ```dart
   import 'package:pandora_mitm/pandora_mitm.dart';
   import 'package:pandora_mitm/plugins.dart' as pmplg;
   ```
4. See the [example](example/pandora_mitm_example.dart) project and API docs.

#### Custom plugin creation

1. Import the plugin development library:
   ```dart
   import 'package:pandora_mitm/plugin_dev.dart';
   ```

2. Extend the `PandoraMitmPlugin` or a higher-level base class.
3. Consult the API docs.

[cli]: ../pandora_mitm_cli
[gui]: ../pandora_mitm_gui
[mitmproxy]: https://mitmproxy.org
[ri]: https://github.com/hacker1024/mitmproxy_remote_interceptions
