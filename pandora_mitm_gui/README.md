# Pandora MITM

A Pandora app reverse-engineering toolbox.

![Screenshot](https://user-images.githubusercontent.com/20849728/174468680-acf986d1-7faa-44f0-96c9-3cc33e412af6.png)

## Features
- Dynamic decryption, analysis and modification of Pandora JSON API messages
- Extensibility through a [Dart](https://dart.dev) plugin API
- Built-in plugins that enable:
  - Message recording
  - Feature unlocking
  - Fake authentication token expiration
  - mitmproxy UI enhancements

## Technologies
A rough overview of the technology stack used in this project is as follows:
> [Python](https://python.org)
- [mitmproxy](https://mitmproxy.org)
- [mitmproxy Remote Interceptions](https://github.com/hacker1024/mitmproxy_remote_interceptions)
> [Dart](https://dart.dev)
- [mitmproxy_ri_client](https://github.com/hacker1024/mitmproxy_ri_client.dart)
- [iapetus](https://github.com/EpimetheusMusicPlayer/Iapetus)
- [pandora_mitm](../pandora_mitm)
> [Flutter](https://flutter.dev)
- [pandora_mitm_gui_core](../pandora_mitm_gui_core)

### Also see
- [pandora_mitm_cli](../pandora_mitm_cli)
